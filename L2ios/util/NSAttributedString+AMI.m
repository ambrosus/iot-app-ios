//
//  Created by Sergei E. on 1/2/19.
//  (c) 2019 Ambrosus. All rights reserved.
//  

#import "NSAttributedString+AMI.h"
#import "UIImage+PDF.h"
#import "NSString+AMI.h"

@implementation NSAttributedString (AMI)

+ (instancetype)titleWithPDFIcon:(NSString *)iconName
                      iconHeight:(CGFloat)iconHeight
                          spaces:(int)spaces
                            text:(NSString *)text
                            font:(UIFont *)font
                       textColor:(UIColor *)textColor
                additionalOffset:(CGFloat)additionalOffset
{
    NSMutableAttributedString *result = [NSMutableAttributedString new];
    NSTextAttachment *txAtt = [[NSTextAttachment alloc] init];
    txAtt.image = [UIImage imageWithPDFNamed:iconName atHeight:iconHeight];
    txAtt.bounds = (CGRect){0, font.pointSize - iconHeight - additionalOffset, iconHeight, iconHeight};
    [result appendAttributedString:[NSAttributedString attributedStringWithAttachment:txAtt]];
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:[@" " times:spaces]]];
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:text]];
    NSDictionary *attributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName: textColor, NSBaselineOffsetAttributeName: @(0.0)};
    NSRange attrRange = NSMakeRange(0, result.length);
    [result addAttributes:attributes range:attrRange];
    return result;
}

@end
