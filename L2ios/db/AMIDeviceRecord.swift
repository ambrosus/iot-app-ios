//
//  Created by Sergei E. on 12/11/18.
//  (c) 2018 Ambrosus. All rights reserved.
//  

import GRDB

class AMIDeviceRecord : Codable, FetchableRecord, MutablePersistableRecord {
    enum HWType : Int, Codable {
        case unknown = 0
        case ambl1 = 1
        case ruuvitag = 2
        case ambSimulated = 3
        case ambMockDevice = 4
    }
    
    public static var databaseTableName = "device"
    
    var id: Int64? = nil
    var hwtype: HWType = .unknown
    var udid: String = ""
    var macaddr: String = ""
    var broadcastedName: String = ""
    var baseName: String = ""
    var userAssignedName: String = ""
    var addedTS: Double = 0.0
    var lastSeenTS: Double = 0.0
    var battery: Double = 0.0
    var rssi: Double = 0.0
    var temperature: Double = 0.0
    var pressure: Double = 0.0
    var humidity: Double = 0.0
    var unreachableFlag: Bool = false
    var active: Bool = false
    var signal: Data = Data()
    
    fileprivate enum CodingKeys: String, CodingKey, ColumnExpression {
        case id, hwtype, udid, macaddr, broadcastedName, baseName, userAssignedName,
            addedTS, lastSeenTS, battery, rssi, temperature, pressure, humidity, unreachableFlag, active, signal
    }
    
    func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
    
    static func orderedByBroadcastedName() -> QueryInterfaceRequest<AMIDeviceRecord> {
        return AMIDeviceRecord.order(CodingKeys.broadcastedName)
    }
    
    static func orderedByUserAssignedName() -> QueryInterfaceRequest<AMIDeviceRecord> {
        return AMIDeviceRecord.order(CodingKeys.userAssignedName)
    }
    
    static func orderedByTSLastSeen() -> QueryInterfaceRequest<AMIDeviceRecord> {
        return AMIDeviceRecord.order(CodingKeys.lastSeenTS)
    }
    
    static func orderedByTSAdded() -> QueryInterfaceRequest<AMIDeviceRecord> {
        return AMIDeviceRecord.order(CodingKeys.addedTS)
    }
}


