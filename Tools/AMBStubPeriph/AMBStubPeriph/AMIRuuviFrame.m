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

- (instancetype)initDefault {
    self = [super init];
    if (self) {
        self.humidity = 0.5;
        self.temperature = 22.0;
        self.pressure = 100000.0;
        self.acceleration = (AMIRuuviAcceleration){0.01, 0.01, 0.99};
        self.voltage = 3.3;
        self.rssi = -60.0;
    }
    
    return self;
}

- (NSData *)dataFrame {
    uint8_t *ubytes = (uint8_t *)calloc(16, 1);
    int8_t *sbytes = (int8_t *)ubytes;
    
    ubytes[0] = 0x99;
    ubytes[1] = 0x04;
    ubytes[2] = 0x03;
    ubytes[3] = (uint8_t)(_humidity * 2.0);
    sbytes[4] = (int8_t)_temperature;
    ubytes[5] = (uint8_t)(fabs(fmod(_temperature, 1.0)) * 100.0);
    uint16_t pressure = (uint16_t)(_pressure - 50000.0);
    ubytes[6] = (pressure & 0xFF00) >> 8;
    ubytes[7] = pressure & 0xFF;
    uint16_t accx = (uint16_t)(int16_t)(_acceleration.x * 1000.0);
    ubytes[8] = (accx & 0xFF00) >> 8;
    ubytes[9] = accx & 0xFF;
    uint16_t accy = (uint16_t)(int16_t)(_acceleration.y * 1000.0);
    ubytes[10] = (accy & 0xFF00) >> 8;
    ubytes[11] = accy & 0xFF;
    uint16_t accz = (uint16_t)(int16_t)(_acceleration.z * 1000.0);
    ubytes[12] = (accz & 0xFF00) >> 8;
    ubytes[13] = accz & 0xFF;
    uint16_t voltage = (uint16_t)(_voltage * 1000.0);
    ubytes[14] = (voltage & 0xFF00) >> 8;
    ubytes[15] = voltage & 0xFF;
    
    return [NSData dataWithBytesNoCopy:ubytes length:16 freeWhenDone:YES];
}

@end
