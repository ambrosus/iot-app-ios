//
//  AMISimpleChartPathBuilder.m
//  ChartDemo
//
//  Created by serj e on 12/27/18.
//  Copyright © 2018 Ambrosus. All rights reserved.
//

#import "AMISimpleChartPathBuilder.h"
#import "UIColor+AMI.h"
#import "L2ios-Swift.h"

static const CGFloat    kDefaultLineWidth = 1.0;
static const uint32_t   kDefaultLineColorRGBA = 0x3B81B8FF;
static const uint32_t   kDefaultFillColorRGBA = 0x404C73FF;
static const int32_t    kDefaultPointsCount = 200;
static const int32_t    kDefaultSampleBufferCount = 3600;

@interface AMISimpleChartPathBuilder ()

@property (nonatomic, readonly) CGPathRef           linePath;
@property (nonatomic, readonly) CGPathRef           fillPath;
@property (nonatomic, readonly) CGPoint             *points;
@property (nonatomic, readonly) double              *sampleBuffer;
@property (nonatomic, assign)   int32_t             sampleBufferOffset;
@property (nonatomic, strong)   NSMutableIndexSet   *validPointsIndices;

@end

@implementation AMISimpleChartPathBuilder

- (void)dealloc {
    self.pointsCount = 0;
    self.sampleBufferCount = 0;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.lineWidth = kDefaultLineWidth;
        self.lineColor = [UIColor colorWithRGBA:kDefaultLineColorRGBA];
        self.fillColor = [UIColor colorWithRGBA:kDefaultFillColorRGBA];
        self.pointsCount = kDefaultPointsCount;
        self.sampleBufferCount = kDefaultSampleBufferCount;
        self.autoScaleY = YES;
        self.yRangeSnap = 1.0;
        self.yMin = 0.0;
        self.yMax = 0.0;
    }
    
    return self;
}

- (void)setPointsCount:(int32_t)pointsCount {
    if (_pointsCount != pointsCount) {
        if (_points) {
            free(_points);
        }
        
        _pointsCount = pointsCount;
        
        if (pointsCount) {
            _points = malloc(pointsCount * sizeof(CGPoint));
        }
    }
}

- (void)setSampleBufferCount:(int32_t)sampleBufferCount {
    if (_sampleBufferCount != sampleBufferCount) {
        if (_sampleBufferCount) {
            free(_sampleBuffer);
        }
        
        _sampleBufferCount = sampleBufferCount;
        _sampleBufferOffset = 0;
        
        if (sampleBufferCount) {
            _sampleBuffer = malloc(sampleBufferCount * sizeof(double));
            double dnan = nan("");
            for (int i = 0; i < sampleBufferCount; i++) {
                _sampleBuffer[i] = dnan;
            }
        }
    }
}

- (void)updateLineLayer:(CAShapeLayer *)lineLayer {
    CGMutablePathRef path = CGPathCreateMutable();
    CGAffineTransform tr = CGAffineTransformScale(CGAffineTransformMakeTranslation(0.0, lineLayer.frame.size.height), 1.0, -1.0);
    [self.validPointsIndices enumerateRangesUsingBlock:^(NSRange range, BOOL * _Nonnull stop) {
        CGPathAddLines(path, &tr, self.points + range.location, range.length);
    }];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    if (lineLayer.path == nil) {
        lineLayer.fillColor = nil;
        lineLayer.strokeColor = self.lineColor.CGColor;
        lineLayer.lineWidth = self.lineWidth;
    }
    
    lineLayer.path = path;
    CGPathRelease(path);
    
    [CATransaction commit];
}

- (void)updateFillLayer:(CAShapeLayer *)fillLayer {
    CGFloat halfLnWidth = self.lineWidth * 0.5;
    CGMutablePathRef path = CGPathCreateMutable();
    CGAffineTransform tr = CGAffineTransformScale(CGAffineTransformMakeTranslation(0.0, fillLayer.frame.size.height), 1.0, -1.0);
    [self.validPointsIndices enumerateRangesUsingBlock:^(NSRange range, BOOL * _Nonnull stop) {
        CGPoint ptStart = *(self.points + range.location);
        CGPoint ptEnd = *(self.points + range.location + range.length - 1);
        
        CGPathMoveToPoint(path, &tr, ptStart.x - halfLnWidth, 0.0);
        CGPathAddLineToPoint(path, &tr, ptStart.x - halfLnWidth, ptStart.y);
        CGPathAddLineToPoint(path, &tr, ptStart.x, ptStart.y);
        CGPathAddLines(path, &tr, self.points + range.location, range.length);
        CGPathAddLineToPoint(path, &tr, ptEnd.x + halfLnWidth, ptEnd.y);
        CGPathAddLineToPoint(path, &tr, ptEnd.x + halfLnWidth, 0);
        CGPathAddLineToPoint(path, &tr, ptStart.x - halfLnWidth, 0);
    }];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    if (fillLayer.path == nil) {
        fillLayer.fillColor = self.fillColor.CGColor;
        fillLayer.strokeColor = nil;
        fillLayer.lineWidth = 0.0;
        fillLayer.fillRule = kCAFillRuleEvenOdd;
    }
    
    fillLayer.path = path;
    CGPathRelease(path);
    
    [CATransaction commit];
}

