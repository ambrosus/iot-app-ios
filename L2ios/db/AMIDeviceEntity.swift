//
//  Created by Sergei E. on 12/11/18.
//  (c) 2018 Ambrosus. All rights reserved.
//  

import GRDB

struct AMIDeviceEntity : Codable, FetchableRecord, MutablePersistableRecord {
//    t.autoIncrementedPrimaryKey("id")
//    t.column("deviceModelId", .integer).references("deviceModel", column: "id", onDelete: .cascade, onUpdate: .cascade, deferred: false)
//    t.column("autogeneratedName", .text).notNull()
//    t.column("name", .text).notNull()
//    t.column("active", .boolean).notNull()
//    t.column("tsAdded", .integer).notNull()
//    t.column("tsLastSeen", .integer).notNull()
    
    var id: Int64?
    var deviceModelId: Int64?
    var autogeneratedName: String
    var name: String
    var active: Bool
    var tsAdded: Double
    var tsLastSeen: Double
    
    
    private enum CodingKeys: String, CodingKey, Codable, ColumnExpression {
        case id, deviceModelId, autogeneratedName, name, active, tsAdded, tsLastSeen
    }
    
    // Update a player id after it has been inserted in the database.
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
    
    static func orderedByName() -> QueryInterfaceRequest<AMIDeviceEntity> {
        return AMIDeviceEntity.order(CodingKeys.name)
    }
    
    static func orderedByTSAdded() -> QueryInterfaceRequest<AMIDeviceEntity> {
        return AMIDeviceEntity.order(CodingKeys.tsAdded)
    }
    
    static func orderedByTSLastSeen() -> QueryInterfaceRequest<AMIDeviceEntity> {
        return AMIDeviceEntity.order(CodingKeys.tsLastSeen)
    }
    
    func toJSON() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
