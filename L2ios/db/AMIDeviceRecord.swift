//
//  Created by Sergei E. on 12/11/18.
//  (c) 2018 Ambrosus. All rights reserved.
//  

import GRDB

class AMIRingBuffer : NSObject {
    @objc let capacity:Int
    @objc let data:NSMutableData
    @objc var offset:Int
    @objc var length:Int
    
    init(capacity:Int) {
        self.capacity = capacity
        self.data = NSMutableData(length: capacity * MemoryLayout<Double>.size)!
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
    
    enum HWType : Int, Codable {
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
    
    public static var databaseTableName = "device"
    
    //db vars
    var id: Int64? = nil
    var hwtype: HWType = .unknown
    var uuid: String = ""
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
    var pressure: Double = 0.0
    var humidity: Double = 0.0
    var unreachableFlag: Bool = false
    var active: Bool = false
    var signal: Data = Data()
    var signalUnixTS: UInt32 = 0
    var signalRate: Double = 1.0
    
    //transient vars
    @objc var batteryBuffer = AMIRingBuffer(capacity: 1000)
    @objc var rssiBuffer = AMIRingBuffer(capacity: 1000)
    
    fileprivate enum CodingKeys: String, CodingKey, ColumnExpression {
        case id, hwtype, uuid, macaddr, broadcastedName, baseName, userAssignedName,
            addedTS, lastSeenTS, battery, batteryUnit, rssi, temperature, pressure, humidity, unreachableFlag, active,
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
        let deviceName = "MockTag \(number / 2)"
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
        device.rssi = 3.0
        device.temperature = 20.0
        device.pressure = 101000.0
        device.humidity = 0.6
        device.unreachableFlag = false
        device.active = true
        device.signal = Data()
        return device
    }
    
    func batteryText() -> String {
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
        let buffers = [batteryBuffer, rssiBuffer]
        AMITransientBufStore.map[uuid] = buffers
    }
    
    func restoreTransientData() {
        if let buffers = AMITransientBufStore.map[uuid] {
            batteryBuffer = buffers[0]
            rssiBuffer = buffers[1]
        }
    }
}