- (void)assignSignal:(double *)signal times:(double *)times sigLen:(int32_t)sigLen rect:(CGRect)rect {
    int32_t ptLen = self.pointsCount;
    NSAssert(sigLen > 1 && ptLen > 1, @"Bad args");
    self.sampleBufferCount = sigLen;
    memcpy(_sampleBuffer, signal, sigLen * sizeof(double));
    if (sigLen > ptLen) {
        [self _updateWithSignalDS:_sampleBuffer times:times sigLen:sigLen sigOffset:0 rect:rect];
    }
    else {
        [self _updateWithSignalUS:_sampleBuffer times:times sigLen:sigLen sigOffset:0 rect:rect];
    }
}

- (void)appendSignal:(double *)signal_ times:(double *)times sigLen:(int32_t)sigLen rect:(CGRect)rect {
    int32_t ptLen = self.pointsCount;
    NSAssert(sigLen > 0 && ptLen > 1, @"Bad args 1");
    NSAssert(sigLen <= self.sampleBufferCount, @"Bad args 2");
    int32_t sigLenHead = MIN(sigLen, _sampleBufferCount - _sampleBufferOffset);
    int32_t sigLenTail = sigLen - sigLenHead;
    if (sigLenHead > 0) {
        memcpy(_sampleBuffer + _sampleBufferOffset, signal_, sigLenHead * sizeof(double));
    }
    if (sigLenTail > 0) {
        memcpy(_sampleBuffer, signal_ + sigLenHead, sigLenTail * sizeof(double));
    }
    
    _sampleBufferOffset = (_sampleBufferOffset + sigLen) % _sampleBufferCount;
    
    if (_sampleBufferCount > ptLen) {
        [self _updateWithSignalDS:_sampleBuffer times:times sigLen:_sampleBufferCount sigOffset:_sampleBufferOffset rect:rect];
    }
    else if (_sampleBufferCount < ptLen) {
        [self _updateWithSignalUS:_sampleBuffer times:times sigLen:_sampleBufferCount sigOffset:_sampleBufferOffset rect:rect];
    }
    else {
        [self _updateWithSignalDirect:_sampleBuffer times:times sigLen:_sampleBufferCount sigOffset:_sampleBufferOffset rect:rect];
    }
}

- (void)assignRingBuffer:(AMIRingBuffer *)rbuffer rect:(CGRect)rect {
    self.pointsCount = (int32_t)rbuffer.capacity;
    int32_t ptLen = self.pointsCount;
    NSAssert(rbuffer.data && ptLen > 1, @"Bad args");
    
    int32_t sigLen = (int32_t)rbuffer.length;
    self.sampleBufferCount = (int32_t)rbuffer.capacity;
    self.sampleBufferOffset = (int32_t)rbuffer.offset;
    
    double *signal_ = (double *)rbuffer.data.bytes;
    memcpy(_sampleBuffer, signal_, _sampleBufferCount * sizeof(double));
    
    [self _normalizeFull];
    
    _yLast = _sampleBuffer[_sampleBufferOffset - 1];
    
    if (_sampleBufferCount > ptLen) {
        [self _updateWithSignalDS:_sampleBuffer times:nil sigLen:_sampleBufferCount sigOffset:_sampleBufferOffset rect:rect];
    }
    else if (_sampleBufferCount < ptLen) {
        [self _updateWithSignalUS:_sampleBuffer times:nil sigLen:_sampleBufferCount sigOffset:_sampleBufferOffset rect:rect];
    }
    else {
        [self _updateWithSignalDirect:_sampleBuffer times:nil sigLen:_sampleBufferCount sigOffset:_sampleBufferOffset rect:rect];
    }
}

