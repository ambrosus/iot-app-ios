//
//  Created by Sergei E. on 12/11/18.
//  (c) 2018 Ambrosus. All rights reserved.
//  

import UIKit

extension CGRect {
    public func horizontalDivideQuad(spacing:CGFloat = 0.0) -> (quad: CGRect, remainder: CGRect) {
        return (CGRect(x: origin.x, y: origin.y, width: size.height, height: size.height),
                CGRect(x: origin.x + size.height + spacing, y: origin.y, width: size.width - size.height - spacing, height: size.height));
    }
    
    public init(x: CGFloat, y: CGFloat, uptoX: CGFloat, height: CGFloat) {
        self = CGRect(x: x, y: y, width:uptoX - x, height: height)
    }
}

class AMIStyleConstants : NSObject {
    @objc static var sharedInstance = AMIStyleConstants()
    
    @objc static func resetSharedInstance() {
        self.sharedInstance = AMIStyleConstants()
    }
    
    @objc public lazy var defaultBackgroundGradient: [UIColor] = {
        return [UIColor.init(rgba: 0x3A4569FF), UIColor.init(rgba: 0x282E4DFF)]
        //return [UIColor.init(rgba: 0x2D313CFF), UIColor.init(rgba: 0x282B35FF)]
    }()
    
    @objc public lazy var defaultTextColor: UIColor = {
        return UIColor.init(rgba: 0x727A92FF)
    }()
    
    @objc public lazy var isNavigationBarTranslucent: Bool = {
        return false
    }()
    
    @objc public lazy var navigationBarColor: UIColor = {
        return UIColor.init(rgba: 0x282D4CFF)
    }()
    
    @objc public lazy var masterViewCellHeight: CGFloat = {
        return 110.0
    }()
    
    @objc public lazy var masterViewCellContentInsets: UIEdgeInsets = {
        UIEdgeInsets.init(top: 5, left: 16, bottom: 5, right: 16)
    }()
    
    @objc public lazy var masterViewCellBGColor: UIColor = {
        return UIColor.init(rgba: 0x374064FF)
    }()
    
    @objc public lazy var masterViewCellCornerRadius: CGFloat = {
        return 6.0;
    }()
    
    @objc public lazy var masterViewCellBorderWidth: CGFloat = {
        return 0.5;
    }()
    
    @objc public lazy var masterViewCellBorderColor: UIColor = {
        return UIColor.init(rgba: 0xFFFFFF20)
    }()
    
    @objc public lazy var masterViewCellTitleFont: UIFont = {
        return UIFont.systemFont(ofSize: 16.0, weight:.semibold)
    }()
    
    @objc public lazy var masterViewCellSubtitleFont: UIFont = {
        return UIFont.systemFont(ofSize: 14.0, weight:.light)
    }()
    
    @objc public lazy var masterViewCellTickerFont: UIFont = {
        return UIFont.systemFont(ofSize: 12.0, weight:.light)
    }()
    
    @objc public lazy var masterViewCellBatteryFont: UIFont = {
        return UIFont.systemFont(ofSize: 11.0, weight:.light)
    }()
    
    @objc public lazy var masterViewCellRSSIFont: UIFont = {
        return UIFont.systemFont(ofSize: 11.0, weight:.light)
    }()
    
    @objc public lazy var masterViewCellVerticalSpacerFrame: CGRect = {
        return CGRect.init(x: 68, y: 10, width: 1, height: 80)
    }()
    
    @objc public lazy var masterViewCellVerticalSpacerColor: UIColor = {
        return UIColor.init(rgba: 0x00000020)
    }()
    
    @objc public lazy var masterViewCellMainIconRect: CGRect = {
        return CGRect.init(x: 16.0, y: 15.0, width: 41.0, height: 41.0)
    }()
    
    @objc public lazy var masterViewCellBattRect: CGRect = {
        return CGRect.init(x: 14.0, y: 62.0, width: 49.0, height: 17.0)
    }()
    
    @objc public lazy var masterViewCellRSSIRect: CGRect = {
        return masterViewCellBattRect.offsetBy(dx: 0, dy: masterViewCellBattRect.size.height)
    }()
    
    @objc public lazy var masterViewCellMaxX: CGFloat = {
        let horizInsets = self.masterViewCellContentInsets.right + self.masterViewCellContentInsets.left
        return UIScreen.main.bounds.size.width - horizInsets - 15
    }()
    
    @objc public lazy var masterViewCellTitleRect: CGRect = {
        return CGRect.init(x: 78.0, y: 17.0, uptoX: self.masterViewCellMaxX, height: 17.0)
    }()
    
    @objc public lazy var masterViewCellSubtitleRect: CGRect = {
        return CGRect.init(x: 78.0, y: 37.0, uptoX: self.masterViewCellMaxX, height: 17.0)
    }()
    
    @objc public lazy var masterViewCellTickersRect: CGRect = {
        return CGRect.init(x: 78.0, y: 69.0, uptoX: self.masterViewCellMaxX, height: 18.0)
    }()
}

