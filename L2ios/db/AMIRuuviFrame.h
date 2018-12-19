//
//  Created by Sergei E. on 12/19/18.
//  (c) 2018 Ambrosus. All rights reserved.
//  

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct {
    double x;
    double y;
    double z;
} AMIRuuviAcceleration;

@interface AMIRuuviFrame : NSObject

@property (nonatomic, readonly, assign) int manufacturerCode;
@property (nonatomic, readonly, assign) int protocolVersion;
@property (nonatomic, readonly, assign) double humidity;
@property (nonatomic, readonly, assign) double temperature;
@property (nonatomic, readonly, assign) double pressure;
@property (nonatomic, readonly, assign) AMIRuuviAcceleration acceleration;
@property (nonatomic, readonly, assign) double voltage;
@property (nonatomic, readonly, assign) double rssi;

- (nullable instancetype)initWithDataFrame:(NSData *)dataFrame;

@end

NS_ASSUME_NONNULL_END
