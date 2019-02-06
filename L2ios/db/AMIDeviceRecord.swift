//
//  Created by Sergei E. on 12/11/18.
//  (c) 2018 Ambrosus. All rights reserved.
//  

import GRDB

@objc class AMIRingBuffer : NSObject {
    @objc let capacity:Int
    @objc let data:NSMutableData
    @objc var offset:Int
    @objc var length:Int
    
    init(capacity:Int) {
        self.capacity = capacity
        self.data = NSMutableData(length: capacity * MemoryLayout<Double>.size)!
        self.data.fillWithDoubleNans()
        self.offset = 0
        self.length = 0
        super.init()
    }
    
    @objc func push(x: Double) {
        let stride = MemoryLayout<Double>.size
        withUnsafeBytes(of: x) { ptr in
            memcpy(data.mutableBytes.advanced(by: (offset % capacity) * stride), ptr.baseAddress, stride)
            length += 1
            offset = (offset + 1) % capacity
        }
    }
}

class AMIDeviceRecord : NSObject, Codable, FetchableRecord, MutablePersistableRecord {
    public enum HWType : Int, Codable {
        case unknown = 0
        case ambl1 = 1
        case ruuvitag = 2
        case ambSimulated = 3
        case ambMockDevice = 4
    }
    
    enum HWBatteryUnit : Int, Codable {
        case volts = 0
        case millivolts
        case percents
    }
    
    enum AMIDRSensorPresence : Int, Codable {
        case notSupported = 0
        case notSampled
        case present
    }
    
    public static var databaseTableName = "device"
    
    //db vars
    var id: Int64? = nil
    var hwtype: HWType = .unknown
    var uuid: String = "" {
        didSet {
            restoreTransientData()
        }
    }
    var macaddr: String = ""
    var broadcastedName: String = ""
    var baseName: String = ""
    var userAssignedName: String = ""
    var addedTS: Double = 0.0
    var lastSeenTS: Double = 0.0
    var battery: Double = 0.0
    var batteryUnit: HWBatteryUnit = .volts
    var rssi: Double = 0.0
    var temperature: Double = 0.0
    var temperaturePresence: AMIDRSensorPresence = .notSampled
    var pressure: Double = 0.0
    var pressurePresence: AMIDRSensorPresence = .notSampled
    var humidity: Double = 0.0
    var humidityPresence: AMIDRSensorPresence = .notSampled
    var unreachableFlag: Bool = false
    var active: Bool = false
    var signal: Data = Data()
    var signalUnixTS: UInt32 = 0
    var signalRate: Double = 1.0
    
    //transient vars
    @objc var batteryBuffer = AMIRingBuffer(capacity: 3600)
    @objc var rssiBuffer = AMIRingBuffer(capacity: 3600)
    @objc var temperatureBuffer = AMIRingBuffer(capacity: 3600)
    @objc var pressureBuffer = AMIRingBuffer(capacity: 3600)
    @objc var humidityBuffer = AMIRingBuffer(capacity: 3600)
    
    fileprivate enum CodingKeys: String, CodingKey, ColumnExpression {
        case id, hwtype, uuid, macaddr, broadcastedName, baseName, userAssignedName,
            addedTS, lastSeenTS, battery, batteryUnit, rssi,
            temperature, temperaturePresence, pressure, pressurePresence, humidity, humidityPresence,
            unreachableFlag, active,
            signal, signalUnixTS, signalRate
    }
    
    func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
    
    static func orderedByBroadcastedName() -> QueryInterfaceRequest<AMIDeviceRecord> {
        return AMIDeviceRecord.order(CodingKeys.broadcastedName)
    }
    
    static func orderedByUserAssignedName() -> QueryInterfaceRequest<AMIDeviceRecord> {
        return AMIDeviceRecord.order(CodingKeys.userAssignedName)
    }
    
    static func orderedByTSLastSeen() -> QueryInterfaceRequest<AMIDeviceRecord> {
        return AMIDeviceRecord.order(CodingKeys.lastSeenTS)
    }
    
