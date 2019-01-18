//
//  Created by Sergei E. on 12/13/18.
//  (c) 2018 Ambrosus. All rights reserved.
//  

#import <Foundation/Foundation.h>

@interface NSData (AMI)

+ (nonnull NSData *)randomMacAddressData;
+ (nonnull NSData *)apdu_readRecordWithP1:(uint8_t)p1 P2:(uint8_t)p2 Le:(uint32_t)le;
- (nonnull NSString *)formattedHexWithLineSize:(NSUInteger)lineSize;

@end

@interface NSMutableData (AMI)

- (void)fillWithDoubleNans;

@end
