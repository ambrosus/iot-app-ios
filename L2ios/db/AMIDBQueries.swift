//
//  Created by Sergei E. on 1/17/19.
//  (c) 2019 Ambrosus. All rights reserved.
//  

import Foundation
import GRDB

class AMIDBQueries: NSObject {
    static var dbQueue: DatabaseQueue? {
        return AMIDBStarter.sharedInstance.dbQueue
    }
    
    static func allDevices() -> [AMIDeviceRecord]? {
        return try! dbQueue?.read{ db in
            try AMIDeviceRecord.fetchAll(db)
        }
    }
    
    static func fetchDeviceWithUUID(_ uuid:String) -> AMIDeviceRecord? {
        let result = try! dbQueue?.read{ db in
            try AMIDeviceRecord.fetchOne(db, "SELECT * FROM device where uuid = ?", arguments:[uuid])
        }
        
        return result
    }
    
    static func saveDeviceRecord(_ record:inout AMIDeviceRecord) {
        try! dbQueue?.write{ db in
            if let _ = record.id {
                try record.update(db)
            }
            else {
                try record.insert(db)
            }
            
            record.saveTransientData()
        }
    }
    
}
