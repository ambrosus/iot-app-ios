//
//  Created by Sergei E. on 12/11/18.
//  (c) 2018 Ambrosus. All rights reserved.
//  

import Foundation
import CoreBluetooth
import GRDB


@objc class AMIGAPMonitor: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    @objc static let sharedInstance = AMIGAPMonitor()
    
    var dbQueue : DatabaseQueue? = {
        return AMIDBStarter.sharedInstance.dbQueue
    } ()
    
    private var centralManager: CBCentralManager
    private let dataDispatchQueue: DispatchQueue
    private let scanOptions:[String : Any] = [CBCentralManagerScanOptionAllowDuplicatesKey: NSNumber(value: true)]
    
    override init() {
        self.dataDispatchQueue = DispatchQueue(label: "BLEDQueue")
        
        self.centralManager = CBCentralManager(delegate: nil, queue: self.dataDispatchQueue, options: scanOptions)
        
        super.init()
        
        self.centralManager.delegate = self
    }
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            central.scanForPeripherals(withServices: nil, options: self.scanOptions)
        default:
            debugPrint("Central manager state", central.state)
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let manufacturerData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data {
            if let ruuviFrame = AMIRuuviFrame.init(dataFrame: manufacturerData) {
                self.updateRuuviFrame(ruuviFrame, rssi: RSSI, uuid: peripheral.identifier)
            }
        }
        else if let peripheralName = peripheral.name {
            if let dataInName = Data.init(base64Encoded: peripheralName) {
                if let ruuviFrame = AMIRuuviFrame.init(dataFrame: dataInName) {
                    self.updateRuuviFrame(ruuviFrame, rssi: RSSI, uuid: peripheral.identifier)
                }
            }
        }
    }
    
    public func updateRuuviFrame(_ frame:AMIRuuviFrame, rssi: NSNumber, uuid:UUID) {
        debugPrint("discovered ", uuid, frame.humidity, frame.temperature, frame.pressure)
    }
    
    public func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        debugPrint("DELE01")
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        debugPrint("DELE02")
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        debugPrint("DELE03")
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        debugPrint("DELE04")
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        debugPrint("DELE05")
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        debugPrint("DELE06")
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        debugPrint("DELE07")
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        debugPrint("DELE08")
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        debugPrint("DELE09")
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        debugPrint("DELE10")
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        debugPrint("DELE11")
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        debugPrint("DELE12")
    }
    
    public func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
        debugPrint("DELE13")
    }
}
