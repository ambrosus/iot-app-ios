//
//  Created by Sergei E. on 12/13/18.
//  (c) 2018 Ambrosus. All rights reserved.
//  

import UIKit

class AMIDevicesListCellTickerBuilder: NSObject {

//    // Create text attachment
//    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
//    textAttachment.image = [UIImage imageNamed:nameicon];
//    textAttachment.bounds = CGRectMake(0, 0, 20, 16);
//
//    // Attribute
//    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithAttributedString:attrStringWithImage];
//
//    // Change base line
//    [str addAttribute:NSBaselineOffsetAttributeName value:@(-1.5f * ratio) range:NSMakeRange(0, attrStringWithImage.length)];
//
//    NSRange rangeImage = [fullText rangeOfString:@"#image#"];
//
//    [attributedText replaceCharactersInRange:rangeImage withAttributedString:str];
    
    func attributize(text:NSString) {
        
    }
    
    public func attributedString(with entity:AMIDeviceEntity, lineHeight:CGFloat) -> NSAttributedString {
        let styleConstants = AMIStyleConstants.sharedInstance
        let tickerFont = styleConstants.masterViewCellTickerFont
        let tickerFontSize = tickerFont.pointSize
        
        let result = NSMutableAttributedString.init()
        
        if !entity.temp.isNaN {
            let att = NSTextAttachment.init()
            att.image = UIImage.init(pdfNamed: "ic-sentortype-temp.pdf", atHeight:lineHeight)
            att.bounds = CGRect.init(x: 0, y: tickerFontSize - lineHeight, uptoX: lineHeight, height: lineHeight)
            let attStr = NSMutableAttributedString.init(attachment: att)
            result.append(attStr)
            result.append(NSAttributedString.init(string: "°C"))
        }
        
        result.addAttributes([.font : styleConstants.masterViewCellTickerFont, .foregroundColor : styleConstants.defaultTextColor, .baselineOffset: 0],
                             range: NSRange.init(location: 0, length: result.length))
        
        result.size()
        
        return result
    }

}
