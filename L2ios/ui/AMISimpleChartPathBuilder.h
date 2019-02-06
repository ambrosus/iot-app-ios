//
//  AMISimpleChartPathBuilder.h
//  ChartDemo
//
//  Created by serj e on 12/27/18.
//  Copyright © 2018 Ambrosus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMIRingBuffer;

@interface AMISimpleChartPathBuilder : NSObject
@property (nonatomic, assign)   CGFloat     lineWidth;
@property (nonatomic, strong)   UIColor     *lineColor;
@property (nonatomic, strong)   UIColor     *fillColor;
@property (nonatomic, assign)   int32_t     pointsCount;
@property (nonatomic, assign)   int32_t     sampleBufferCount;
@property (nonatomic, assign)   BOOL        autoScaleY;
@property (nonatomic, assign)   double      yRangeSnap;
@property (nonatomic, assign)   double      yMin;
@property (nonatomic, assign)   double      yMax;
@property (nonatomic, assign)   double      yLast;

- (void)assignSignal:(double *)signal times:(double *)times sigLen:(int32_t)sigLen rect:(CGRect)rect;
- (void)appendSignal:(double *)signal times:(double *)times sigLen:(int32_t)sigLen rect:(CGRect)rect;

- (void)assignRingBuffer:(AMIRingBuffer *)rbuffer rect:(CGRect)rect;

- (void)updateLineLayer:(CAShapeLayer *)lineLayer;
- (void)updateFillLayer:(CAShapeLayer *)fillLayer;

@end
