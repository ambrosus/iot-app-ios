//
//  Created by Sergei E. on 12/11/18.
//  (c) 2018 Ambrosus. All rights reserved.
//  

import UIKit

class AMIDevicesListCell: UITableViewCell {
    var iconPic = UIImageView()
    var battPic = UIImageView()
    var battLabel = UILabel()
    var rssiPic = UIImageView()
    var rssiLabel = UILabel()
    var verticalSpacer = UIView()
    var titleLabel = UILabel()
    var subtitleLabel = UILabel()
    var tickersLabels:[UILabel] = [UILabel(), UILabel(), UILabel()]
    
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
        battLabel.textColor = styleConstants.dimmedTextColor
        battLabel.lineBreakMode = .byClipping
        
        rssiLabel.font = styleConstants.masterViewCellTickerFont
        rssiLabel.textColor = styleConstants.dimmedTextColor
        rssiLabel.lineBreakMode = .byClipping
        
        verticalSpacer.backgroundColor = styleConstants.masterViewCellVerticalSpacerColor
        
        titleLabel.font = styleConstants.masterViewCellTitleFont
        titleLabel.textColor = styleConstants.brightTextColor
        
        subtitleLabel.font = styleConstants.masterViewCellSubtitleFont
        subtitleLabel.textColor = styleConstants.midTextColor
        
        self.contentView.addSubview(iconPic)
        self.contentView.addSubview(battPic)
        self.contentView.addSubview(battLabel)
        self.contentView.addSubview(rssiPic)
        self.contentView.addSubview(rssiLabel)
        self.contentView.addSubview(verticalSpacer)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(subtitleLabel)
        tickersLabels.forEach { label in
            self.contentView.addSubview(label)
        }
        
        let allControls:[UIView]? = [iconPic, battPic, battLabel, rssiPic, rssiLabel, verticalSpacer, titleLabel, subtitleLabel] + tickersLabels
        allControls?.forEach { entry in
            entry.layer.borderColor = UIColor.init(white: 1.0, alpha: 0.1).cgColor;
            entry.layer.borderWidth = 0.25
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
        
        let tickersRects = styleConstants.masterViewCellTickersRects
        for (index, label) in tickersLabels.enumerated() {
            label.frame = tickersRects[index]
        }
    }
    
    public func updateWithEntity(_ entity : AMIDeviceRecord) {
        let styleConstants = AMIStyleConstants.sharedInstance
        iconPic.contentMode = .topLeft
        let img = UIImage.init(pdfNamed: "ic-devicebrand-generic.pdf", at:iconPic.frame.size)
        iconPic.setImage(img)
        
        battLabel.text = String(format: "%.1f", entity.battery) + "V"
        rssiLabel.text = String(format: "%.0f", entity.rssi)
        
        titleLabel.text = entity.broadcastedName
        subtitleLabel.text = "UUID: " + entity.uuid
        
        let tickersAttrStrings = tickerBuilder.tickers(with: entity, lineHeight: styleConstants.masterViewCellTickersRect.size.height, maxEntries: tickersLabels.count)
        for index in 0..<min(tickersAttrStrings.count, tickersLabels.count) {
            tickersLabels[index].attributedText = tickersAttrStrings[index]
        }
    }
}
