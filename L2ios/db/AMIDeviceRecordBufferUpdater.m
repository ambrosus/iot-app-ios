//
//  Created by Sergei E. on 1/17/19.
//  (c) 2019 Ambrosus. All rights reserved.
//  

#import "AMIDeviceRecordBufferUpdater.h"

@implementation AMIDeviceRecordBufferUpdater

+ (void)updateDeviceTransientBuffers:(AMIDeviceRecord *)device withRSSI:(double)rssi battery:(double)battery {
    AMIRingBuffer *bbuf = device.batteryBuffer;
    if (bbufData.data.length < [device transientBuffersCapacity]) {
        [bbufData appendBytes:&rssi length:sizeof(double)];
    }
    else {
        [bbufData ]
    }
    
    
}

@end
