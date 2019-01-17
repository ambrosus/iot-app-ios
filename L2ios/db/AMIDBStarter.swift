//
//  Created by Sergei E. on 12/11/18.
//  (c) 2018 Ambrosus. All rights reserved.
//  

import UIKit
import GRDB

@objc class AMIDBStarter : NSObject {
    @objc static let sharedInstance = AMIDBStarter()
    
    public var dbQueue : DatabaseQueue? = nil
    
    @objc public func setupDatabase() {
        let fm = FileManager.default
        let url = try! fm.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let dbURL = url.appendingPathComponent("ami.sqlite")
        print("DB url: \(dbURL.path)")
        
        if AMIDBFlags.recreateDBOnEachStart {
            try? fm.removeItem(at:dbURL)
        }
        
        var conf = Configuration()
        
        if AMIDBFlags.logSQL {
            conf.trace = { print($0) }
        }
        
        conf.maximumReaderCount = AMIDBFlags.maximumReaderCount
        
        let dbQueue = try! DatabaseQueue(path: dbURL.path, configuration:conf)
        
        try! dbQueue.inDatabase { db in
            try db.execute("PRAGMA page_size=\(AMIDBFlags.pageSize); VACUUM;")
        }
        
        try! migrator.migrate(dbQueue)
        dbQueue.setupMemoryManagement(in: UIApplication.shared)
        self.dbQueue = dbQueue
    }
    
    lazy var migrator: DatabaseMigrator = {
        var migrator = DatabaseMigrator()
        
        migrator.registerMigration("m0001_initial_schema") { db in
            try db.create(table: "device") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("hwtype", .integer).notNull()
                t.column("uuid", .text).notNull()
                t.column("macaddr", .text).notNull()
                t.column("broadcastedName", .text).notNull()
                t.column("baseName", .text).notNull()
                t.column("userAssignedName", .text).notNull()
                t.column("addedTS", .integer).notNull()
                t.column("lastSeenTS", .integer).notNull()
                t.column("battery", .double).notNull()
                t.column("batteryUnit", .integer).notNull()
                t.column("rssi", .double).notNull()
                t.column("temperature", .double).notNull()
                t.column("pressure", .double).notNull()
                t.column("humidity", .double).notNull()
                t.column("unreachableFlag", .boolean).notNull()
                t.column("active", .boolean).notNull()
                t.column("signal", .blob).notNull()
                t.column("signalUnixTS", .integer).notNull()
                t.column("signalRate", .double).notNull()
            }
        }
        
        if AMIDBFlags.isSimulator {
            migrator.registerMigration("m0002_test_populate") { db in
                for ctr:Int in 0..<3 {
                    var device = AMIDeviceRecord.mockDevice(ctr)
                    try device.insert(db)
                }
            }
        }
        
        return migrator
    }()
}
