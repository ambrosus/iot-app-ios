//
//  Created by Sergei E. on 1/13/19.
//  (c) 2019 Ambrosus. All rights reserved.
//  

import Foundation
import CoreBluetooth

class AMIBLEHelper {
    static func isPeripheralAMBL1(_ peripheral:CBPeripheral, advertisementData: [String : Any]) -> Bool {
        if let name = peripheral.name {
            if name.hasPrefix("AMBL1") {
                return true
            }
        }
        
        return false
    }
    
    static func isPeripheralRuuviCompatible(_ peripheral:CBPeripheral, advertisementData: [String : Any]) -> Bool {
        if let name = peripheral.name, let dataFrame = Data.init(base64Encoded: name) {
            return AMIRuuviFrame.dataFrameIsRuuviCompatible(dataFrame)
        }
        
        if let dataFrame = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data {
            return AMIRuuviFrame.dataFrameIsRuuviCompatible(dataFrame)
        }
        
        return false
    }
    
    static func ruuviFrameFromADVData(ofPeripheral peripheral:CBPeripheral, advertisementData: [String : Any]) -> AMIRuuviFrame? {
        if let name = peripheral.name, let dataFrame = Data.init(base64Encoded: name) {
                return AMIRuuviFrame.init(dataFrame: dataFrame)
        }
        
        if let dataFrame = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data {
            return AMIRuuviFrame.init(dataFrame: dataFrame)
        }
        
        return nil
    }
    
    static func fakeRuuviFrameFromName(ofPeripheral peripheral:CBPeripheral, advertisementData: [String : Any]) -> AMIRuuviFrame? {
        if let name = peripheral.name {
            if let dataInName = Data.init(base64Encoded: name) {
                return AMIRuuviFrame.init(dataFrame: dataInName)
            }
        }
        
        return nil
    }
    
    static func isPeripheralDisconnected(_ peripheral:CBPeripheral) -> Bool {
        let periphState = peripheral.state
        return periphState == .disconnected
    }
}
