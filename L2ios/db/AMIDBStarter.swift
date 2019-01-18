//
//  Created by Sergei E. on 12/11/18.
//  (c) 2018 Ambrosus. All rights reserved.
//  

import UIKit
import GRDB

@objc class AMIDBStarter : NSObject {
    @objc static let sharedInstance = AMIDBStarter()
    
    public var dbQueue : DatabaseQueue? = nil
    var mockUpdateTimer : Timer?
    
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
                t.column("temperaturePresence", .integer).notNull()
                t.column("pressure", .double).notNull()
                t.column("pressurePresence", .integer).notNull()
                t.column("humidity", .double).notNull()
                t.column("humidityPresence", .integer).notNull()
                t.column("unreachableFlag", .boolean).notNull()
                t.column("active", .boolean).notNull()
                t.column("signal", .blob).notNull()
                t.column("signalUnixTS", .integer).notNull()
                t.column("signalRate", .double).notNull()
            }
        }
        
        if AMIDBFlags.isSimulator {
            migrator.registerMigration("m0002_test_populate") { db in
                for ctr:Int in 0..<10 {
                    var device = AMIDeviceRecord.mockDevice(ctr)
                    device.temperaturePresence = Int.random(in: 0..<10) < 5 ? .present : .notSupported
                    device.pressurePresence = Int.random(in: 0..<10) < 5 ? .present : .notSupported
                    if ((device.temperaturePresence == .notSupported) && (device.pressurePresence == .notSupported)) {
                        device.humidityPresence = .present
                    }
                    else {
                        device.humidityPresence = Int.random(in: 0..<10) < 5 ? .present : .notSupported
                    }
                    
                    try device.insert(db)
                }
            }
        }
        
        mockUpdateTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            AMIDBQueries.allDevices()?.forEach { d in
                if (d.temperaturePresence == .present) {
                    d.temperature *= Double.random(in: 0.95..<1.05)
                }
                if (d.pressurePresence == .present) {
                    d.pressure *= Double.random(in: 0.95..<1.05)
                }
                if (d.humidityPresence == .present) {
                    d.humidity *= Double.random(in: 0.95..<1.05)
                }
            }
        }
        
        return migrator
    }()
}
