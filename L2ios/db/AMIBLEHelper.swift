//
//  Created by Sergei E. on 1/13/19.
//  (c) 2019 Ambrosus. All rights reserved.
//  

import Foundation
import CoreBluetooth

class AMIBLEHelper {
    static func isPeripheralAMBL1(_ peripheral:CBPeripheral) -> Bool {
        if let name = peripheral.name {
            if name.hasPrefix("AMBL1") {
                return true
            }
        }
        
        return false
    }
    
    static func isPeripheralDisconnected(_ peripheral:CBPeripheral) -> Bool {
        let periphState = peripheral.state
        return periphState == .disconnected
    }
}
