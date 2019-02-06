//
//  AMISimpleChartView.h
//  ChartDemo
//
//  Created by serj e on 1/2/19.
//  Copyright © 2019 Ambrosus. All rights reserved.
//

#import "AMISimpleChartView.h"
#import "AMISimpleChartPathBuilder.h"
#import "L2ios-Swift.h"

@interface AMISimpleChartView ()
@property (nonatomic, strong) AMISimpleChartPathBuilder *pBuilder;
@property (nonatomic, weak)   CAShapeLayer *lineLayer;
@property (nonatomic, weak)   CAShapeLayer *fillLayer;
@property (nonatomic, weak)   CAShapeLayer *gridLayer;

@end

@implementation AMISimpleChartView

@dynamic lineWidth;
@dynamic lineColor;
@dynamic fillColor;

- (void)dealloc {
    self.pBuilder = nil;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configureOnInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureOnInit];
    }
    
    return self;
}

- (void)configureOnInit {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4.0;
    
    self.pBuilder = [[AMISimpleChartPathBuilder alloc] init];
    
    CAShapeLayer *lineLayer = [[CAShapeLayer alloc] init];
    [self.layer addSublayer:lineLayer];
    self.lineLayer = lineLayer;
    
    CAShapeLayer *fillLayer = [[CAShapeLayer alloc] init];
    [self.layer addSublayer:fillLayer];
    self.fillLayer = fillLayer;
    
    CAShapeLayer *gridLayer = [[CAShapeLayer alloc] init];
    [self.layer addSublayer:gridLayer];
    self.gridLayer = gridLayer;
}

- (CGFloat)lineWidth {
    return self.pBuilder.lineWidth;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    self.pBuilder.lineWidth = lineWidth;
}

- (UIColor *)lineColor {
    return self.pBuilder.lineColor;
}

- (void)setLineColor:(UIColor *)lineColor {
    self.pBuilder.lineColor = lineColor;
}

- (UIColor *)fillColor {
    return self.pBuilder.fillColor;
}

- (void)setFillColor:(UIColor *)fillColor {
    self.pBuilder.fillColor = fillColor;
}

- (int32_t)pointsCount {
    return self.pBuilder.pointsCount;
}

- (void)setPointsCount:(int32_t)pointsCount {
    self.pBuilder.pointsCount = pointsCount;
}

- (int32_t)sampleBufferCount {
    return self.pBuilder.sampleBufferCount;
}

- (void)setSampleBufferCount:(int32_t)sampleBufferCount {
    self.pBuilder.sampleBufferCount = sampleBufferCount;
}

- (void)setSensorType:(AMISensorType)sensorType {
    _sensorType = sensorType;
    
}

- (void)assignSignal:(double *)signal times:(double *)times sigLen:(int32_t)sigLen {
    [self.pBuilder assignSignal:signal times:times sigLen:sigLen rect:self.bounds];
    [self.pBuilder updateLineLayer:self.lineLayer];
    [self.pBuilder updateFillLayer:self.fillLayer];
}

- (void)appendSignal:(double *)signal times:(double *)times sigLen:(int32_t)sigLen {
    [self.pBuilder appendSignal:signal times:times sigLen:sigLen rect:self.bounds];
    [self.pBuilder updateLineLayer:self.lineLayer];
    [self.pBuilder updateFillLayer:self.fillLayer];
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    self.lineLayer.frame = layer.bounds;
    self.fillLayer.frame = layer.bounds;
}

- (void)assignRingBuffer:(AMIRingBuffer *)rbuffer {
    if (rbuffer) {
        [self.pBuilder assignRingBuffer:rbuffer rect:self.bounds];
        [self.pBuilder updateLineLayer:self.lineLayer];
        [self.pBuilder updateFillLayer:self.fillLayer];
    }
}

- (double)minValue {
    return [self.pBuilder yMin];
}

- (double)maxValue {
    return [self.pBuilder yMax];
}

- (double)currentValue {
    return [self.pBuilder yLast];
}

@end
