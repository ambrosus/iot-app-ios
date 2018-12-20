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
        
        var conf = Configuration()
        //conf.trace = { print($0) }
        conf.maximumReaderCount = 3
        
        let dbQueue = try! DatabaseQueue(path: dbURL.path, configuration:conf)
        try! migrator.migrate(dbQueue)
        dbQueue.setupMemoryManagement(in: UIApplication.shared)
        self.dbQueue = dbQueue
        
        try! dbQueue.write { db in
            try db.execute("DELETE FROM device")
        }
    }
    
    lazy var migrator: DatabaseMigrator = {
        var migrator = DatabaseMigrator()
        
        migrator.registerMigration("m0001_initial_schema") { db in
            try db.create(table: "deviceModel") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("type", .text).notNull()
                t.column("name", .text).notNull()
                t.column("manufacturer", .text).notNull()
                t.column("supportedProtocols", .text).notNull()
                t.column("onboardSensors", .text).notNull()
            }
            
            try db.create(table: "device") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("deviceModelId", .integer).references("deviceModel", column: "id", onDelete: .cascade, onUpdate: .cascade, deferred: false)
                t.column("autogeneratedName", .text).notNull()
                t.column("name", .text).notNull()
                t.column("active", .boolean).notNull()
                t.column("macaddr", .double).notNull()
                t.column("charge", .double).notNull()
                t.column("rssi", .double).notNull()
                t.column("temp", .double).notNull()
                t.column("pressure", .double).notNull()
                t.column("humidity", .double).notNull()
                t.column("tsAdded", .integer).notNull()
                t.column("tsLastSeen", .integer).notNull()
            }
        }
        
        migrator.registerMigration("m0002_test_populate") { db in
            var model = AMIDeviceModelEntity(id:nil,
                                             type:"T1",
                                             name:"RUUVITAG",
                                             manufacturer:"Ruuvi",
                                             supportedProtocols:"BTL4,BTL5",
                                             onboardSensors:"HUMI,TEMP,BARO,BATT");

            try model.insert(db)
            let modelIdRuuvi = model.id

            model = AMIDeviceModelEntity(id:nil,
                                         type:"T2",
                                         name:"CC2640",
                                         manufacturer:"TI",
                                         supportedProtocols:"BTL4,BTL5",
                                         onboardSensors:"VOLT");

            try model.insert(db)
        }
        
        return migrator
    }()
}
