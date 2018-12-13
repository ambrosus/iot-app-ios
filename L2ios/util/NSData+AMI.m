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

@end
