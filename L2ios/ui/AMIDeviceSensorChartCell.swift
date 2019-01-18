//
//  Created by Sergei E. on 1/2/19.
//  (c) 2019 Ambrosus. All rights reserved.
//  

import UIKit

class AMIDeviceSensorChartCell: UITableViewCell {
    let tickerBuilder = AMISensorTickerBuilder()
    var chartView = AMISimpleChartView()
    var sensorLegendView = UILabel()
    
    //var mockInput : AMISimpleChartViewMockInput? = nil
    
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
        contentView.addSubview(sensorLegendView)
        //mockInput = AMISimpleChartViewMockInput.init(chartView, ptCount:120)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        performCustomLayout()
    }
    
    func performCustomLayout() {
        let styleConstants = AMIStyleConstants.sharedInstance
        self.contentView.frame = self.bounds.inset(by: styleConstants.masterViewCellContentInsets)
        chartView.frame = self.contentView.bounds
        sensorLegendView.frame = styleConstants.briefChartSensorLegendRect
    }
    
    public func updateWithEntity(_ entity : AMIDeviceRecord, sensorType:AMISensorType) {
        self.sensorLegendView.attributedText = tickerBuilder.briefChartLegend(sensorType: sensorType, lineHeight: sensorLegendView.frame.size.height)
        self.chartView.assign(entity.batteryBuffer)
        
        //mockInput?.updateChart(entity.unreachableFlag)
    }

}
