//
//  Created by Sergei E. on 12/13/18.
//  (c) 2018 Ambrosus. All rights reserved.
//  

#import "NSString+AMI.h"

@implementation NSString (AMI)

+ (NSString *)hexMacAddressStringWithData:(NSData *)macAddrData {
    NSUInteger length = macAddrData.length;
    NSMutableString *result = [[NSMutableString alloc] initWithCapacity:length * 3];
    uint8_t *bytes = (uint8_t *)macAddrData.bytes;
    
    if (bytes) {
        for (int i = 0; i < length; i++) {
            BOOL last = (i == length - 1);
            [result appendFormat:last ? @"%hhx" : @"%hhx:", bytes[i]];
        }
    }
    
    return result;
}

- (NSString * __nonnull)times:(NSInteger)times {
    NSMutableString *result = [[NSMutableString alloc] initWithCapacity:self.length * times];
    for (int i = 0; i < times; i++) {
        [result appendString:self];
    }
    
    return result;
}

@end
