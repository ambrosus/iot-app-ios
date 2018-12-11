//
//  Created by Sergei E. on 12/11/18.
//  (c) 2018 Ambrosus. All rights reserved.
//  

import Foundation

class AMIDictionaryEncoder {
    var result: [String: Any]
    
    init() {
        result = [:]
    }
    
    func encodeToDictionary(_ encodable: AMIDictionaryEncodable) -> [String: Any] {
        encodable.encodeToDictionary(self)
        return result
    }
    
    func encodeToDictionary<T, K>(_ value: T, key: K) where K: RawRepresentable, K.RawValue == String {
        result[key.rawValue] = value
    }
}

protocol AMIDictionaryEncodable {
    func encodeToDictionary(_ encoder: AMIDictionaryEncoder)
}
