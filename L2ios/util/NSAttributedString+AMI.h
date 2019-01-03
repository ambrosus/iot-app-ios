//
//  Created by Sergei E. on 1/2/19.
//  (c) 2019 Ambrosus. All rights reserved.
//  

#import <UIKit/UIKit.h>

@interface NSAttributedString (AMI)

+ (instancetype)titleWithPDFIcon:(NSString *)iconName
                      iconHeight:(CGFloat)iconHeight
                          spaces:(int)spaces
                            text:(NSString *)text
                            font:(UIFont *)font
                       textColor:(UIColor *)textColor
                additionalOffset:(CGFloat)additionalOffset;

@end
