//
//  Created by Sergei E. on 1/18/19.
//  (c) 2019 Ambrosus. All rights reserved.
//  

import UIKit

class AMITransientBufStore: NSObject {
    @objc static var map: [String:[AMIRingBuffer]] = [:]
}
