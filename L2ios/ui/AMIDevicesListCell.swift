//
//  Created by Sergei E. on 12/11/18.
//  (c) 2018 Ambrosus. All rights reserved.
//  

import UIKit
import SwiftSVG

class AMIDevicesListCell: UITableViewCell {
    var iconPic = UIImageView()
    var battPic = UIImageView()
    var battLabel = UILabel()
    var rssiPic = UIImageView()
    var rssiLabel = UILabel()
    var verticalSpacer = UIView()
    var titleLabel = UILabel()
    var subtitleLabel = UILabel()
    var tickersLabel = UILabel()
    let tickerBuilder = AMIDevicesListCellTickerBuilder()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        performCustomLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func configureUI() {
        let styleConstants = AMIStyleConstants.sharedInstance
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = styleConstants.masterViewCellBGColor
        self.contentView.layer.cornerRadius = styleConstants.masterViewCellCornerRadius
        self.contentView.layer.borderWidth = styleConstants.masterViewCellBorderWidth
        self.contentView.layer.borderColor = styleConstants.masterViewCellBorderColor.cgColor
        
        battLabel.font = styleConstants.masterViewCellTickerFont
        battLabel.textColor = styleConstants.defaultTextColor
        
        rssiLabel.font = styleConstants.masterViewCellTickerFont
        rssiLabel.textColor = styleConstants.defaultTextColor
        
        verticalSpacer.backgroundColor = styleConstants.masterViewCellVerticalSpacerColor
        
        titleLabel.font = styleConstants.masterViewCellTitleFont
        titleLabel.textColor = styleConstants.defaultTextColor
        
        subtitleLabel.font = styleConstants.masterViewCellSubtitleFont
        subtitleLabel.textColor = styleConstants.defaultTextColor
        
        self.contentView.addSubview(iconPic)
        self.contentView.addSubview(battPic)
        self.contentView.addSubview(battLabel)
        self.contentView.addSubview(rssiPic)
        self.contentView.addSubview(rssiLabel)
        self.contentView.addSubview(verticalSpacer)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(subtitleLabel)
        self.contentView.addSubview(tickersLabel)
        
        
        for (_, element) in [iconPic, battPic, battLabel, rssiPic, rssiLabel, verticalSpacer, titleLabel, subtitleLabel, tickersLabel].enumerated()
        {
            element.layer.borderColor = UIColor.init(white: 1.0, alpha: 0.1).cgColor;
            element.layer.borderWidth = 0.25
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        performCustomLayout()
    }
    
    func performCustomLayout() {
        let styleConstants = AMIStyleConstants.sharedInstance
        self.contentView.frame = self.bounds.inset(by: styleConstants.masterViewCellContentInsets)
        
        
        iconPic.frame = styleConstants.masterViewCellMainIconRect
        
        let (battIconRect, battTextRect) = styleConstants.masterViewCellBattRect.horizontalDivideQuad(spacing:2.0)
        battPic.frame = battIconRect
        battLabel.frame = battTextRect
        battPic.setImage(UIImage.init(pdfNamed: "ic-battery.pdf", at:battPic.frame.size))
        
        let (rssiIconRect, rssiTextRect) = styleConstants.masterViewCellRSSIRect.horizontalDivideQuad(spacing:2.0)
        rssiPic.frame = rssiIconRect
        rssiLabel.frame = rssiTextRect
        rssiPic.setImage(UIImage.init(pdfNamed: "ic-rssi.pdf", at:rssiPic.frame.size))
        
        verticalSpacer.frame = styleConstants.masterViewCellVerticalSpacerFrame
        
        
        titleLabel.frame = styleConstants.masterViewCellTitleRect
        
        
        subtitleLabel.frame = styleConstants.masterViewCellSubtitleRect
        
        
        tickersLabel.frame = styleConstants.masterViewCellTickersRect
    }
    
    public func updateWithEntity(_ entity : AMIDeviceEntity) {
        iconPic.contentMode = .topLeft
        let img = UIImage.init(pdfNamed: "ic-devicebrand-generic.pdf", at:iconPic.frame.size)
        iconPic.setImage(img)
        
        battLabel.text = String(format: "%.0f", entity.charge * 100) + "%"
        rssiLabel.text = String(format: "%.0f", entity.rssi * 100) + "dB"
        
        titleLabel.text = entity.name
        subtitleLabel.text = "Hex-address: " + NSString.hexMacAddressString(with: entity.macaddr)
        tickersLabel.attributedText = tickerBuilder.attributedString(with: entity, lineHeight:tickersLabel.frame.height)
    }
}
