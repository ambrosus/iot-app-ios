//
//  Created by Sergei E. on 1/2/19.
//  (c) 2019 Ambrosus. All rights reserved.
//  

import UIKit

class AMIDeviceSensorChartCell: UITableViewCell {
    let tickerBuilder = AMISensorTickerBuilder()
    var chartView = AMISimpleChartView()
    var sensorLegendLabel = UILabel()
    var sensorCurrentValueLabel = UILabel()
    var sensorMinValueLabel = UILabel()
    var sensorMaxValueLabel = UILabel()
    
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
        chartView.backgroundColor = styleConstants.detailViewCellBackgroundColor
        contentView.addSubview(chartView)
        contentView.addSubview(sensorLegendLabel)
        sensorCurrentValueLabel.textAlignment = .right
        sensorMinValueLabel.textAlignment = .right
        sensorMaxValueLabel.textAlignment = .right
        contentView.addSubview(sensorCurrentValueLabel)
        contentView.addSubview(sensorMinValueLabel)
        contentView.addSubview(sensorMaxValueLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        performCustomLayout()
    }
    
    func performCustomLayout() {
        let styleConstants = AMIStyleConstants.sharedInstance
        self.contentView.frame = self.bounds.inset(by: styleConstants.masterViewCellContentInsets)
        chartView.frame = self.contentView.bounds
        sensorLegendLabel.frame = styleConstants.briefChartSensorLegendRect
        sensorCurrentValueLabel.frame = styleConstants.briefChartSensorCurrentValueRect
        sensorMinValueLabel.frame = styleConstants.briefChartSensorMinValueRect
        sensorMaxValueLabel.frame = styleConstants.briefChartSensorMaxValueRect
    }
    
    public func updateWithEntity(_ entity : AMIDeviceRecord, sensorType:AMISensorType) {
        self.sensorLegendLabel.attributedText = tickerBuilder.briefChartLegend(sensorType: sensorType, lineHeight: sensorLegendLabel.frame.size.height)
        
        if let currentValue = entity.sensorValue(withType: sensorType) {
            self.sensorCurrentValueLabel.attributedText = tickerBuilder.briefChartValueText(sensorType: sensorType,
                                                                                            lineHeight: sensorCurrentValueLabel.frame.size.height,
                                                                                            value: currentValue)
            
            self.sensorMinValueLabel.attributedText = tickerBuilder.briefChartValueText(sensorType: sensorType,
                                                                                        lineHeight: sensorCurrentValueLabel.frame.size.height,
                                                                                        value: chartView.minValue())
            
            self.sensorMaxValueLabel.attributedText = tickerBuilder.briefChartValueText(sensorType: sensorType,
                                                                                        lineHeight: sensorCurrentValueLabel.frame.size.height,
                                                                                        value: chartView.maxValue())
        }
        else {
            self.sensorCurrentValueLabel.attributedText = nil
            self.sensorMinValueLabel.attributedText = nil
            self.sensorMaxValueLabel.attributedText = nil
        }
        
        self.chartView.assign(entity.sensorBuffer(withType: sensorType))
    }

}
