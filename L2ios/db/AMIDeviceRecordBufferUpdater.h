//
//  Created by Sergei E. on 1/17/19.
//  (c) 2019 Ambrosus. All rights reserved.
//  

#import <Foundation/Foundation.h>
#import "L2ios-Swift.h"

@interface AMIDeviceRecordBufferUpdater : NSObject

+ (void)updateDeviceTransientBuffers:(AMIDeviceRecord *)device withRSSI:(double)rssi battery:(double)battery;

@end
