//
//  Created by Sergei E. on 12/11/18.
//  (c) 2018 Ambrosus. All rights reserved.
//  

#import "AMIStyleConstants.h"
#import "UIColor+AMI.h"

@implementation AMIStyleConstants

+ (UIColor *)defaultBackgroundColor {
    return [UIColor colorWithRGBA:0x364164FF];
}

+ (UIColor *)defaultTextColor {
    return [UIColor lightTextColor];
}

+ (BOOL)isNavigationBarTranslucent {
    return NO;
}

@end
