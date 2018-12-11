//
//  Created by Sergei E. on 12/11/18.
//  (c) 2018 Ambrosus. All rights reserved.
//  

import Foundation
import GRDB

@objc class AMIDBCentral: NSObject {
    var dbQueue : DatabaseQueue? = {
        return AMIDBStarter.sharedInstance.dbQueue
    } ()
    
    @objc public func devices() -> Array<Data> {
        AMIDeviceEntity.orderedByTSAdded()
    }
}