- (void)_updateWithSignalDirect:(double *)signal times:(double *)times sigLen:(int32_t)sigLen sigOffset:(int32_t)sigOffset rect:(CGRect)rect {
    int32_t ptLen = self.pointsCount;
    self.validPointsIndices = [[NSMutableIndexSet alloc] initWithIndexesInRange:(NSRange){0, ptLen}];
    
    CGPoint *points = self.points;
    
    CGFloat xlow = rect.origin.x;
    CGFloat xhigh = rect.origin.x + rect.size.width;
    CGFloat ylow = rect.origin.y;
    CGFloat yhigh = rect.origin.y + rect.size.height;
    CGFloat xstep = (xhigh - xlow) / (ptLen - 1);
    CGFloat xval = xlow;
    CGFloat cgnan = (sizeof(CGFloat) == sizeof(float)) ? nanf("") : nan("");
    
    for (int ptIndex = 0; ptIndex < ptLen; ptIndex++) {
        points[ptIndex].x = xval;
        xval += xstep;
        points[ptIndex].y = cgnan;
    }
    
    double *signalIter = signal + (sigOffset % sigLen);
    const double *signalIterEnd = signal + sigLen;
    int ptIndex = 0;
    for (int sigIndex = 0; sigIndex < sigLen; sigIndex++) {
        if (signalIter >= signalIterEnd) {
            signalIter = signal;
        }
        double y = *signalIter++;
        if (y == y) {
            points[ptIndex].y = y;
        }
        else {
            [_validPointsIndices removeIndex:ptIndex];
        }
        
        ptIndex++;
    }
    
    for (int ptIndex = 0; ptIndex < ptLen; ptIndex++) {
        CGFloat y = points[ptIndex].y;
        if (y == y) {
            points[ptIndex].y = ylow + y * (yhigh - ylow);
        }
    }
}

- (void)_updateWithSignalDS:(double *)signal times:(double *)times sigLen:(int32_t)sigLen sigOffset:(int32_t)sigOffset rect:(CGRect)rect {
    int32_t ptLen = self.pointsCount;
    self.validPointsIndices = [[NSMutableIndexSet alloc] initWithIndexesInRange:(NSRange){0, ptLen}];
    
    CGPoint *points = self.points;
    double ratio = (double)sigLen / (double)ptLen;
    double invRatio = 1.0 / ratio;
    
    CGFloat xlow = rect.origin.x;
    CGFloat xhigh = rect.origin.x + rect.size.width;
    CGFloat ylow = rect.origin.y;
    CGFloat yhigh = rect.origin.y + rect.size.height;
    CGFloat xstep = (xhigh - xlow) / (ptLen - 1);
    CGFloat xval = xlow;
    CGFloat cgnan = (sizeof(CGFloat) == sizeof(float)) ? nanf("") : nan("");
    
    for (int ptIndex = 0; ptIndex < ptLen; ptIndex++) {
        points[ptIndex].x = xval;
        xval += xstep;
        points[ptIndex].y = cgnan;
    }
    
    double *signalIter = signal + (sigOffset % sigLen);
    const double *signalIterEnd = signal + sigLen;
    int ptIndex = 0;
    double ptWeight = 1.0;
    for (int sigIndex = 0; sigIndex < sigLen - 1; sigIndex++) {
        if (signalIter >= signalIterEnd) {
            signalIter = signal;
        }
        double y = *signalIter++;
        if (y == y) {
            CGFloat leftFraction = (y * ptWeight) * invRatio;
            CGFloat rightFraction = (y * (1.0 - ptWeight)) * invRatio;
            
            double yl = points[ptIndex].y;
            double yr = points[ptIndex + 1].y;
            if (!(yl == yl)) {
                yl = 0.0;
            }
            if (!(yr == yr)) {
                yr = 0.0;
            }
            
            yl += leftFraction;
            yr += rightFraction;
            
            points[ptIndex].y = yl;
            points[ptIndex + 1].y = yr;
        }
        else {
            [_validPointsIndices removeIndex:ptIndex];
        }
        
        ptWeight -= invRatio;
        if (ptWeight < 0.0) {
            ptWeight += 1.0;
            ptIndex++;
        }
    }
    
    for (int ptIndex = 0; ptIndex < ptLen; ptIndex++) {
        CGFloat y = points[ptIndex].y;
        if (y == y) {
            points[ptIndex].y = ylow + y * (yhigh - ylow);
        }
    }
}

- (void)_updateWithSignalUS:(double *)signal times:(double *)times sigLen:(int32_t)sigLen sigOffset:(int32_t)sigOffset rect:(CGRect)rect {
    NSAssert(0, @"Implement upsampling!");
}

- (void)_normalizeFull {
    if (!_autoScaleY) {
        return;
    }
    
    int32_t count = self.sampleBufferCount;
    double min = INFINITY;
    double max = -INFINITY;
    for (int32_t i = 0; i < count; i++) {
        double pt = _sampleBuffer[i];
        if (pt == pt) {
            if (pt < min) {
                min = pt;
            }
            if (pt > max) {
                max = pt;
            }
        }
    }
    
    double minSnapped = floor((min - _yRangeSnap*0.5) / _yRangeSnap) * _yRangeSnap;
    double maxSnapped = ceil((max + _yRangeSnap*0.5) / _yRangeSnap) * _yRangeSnap;
    double swing = maxSnapped - minSnapped;
    
    self.yMin = minSnapped;
    self.yMax = maxSnapped;
    
    for (int32_t i = 0; i < count; i++) {
        double pt = _sampleBuffer[i];
        _sampleBuffer[i] = (pt - minSnapped) / swing;
    }
}

@end
