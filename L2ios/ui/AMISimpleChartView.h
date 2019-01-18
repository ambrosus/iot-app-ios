//
//  AMISimpleChartView.h
//  ChartDemo
//
//  Created by serj e on 1/2/19.
//  Copyright © 2019 Ambrosus. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AMISensorType) {
    AMISensorTypeUnknown = 0,
    AMISensorTypeVoltmeter,
    AMISensorTypeAmpermeter,
    AMISensorTypeOhmmeter,
    AMISensorTypeThermometer,
    AMISensorTypeHygrometer,
    AMISensorTypeLuxmeter,
    AMISensorTypeAccelerometer,
    AMISensorTypeGyroscope,
    AMISensorTypeMagnetometer,
    AMISensorTypeManometer,
    AMISensorTypeVibrometer,
    AMISensorTypeChemical,
    AMISensorTypeDistance,
    AMISensorTypeIRThermometer,
    AMISensorTypeRFMeter,
    AMISensorTypeMicrophone,
    AMISensorTypeVacuummeter,
    AMISensorTypePHMeter,
    AMISensorTypeHallSensor,
    AMISensorTypeWaterDetector,
    AMISensorTypeLidar,
    AMISensorTypeDosimeter,
    AMISensorTypeBatteryVoltage,
    AMISensorTypeBatteryPercentage,
    AMISensorTypeRssi
};

typedef NS_ENUM(NSInteger, AMIPhysQuantity) {
    AMIPhysDimensionless = 0,
    AMIPhysPercents,
    AMIPhysQuantityVolts,
    AMIPhysQuantityMillivolts,
    AMIPhysQuantityAmperes,
    AMIPhysQuantityMilliamperes,
    AMIPhysQuantityDegreesCelsius,
    AMIPhysQuantityDegreesFahrenheit,
    AMIPhysQuantityPressurePSI,
    AMIPhysQuantityPressureKPA,
    AMIPhysQuantityPressureHPA,
    AMIPhysQuantityRelativeHumidity
};

@class AMIRingBuffer;

@interface AMISimpleChartView : UIView

@property (nonatomic, assign)   CGFloat     lineWidth;
@property (nonatomic, strong)   UIColor     *lineColor;
@property (nonatomic, strong)   UIColor     *fillColor;
@property (nonatomic, assign)   int32_t     pointsCount;
@property (nonatomic, assign)   int32_t     sampleBufferCount;

@property (nonatomic, assign)   AMISensorType   sensorType;
@property (nonatomic, assign)   AMIPhysQuantity physQuantity;

- (void)assignSignal:(double *)signal times:(double *)times sigLen:(int32_t)sigLen;
- (void)appendSignal:(double *)signal times:(double *)times sigLen:(int32_t)sigLen;
- (void)assignRingBuffer:(nullable AMIRingBuffer *)rbuffer;

@end
