//
//  Created by Sergei E. on 12/11/18.
//  (c) 2018 Ambrosus. All rights reserved.
//  

import UIKit
import GRDB

struct Platform {
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
}

@objc class AMIDBStarter : NSObject {
    @objc static let sharedInstance = AMIDBStarter()
    
    public var dbQueue : DatabaseQueue? = nil
    
    @objc public func setupDatabase() {
        let fm = FileManager.default
        let url = try! fm.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let dbURL = url.appendingPathComponent("ami.sqlite")
        print("DB url: \(dbURL.path)")
        try? fm.removeItem(at:dbURL)
        
        var conf = Configuration()
        conf.trace = { print($0) }
        conf.maximumReaderCount = 3
        
        let dbQueue = try! DatabaseQueue(path: dbURL.path, configuration:conf)
        try! dbQueue.inDatabase { db in
            try db.execute("PRAGMA page_size=8192; VACUUM;")
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
                t.column("udid", .text).notNull()
                t.column("macaddr", .text).notNull()
                t.column("broadcastedName", .text).notNull()
                t.column("baseName", .text).notNull()
                t.column("userAssignedName", .text).notNull()
                t.column("addedTS", .integer).notNull()
                t.column("lastSeenTS", .integer).notNull()
                t.column("battery", .double).notNull()
                t.column("rssi", .double).notNull()
                t.column("temperature", .double).notNull()
                t.column("pressure", .double).notNull()
                t.column("humidity", .double).notNull()
                t.column("unreachableFlag", .boolean).notNull()
                t.column("active", .boolean).notNull()
                t.column("signal", .blob).notNull()
            }
        }
        
        if Platform.isSimulator {
            migrator.registerMigration("m0002_test_populate") { db in
                for ctr:Int in 0..<3 {
                    let deviceName = "MockTag \(ctr / 2)"
                    var device = AMIDeviceRecord()
                    device.hwtype = .ambSimulated
                    device.udid = NSUUID().uuidString
                    device.macaddr = "01:02:03:04:05:".appendingFormat("%02d", ctr)
                    device.broadcastedName = deviceName
                    device.baseName = "MockTag"
                    device.userAssignedName = "Dev \(ctr)"
                    device.addedTS = CACurrentMediaTime()
                    device.lastSeenTS = device.addedTS
                    device.battery = 3.3
                    device.rssi = 3.0
                    device.temperature = 20.0
                    device.pressure = 101000.0
                    device.humidity = 0.6
                    device.unreachableFlag = false
                    device.active = true
                    device.signal = Data()
                    try device.insert(db)
                }
            }
        }
        
        return migrator
    }()
}