    static func orderedByTSAdded() -> QueryInterfaceRequest<AMIDeviceRecord> {
        return AMIDeviceRecord.order(CodingKeys.addedTS)
    }
    
    static func mockDevice(_ number:Int) -> AMIDeviceRecord {
        let deviceName = "MockTag \(number + 1)"
        let device = AMIDeviceRecord()
        device.hwtype = .ambSimulated
        device.uuid = NSUUID().uuidString
        device.macaddr = "01:02:03:04:05:".appendingFormat("%02d", number)
        device.broadcastedName = deviceName
        device.baseName = "MockTag"
        device.userAssignedName = "Dev \(number)"
        device.addedTS = CACurrentMediaTime()
        device.lastSeenTS = device.addedTS
        
        let numberDivisor3 = number % 3
        switch (numberDivisor3) {
        case 0:
            device.battery = 3.3
            device.batteryUnit = .volts
        case 1:
            device.battery = 70
            device.batteryUnit = .percents
        default:
            device.battery = 3200
            device.batteryUnit = .millivolts
        }
        
        device.battery = 3.3
        device.batteryUnit = .volts
        device.rssi = -20.0
        device.temperature = 20.0
        device.pressure = 101000.0
        device.humidity = 0.6
        device.unreachableFlag = false
        device.active = true
        device.signal = Data()
        return device
    }
    
    func batteryText() -> String? {
        switch batteryUnit {
        case .volts:
            return String(format:"%.1fV", battery)
        case .millivolts:
            return String(format:"%.1fV", battery / 1000.0)
        case .percents:
            return String(format:"%.0f%%", battery)
        }
    }
    
    func saveTransientData() {
        let buffers = [batteryBuffer, rssiBuffer, temperatureBuffer, pressureBuffer, humidityBuffer]
        AMITransientBufStore.map[uuid] = buffers
    }
    
    func restoreTransientData() {
        if let buffers = AMITransientBufStore.map[uuid] {
            batteryBuffer = buffers[0]
            rssiBuffer = buffers[1]
            temperatureBuffer = buffers[2]
            pressureBuffer = buffers[3]
            humidityBuffer = buffers[4]
        }
    }
    
    private func _supportedSensorPresences(presences:[AMIDRSensorPresence]) -> Int {
        var result:Int = 0
        for p in presences {
            if (p != .notSupported) {
                result += 1
            }
        }
        
        return result
    }
    
    func availableSensorsCount() -> Int {
        if (hwtype == .ambl1) {
            return 2
        }
        else {
            return _supportedSensorPresences(presences: [temperaturePresence, pressurePresence, humidityPresence]) + 2
        }
    }
    
    func availableSensorTypes() -> [AMISensorType] {
        var result:[AMISensorType] = []
        if (hwtype == .ambl1) {
            result = [.batteryPercentage, .rssi]
        }
        else {
            result = [.batteryVoltage, .rssi]
            if temperaturePresence != .notSupported {
                result.append(.thermometer)
            }
            if pressurePresence != .notSupported {
                result.append(.manometer)
            }
            if humidityPresence != .notSupported {
                result.append(.hygrometer)
            }
        }
        
        return result
    }
    
    func sensorBuffer(withType sensorType: AMISensorType) -> AMIRingBuffer? {
        switch sensorType {
        case .thermometer:
            if temperaturePresence != .notSupported {
                return self.temperatureBuffer
            }
        case .hygrometer:
            if humidityPresence != .notSupported {
                return self.humidityBuffer
            }
        case .manometer:
            if pressurePresence != .notSupported {
                return self.pressureBuffer
            }
            
        case .batteryVoltage:
            return self.batteryBuffer
            
        case .batteryPercentage:
            return self.batteryBuffer
            
        case .rssi:
            return self.rssiBuffer
        default:
            break
        }
        
        return nil
    }
    
    func sensorValue(withType sensorType: AMISensorType) -> Double? {
        switch sensorType {
        case .thermometer:
            return temperature
        case .hygrometer:
            return humidity
        case .manometer:
            return pressure
        case .batteryVoltage:
            return battery
        case .batteryPercentage:
            return battery
        case .rssi:
            return rssi
        default:
            return nil
        }
    }
}
