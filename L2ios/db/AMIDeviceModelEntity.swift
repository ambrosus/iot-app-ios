//
//  Created by Sergei E. on 12/11/18.
//  (c) 2018 Ambrosus. All rights reserved.
//  

import GRDB

struct AMIDeviceModelEntity : Codable, FetchableRecord, MutablePersistableRecord {
    public static var databaseTableName = "deviceModel"
    
    var id: Int64?
    var type: String
    var name: String
    var manufacturer: String
    var supportedProtocols: String
    var onboardSensors: String
    
    private enum CodingKeys: String, CodingKey, Codable, ColumnExpression {
        case id, type, name, manufacturer, supportedProtocols, onboardSensors
    }
    
    // Update a player id after it has been inserted in the database.
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}
