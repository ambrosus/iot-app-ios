//
//  Created by Sergei E. on 12/19/18.
//  (c) 2018 Ambrosus. All rights reserved.
//  

#import "AMIRuuviFrame.h"

static const NSUInteger kRuuviManufacturerCode = 39172;

static int16_t construct_int16_be(uint8_t x, uint8_t y) {
    unsigned int n = ((unsigned int)y) | (((unsigned int)x) << 8);
    int v = n;
    if (n & 0x8000) {
        v -= 0x10000;
    }
    return (int16_t)v;
}

static uint16_t construct_uint16_be(uint8_t x, uint8_t y) {
    uint16_t n = ((uint16_t)y) | (((uint16_t)x) << 8);
    return n;
}

@implementation AMIRuuviFrame

- (instancetype)initWithDataFrame:(NSData *)dataFrame {
    if (dataFrame.length < 16) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        uint8_t *ubytes = (uint8_t *)dataFrame.bytes;
        int8_t *sbytes = (int8_t *)ubytes;
        _manufacturerCode = construct_uint16_be(ubytes[0], ubytes[1]);
        if (_manufacturerCode != kRuuviManufacturerCode) {
            return nil;
        }
        
        _protocolVersion = ubytes[2];
        _humidity = ubytes[3] * 0.5;
        _temperature = sbytes[4];
        _temperature += ubytes[5] * 0.01;
        _pressure = 50000.0 + construct_uint16_be(ubytes[6], ubytes[7]);
        _acceleration = (AMIRuuviAcceleration){
            construct_int16_be(ubytes[8], ubytes[9]) * 0.001,
            construct_int16_be(ubytes[10], ubytes[11]) * 0.001,
            construct_int16_be(ubytes[12], ubytes[13]) * 0.001};
        _voltage = construct_uint16_be(ubytes[14], ubytes[15]) * 0.001;
    }
    
    return self;
}

+ (BOOL)dataFrameIsRuuviCompatible:(NSData *)dataFrame {
    if (dataFrame.length >= 16) {
        uint8_t *ubytes = (uint8_t *)dataFrame.bytes;
        if (construct_uint16_be(ubytes[0], ubytes[1]) == kRuuviManufacturerCode) {
            return YES;
        }
    }
    
    return NO;
}

@end
