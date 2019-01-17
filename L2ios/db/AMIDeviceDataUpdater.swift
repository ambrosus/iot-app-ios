//
//  Created by Sergei E. on 1/16/19.
//  (c) 2019 Ambrosus. All rights reserved.
//  

import Foundation
import CoreBluetooth
import GRDB

@objc class AMIDeviceDataUpdater : NSObject {
    enum State : Int {
        case st_discovered = 0
        case st_connected
        case st_discoverServices
        case st_discoverCharacteristics
        case st_readBattery
        case st_write
        case st_read
    }
    
    enum Action {
        case ac_readRSSI
        case ac_readBattery
        case ac_readSignal(points:Int)
        case ac_disconnect
    }
    
    enum Event : Int {
        case ev_connect = 0
        case ev_discoverServices
        case ev_discoverCharacteristics
        case ev_write
        case ev_setNotify
        case ev_dataArrived
        case ev_disconnect
    }
    
    enum Payload {
        case empty
        case string(String)
        case number(NSNumber)
        case data(Data)
        case cbuuid(CBUUID)
        case svcs([CBService])
        case chs([CBCharacteristic])
    }
    
    var uuid: UUID
    var state: State = .st_discovered
    var actions: [Action] = [.ac_readRSSI, .ac_readBattery, .ac_disconnect]
    var peripheral: CBPeripheral?
    var record = AMIDeviceRecord()
    var bytesAvailable:Int = 0
    
    init(uuid:UUID) {
        self.uuid = uuid
        super.init()
        if let fetchedRecord = AMIDBQueries.fetchDeviceWithUUID(uuid.uuidString) {
            record = fetchedRecord
            record.restoreTransientData()
        }
    }
    
    func step(_ central: CBCentralManager, _ peripheral: CBPeripheral, _ ev:Event, _ payload:Payload) -> Bool {
        switch ev {
            case .ev_connect:
                return _onConnect(central, peripheral, ev, payload)
            case .ev_discoverServices:
                return _onDiscoverServices(central, peripheral, ev, payload)
            case .ev_discoverCharacteristics:
                return _onDiscoverCharacteristics(central, peripheral, ev, payload)
            case .ev_write:
                return _onWrite(central, peripheral, ev, payload)
            case .ev_setNotify:
                return _onSetNotify(central, peripheral, ev, payload)
            case .ev_dataArrived:
                return _onDataArrived(central, peripheral, ev, payload)
            case .ev_disconnect:
                return _onDisconnect(central, peripheral, ev, payload)
        }
    }
    
    private func _onConnect(_ central: CBCentralManager, _ peripheral: CBPeripheral, _ ev:Event, _ payload:Payload) -> Bool {
        if state == .st_discovered {
            state = .st_connected
            self.peripheral = peripheral
            central.connect(peripheral, options: nil)
            return true
        }
        
        return false
    }
    
    private func _onDiscoverServices(_ central: CBCentralManager, _ peripheral: CBPeripheral, _ ev:Event, _ payload:Payload) -> Bool {
        if state == .st_connected {
            state = .st_discoverServices
            peripheral.discoverServices([AMIBLECentral.ambServiceUUID, AMIBLECentral.batteryServiceUUID])
            return true
        }
        
        return false
    }
    
    private func _onDiscoverCharacteristics(_ central: CBCentralManager, _ peripheral: CBPeripheral, _ ev:Event, _ payload:Payload) -> Bool {
        if state == .st_discoverServices {
            if case let .svcs(svcs) = payload  {
                state = .st_discoverCharacteristics
                for svc in svcs {
                    if (svc.uuid.isEqual(AMIBLECentral.ambServiceUUID)) {
                        //peripheral.discoverCharacteristics([AMIBLECentral.ambInUUID, AMIBLECentral.ambOutUUID], for: svc)
                    }
                    else if (svc.uuid.isEqual(AMIBLECentral.batteryServiceUUID)) {
                        peripheral.discoverCharacteristics([AMIBLECentral.batteryCharacteristicUUID], for: svc)
                    }
                }
                
                return true
            }
        }
        
        return false
    }
    
    private func _onWrite(_ central: CBCentralManager, _ peripheral: CBPeripheral, _ ev:Event, _ payload:Payload) -> Bool {
        if state == .st_discoverCharacteristics {
            if case let .chs(chs) = payload  {
                for characteristic in chs {
                    if characteristic.uuid.isEqual(AMIBLECentral.ambOutUUID) {
                        let readSensorsRecord = NSData.apdu_readRecord(withP1: 0, p2: 2, le: 16)
                        print("--> \(NSData.init(data:readSensorsRecord).formattedHex(withLineSize: 16))")
                        peripheral.writeValue(readSensorsRecord, for: characteristic, type: .withResponse)
                        state = .st_write
                        return true
                    }
                    else if characteristic.uuid.isEqual(AMIBLECentral.batteryCharacteristicUUID) {
                        peripheral.readValue(for: characteristic)
                        state = .st_write
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    private func _onSetNotify(_ central: CBCentralManager, _ peripheral: CBPeripheral, _ ev:Event, _ payload:Payload) -> Bool {
        if state == .st_write {
            if case let .chs(chs) = payload  {
                for characteristic in chs {
                    if characteristic.uuid.isEqual(AMIBLECentral.ambInUUID) {
                        peripheral.setNotifyValue(true, for: characteristic)
                        print("setNotifyValue")
                        state = .st_read
                        return true
                    }
                    else if characteristic.uuid.isEqual(AMIBLECentral.batteryCharacteristicUUID) {
                        state = .st_readBattery
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    private func _onDataArrived(_ central: CBCentralManager, _ peripheral: CBPeripheral, _ ev:Event, _ payload:Payload) -> Bool {
        if state == .st_read {
            if case let .data(data) = payload  {
                let hex = NSData.init(data: data).formattedHex(withLineSize: 16)
                print("<-- (\(data.count))\n\(hex)")
                
                if data.count >= 16 {
                    return true
                }
            }
        }
        else if state == .st_readBattery {
            if case let .data(data) = payload  {
                let batteryPercentageUint8 = data.withUnsafeBytes { (ptr: UnsafePointer<UInt8>) -> UInt8 in
                    return ptr.pointee
                }
                
                record.battery = Double(batteryPercentageUint8)
                record.batteryUnit = .percents
            }
        }
            
        return false
    }
    
    private func _onDisconnect(_ central: CBCentralManager, _ peripheral: CBPeripheral, _ ev:Event, _ payload:Payload) -> Bool {
        central.cancelPeripheralConnection(peripheral)
        state = .st_discovered
        return true
    }
    
    func propagateChanges() {
        record.lastSeenTS = CACurrentMediaTime()
        record.batteryBuffer.push(x: record.battery)
        record.rssiBuffer.push(x: record.rssi)
        print("\(record.uuid) pushed \(record.rssiBuffer.length)")
        AMIDBQueries.saveDeviceRecord(&record)
        record.saveTransientData()
    }
}
