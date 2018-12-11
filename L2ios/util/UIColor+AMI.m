//
//  Created by Sergei E. on 12/7/18.
//  (c) 2018 Ambrosus. All rights reserved.
//

#import "UIColor+AMI.h"

#define _CR(rgba) (rgba >> 24) / 255.0f
#define _CG(rgba) ((rgba & 0xFF0000) >> 16) / 255.0f
#define _CB(rgba) ((rgba & 0xFF00) >> 8) / 255.0f
#define _CA(rgba) (rgba & 0xFF) / 255.0f

@implementation UIColor (AMI)

+ (instancetype)colorWithRGBA:(uint32_t)rgba {
    return [UIColor colorWithRed:_CR(rgba) green:_CG(rgba) blue:_CB(rgba) alpha:_CA(rgba)];
}

@end
