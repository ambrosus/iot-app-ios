//
//  Created by Sergei E. on 12/12/18.
//  (c) 2018 Ambrosus. All rights reserved.
//  

#import "UIView+AMI.h"

@implementation UIView (AMI)

- (void)applyVerticalGradient:(NSArray<UIColor *> *)gradient {
    CGRect frame = self.frame;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locationList[]  = {0.0f, 1.0f};
    
    CGFloat colorList[8] = {0};
    UIColor *cx = gradient.firstObject;
    UIColor *cy = gradient.lastObject;
    [cy getRed:&colorList[0] green:&colorList[1] blue:&colorList[2] alpha:&colorList[3]];
    [cx getRed:&colorList[4] green:&colorList[5] blue:&colorList[6] alpha:&colorList[7]];
    
    CGGradientRef myGradient   = CGGradientCreateWithColorComponents(colorSpace, colorList, locationList, 2);
    
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL, 1, frame.size.height * 2, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextDrawLinearGradient(bitmapContext, myGradient, CGPointMake(0.0f, 0.0f), CGPointMake(0, frame.size.height * 2), 0);
    
    CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
    UIImage *uiImage = [UIImage imageWithCGImage:cgImage scale:2 orientation:UIImageOrientationUp];
    CGImageRelease(cgImage);
    CGContextRelease(bitmapContext);
    CGColorSpaceRelease(colorSpace);
    
    [self setBackgroundColor:[UIColor colorWithPatternImage:uiImage]];
}

- (void)applyHorizontalGradient:(NSArray<UIColor *> *)gradient {
    CGRect frame = self.frame;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locationList[]  = {0.0f, 1.0f};
    
    CGFloat colorList[8] = {0};
    UIColor *cx = gradient.firstObject;
    UIColor *cy = gradient.lastObject;
    [cy getRed:&colorList[0] green:&colorList[1] blue:&colorList[2] alpha:&colorList[3]];
    [cx getRed:&colorList[4] green:&colorList[5] blue:&colorList[6] alpha:&colorList[7]];
    
    CGGradientRef myGradient   = CGGradientCreateWithColorComponents(colorSpace, colorList, locationList, 2);
    
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL, frame.size.width, 1, 8, 4 * frame.size.width, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextDrawLinearGradient(bitmapContext, myGradient, CGPointMake(0.0f, 0.0f), CGPointMake(frame.size.width, 0), 0);
    
    CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
    UIImage *uiImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    CGContextRelease(bitmapContext);
    CGColorSpaceRelease(colorSpace);
    
    [self setBackgroundColor:[UIColor colorWithPatternImage:uiImage]];
}

@end
