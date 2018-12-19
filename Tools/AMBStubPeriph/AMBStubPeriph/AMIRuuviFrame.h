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

@property (nonatomic, assign) int manufacturerCode;
@property (nonatomic, assign) int protocolVersion;
@property (nonatomic, assign) double humidity;
@property (nonatomic, assign) double temperature;
@property (nonatomic, assign) double pressure;
@property (nonatomic, assign) AMIRuuviAcceleration acceleration;
@property (nonatomic, assign) double voltage;
@property (nonatomic, assign) double rssi;

- (nullable instancetype)initWithDataFrame:(NSData *)dataFrame;
- (nonnull instancetype)initDefault;
- (NSData *)dataFrame;
@end

NS_ASSUME_NONNULL_END
