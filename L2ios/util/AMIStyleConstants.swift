//
//  Created by Sergei E. on 12/11/18.
//  (c) 2018 Ambrosus. All rights reserved.
//  

import UIKit

extension CGRect {
    public init(x: CGFloat, y: CGFloat, uptoX: CGFloat, height: CGFloat) {
        self = CGRect(x: x, y: y, width:uptoX - x, height: height)
    }
    
    public func horizontalDivideQuad(spacing:CGFloat = 0.0) -> (quad: CGRect, remainder: CGRect) {
        return (CGRect(x: origin.x, y: origin.y, width: size.height, height: size.height),
                CGRect(x: origin.x + size.height + spacing, y: origin.y, width: size.width - size.height - spacing, height: size.height));
    }
    
    public func horizontalSlice(n:Int, startInset:CGFloat = 0.0, gap:CGFloat = 0.0, endInset:CGFloat = 0.0) -> [CGRect] {
        if n < 2 {
            return [self]
        }
        
        var originX = origin.x + startInset
        let newW = CGFloat(round((width - startInset - endInset - CGFloat(n - 1) * gap) / CGFloat(n)))
        var result:[CGRect] = Array.init()
        
        for _ in 0..<n {
            result.append(CGRect.init(x: originX, y: origin.y, width: newW, height: size.height))
            originX += (newW + gap)
        }
        
        return result
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
    
    @objc public lazy var brightTextColor: UIColor = {
        return UIColor.lightText
    }()
    
    @objc public lazy var dimmedTextColor: UIColor = {
        return UIColor.init(rgba: 0x727A92FF)
    }()
    
    @objc public lazy var midTextColor: UIColor = {
        return UIColor.init(between: brightTextColor, and: dimmedTextColor)
    }()
    
    @objc public lazy var isNavigationBarTranslucent: Bool = {
        return false
    }()
    
    @objc public lazy var navigationBarFont: UIFont = {
        return UIFont.systemFont(ofSize: 20.0, weight:.regular)
    }()
    
    @objc public lazy var navigationBarTextColor: UIColor = {
        return UIColor.white
    }()
    
    @objc public lazy var tabbarColor: UIColor = {
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
        return UIFont.systemFont(ofSize: 10.0, weight:.light)
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
        return UIScreen.main.bounds.size.width - horizInsets - 8
    }()
    
    @objc public lazy var masterViewCellTitleRect: CGRect = {
        return CGRect.init(x: 75.0, y: 17.0, uptoX: self.masterViewCellMaxX, height: 17.0)
    }()
    
    @objc public lazy var masterViewCellSubtitleRect: CGRect = {
        return CGRect.init(x: 75.0, y: 37.0, uptoX: self.masterViewCellMaxX, height: 14.0)
    }()
    
    @objc public lazy var masterViewCellTickersRect: CGRect = {
        return CGRect.init(x: 75.0, y: 69.0, uptoX: self.masterViewCellMaxX, height: 18.0)
    }()
    
    @objc public lazy var masterViewCellTickersRects: [CGRect] = {
        return masterViewCellTickersRect.horizontalSlice(n: 3, startInset: 0, gap: 4, endInset: 16)
    }()
    
    //==================================================================================================================
    
    @objc public lazy var detailViewSmallFont: UIFont = {
        return UIFont.systemFont(ofSize: 12.0, weight:.light)
    }()
    
    @objc public lazy var detailViewMediumFont: UIFont = {
        return UIFont.systemFont(ofSize: 14.0, weight:.light)
    }()
    
    @objc public lazy var detailViewConfigureButtonGradient: [UIColor] = {
        return [UIColor.init(rgba: 0x30BBB8FF), UIColor.init(rgba: 0x388DDAFF)]
    }()
    
    @objc public lazy var detailViewCellContentInsets: UIEdgeInsets = {
        return UIEdgeInsets.init(top: 5, left: 16, bottom: 5, right: 16)
    }()
    
    @objc public func detailViewChartsTableYOffset(_ rowCount: Int) -> CGFloat  {
        let scrSize = UIScreen.main.bounds.size
        return scrSize.height - CGFloat(min(rowCount, 4)) * detailViewCellHeight
    }
    
//    @objc public lazy var detailViewTableRect: CGRect = {
//        let scrSize = UIScreen.main.bounds.size
//        return CGRect.init(x: 0, y:250.0, uptoX: scrSize.width, height: scrSize.height - 250.0)
//    }()
    
    @objc public lazy var detailViewCellHeight: CGFloat = {
        return 90;
    }()
    
    @objc public lazy var detailViewCellBackgroundColor: UIColor = {
        return UIColor.init(rgba: 0x374064FF);
    }()
    
    @objc public lazy var detailViewCellCornerRadius: CGFloat = {
        return 4.0;
    }()
    
    
}

