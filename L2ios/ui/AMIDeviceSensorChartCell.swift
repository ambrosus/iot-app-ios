//
//  Created by Sergei E. on 1/2/19.
//  (c) 2019 Ambrosus. All rights reserved.
//  

import UIKit

class AMIDeviceSensorChartCell: UITableViewCell {
    var chartView = AMISimpleChartView()
    var mockInput : AMISimpleChartViewMockInput? = nil
    
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
        mockInput = AMISimpleChartViewMockInput.init(chartView, ptCount:120)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        performCustomLayout()
    }
    
    func performCustomLayout() {
        let styleConstants = AMIStyleConstants.sharedInstance
        self.contentView.frame = self.bounds.inset(by: styleConstants.masterViewCellContentInsets)
        self.chartView.frame = self.contentView.bounds
    }
    
    public func updateWithEntity(_ entity : AMIDeviceEntity) {
        mockInput?.updateChart(entity.unreachableFlag)
    }

}
