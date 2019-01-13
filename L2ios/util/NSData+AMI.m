//
//  Created by Sergei E. on 12/13/18.
//  (c) 2018 Ambrosus. All rights reserved.
//  

#import "NSData+AMI.h"

@implementation NSData (AMI)

+ (NSData *)randomMacAddressData {
    uint8_t bytes[6];
    for (int i = 0; i < sizeof(bytes) / sizeof(bytes[0]); i++) {
        bytes[i] = (uint8_t)round(arc4random_uniform(256));
    }
    
    return [NSData dataWithBytes:bytes length:6];
}

+ (NSData *)apdu_readRecordWithP1:(uint8_t)p1 P2:(uint8_t)p2 Le:(uint32_t)le {
    uint8_t rrBuf[7];
    rrBuf[0] = 0xFF;
    rrBuf[1] = 0xB2;
    rrBuf[2] = p1;
    rrBuf[3] = p2;
    rrBuf[4] = (le>>16) & 0xFF;
    rrBuf[5] = (le>>8) & 0xFF;
    rrBuf[6] = le & 0xFF;
    const void *bytes = &rrBuf[0];
    NSUInteger length = sizeof(rrBuf);
    
    return [NSData dataWithBytes:bytes length:length];
}

@end
