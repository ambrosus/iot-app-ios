//
//  Created by Sergei E. on 1/13/19.
//  (c) 2019 Ambrosus. All rights reserved.
//  

import UIKit

@objc class AMIDBFlags: NSObject {
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
    static var pageSize: Int {
        return 8192
    }
    
    static var recreateDBOnEachStart: Bool {
        return true
    }
    
    static var logSQL: Bool {
        return false
    }
    
    static var maximumReaderCount: Int {
        return 3
    }
}
