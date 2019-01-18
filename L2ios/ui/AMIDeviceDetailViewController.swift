//
//  Created by Sergei E. on 1/2/19.
//  (c) 2019 Ambrosus. All rights reserved.
//  

import UIKit
import GRDB

@objc class AMIDeviceDetailViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    public var entity:AMIDeviceRecord? {
        didSet {
            if isViewLoaded {
                updateConfigureButtonValue()
                updateRSSILabelValue()
                updateBattLabelValue()
                updateCurrentIndicatorsLabelValue()
                updateCharts()
            }
        }
    }
    
    private var tableView = UITableView()
    private var backButton = UIButton()
    private var icon = UIImageView()
    private var statusLabel = UILabel()
    private var deviceNameLabel = UILabel()
    private var rssiLabel = UILabel()
    private var battLabel = UILabel()
    private var configureButton = UIButton()
    private var currentIndicatorsLabel = UILabel()
    private var timeframeLabel = UILabel()
    private var bleCentral:AMIBLECentral?
    private var observer: TransactionObserver?
    private var prevRssi:Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillAppear(animated)
        
        let request = AMIDeviceRecord.filter(sql: "uuid = ?", arguments:[entity?.uuid])
        let observation = ValueObservation.trackingOne(request)
        
        // Start observing the database
        observer = try! observation.start(in: AMIDBStarter.sharedInstance.dbQueue!, onChange: { [unowned self] device in
            device?.restoreTransientData()
            self.entity = device
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func setupOnLoad() {
        setupUI()
        self.bleCentral = AMIBLECentral.sharedInstance
        //setupMockInput()
    }
    
    private func setupUI() {
        setupBackButton()
        setupIcon()
        setupStatusLabel()
        setupDeviceNameLabel()
        setupRSSILabel()
        setupBattLabel()
        setupConfigureButton()
        setupTableView()
        setupCurrentIndicatorsLabel()
        setupTimeframeLabel()
        updateCharts()
    }
    
    private func setupBackButton() {
        let styleConstants = AMIStyleConstants.sharedInstance
        backButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(backButton)
        let backAttrTitle = NSAttributedString.title(withPDFIcon: "ic-back-arrow-white.pdf",
                                                     iconHeight: 21, spaces: 8, text: "Devices",
                                                     font: styleConstants.navigationBarFont,
                                                     textColor: styleConstants.navigationBarTextColor,
                                                     additionalOffset: 3.0)
        backButton.setAttributedTitle(backAttrTitle, for: .normal)
        
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16.0).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 32.0).isActive = true
        backButton.addTarget(self, action: #selector(self.onBackBtn(_:)), for: .primaryActionTriggered)
    }
    
    private func setupIcon() {
        icon.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(icon)
        icon.setImage(UIImage.init(pdfNamed: "ic-devicebrand-generic.pdf", atHeight:41))
        icon.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 14.0).isActive = true
        icon.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 20.0).isActive = true
    }
    
    private func setupStatusLabel() {
        let styleConstants = AMIStyleConstants.sharedInstance
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        statusLabel.text = "Streaming..."
        statusLabel.font = styleConstants.detailViewSmallFont
        statusLabel.textColor = styleConstants.dimmedTextColor
        statusLabel.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 15.0).isActive = true
        statusLabel.topAnchor.constraint(equalTo: icon.topAnchor, constant: 2.0).isActive = true
    }
    
    private func setupDeviceNameLabel() {
        let styleConstants = AMIStyleConstants.sharedInstance
        deviceNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(deviceNameLabel)
        deviceNameLabel.text = entity?.broadcastedName
        deviceNameLabel.font = styleConstants.detailViewMediumFont
        deviceNameLabel.textColor = styleConstants.midTextColor
        deviceNameLabel.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 15.0).isActive = true
        deviceNameLabel.topAnchor.constraint(equalTo: icon.topAnchor, constant: 22.0).isActive = true
    }
    
    private func setupRSSILabel() {
        let styleConstants = AMIStyleConstants.sharedInstance
        rssiLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rssiLabel)
        
        rssiLabel.font = styleConstants.detailViewSmallFont
        rssiLabel.textColor = styleConstants.dimmedTextColor
        rssiLabel.leftAnchor.constraint(equalTo: view.rightAnchor, constant: -70.0).isActive = true
        rssiLabel.bottomAnchor.constraint(equalTo: deviceNameLabel.bottomAnchor, constant: -20.0).isActive = true
        updateRSSILabelValue()
        
    }
    
    private func updateRSSILabelValue() {
        let styleConstants = AMIStyleConstants.sharedInstance
        if let rssi = entity?.rssi {
            rssiLabel.attributedText = NSAttributedString.title(withPDFIcon: "ic-rssi.pdf",
                                                                iconHeight: 18, spaces: 1, text: String(format:"%.0f", rssi),
                                                                font: styleConstants.detailViewSmallFont,
                                                                textColor: styleConstants.dimmedTextColor,
                                                                additionalOffset: -1.0)
        }
        else {
            rssiLabel.attributedText = nil
        }
    }
    
    private func setupBattLabel() {
        let styleConstants = AMIStyleConstants.sharedInstance
        battLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(battLabel)
        
        battLabel.font = styleConstants.detailViewSmallFont
        battLabel.textColor = styleConstants.dimmedTextColor
        battLabel.leftAnchor.constraint(equalTo: view.rightAnchor, constant: -70.0).isActive = true
        battLabel.bottomAnchor.constraint(equalTo: deviceNameLabel.bottomAnchor, constant: 0.0).isActive = true
        updateBattLabelValue()
    }
    
    private func updateBattLabelValue() {
        let styleConstants = AMIStyleConstants.sharedInstance
        if let batteryText = entity?.batteryText() {
            battLabel.attributedText = NSAttributedString.title(withPDFIcon: "ic-battery.pdf",
                                                                iconHeight: 18, spaces: 1, text: batteryText,
                                                                font: styleConstants.detailViewSmallFont,
                                                                textColor: styleConstants.dimmedTextColor,
                                                                additionalOffset: -1.0)
        }
        else {
            battLabel.attributedText = nil
        }
    }
    
    private func setupConfigureButton() {
        let styleConstants = AMIStyleConstants.sharedInstance
        configureButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(configureButton)
        
        configureButton.setTitleColor(styleConstants.brightTextColor, for: .normal)
        configureButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16.0).isActive = true
        configureButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16.0).isActive = true
        configureButton.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 26.0).isActive = true
        configureButton.heightAnchor.constraint(equalToConstant: 46.0).isActive = true
        configureButton.layer.cornerRadius = 4.0
        configureButton.frame.size.width = 480
        configureButton.applyHorizontalGradient(styleConstants.detailViewConfigureButtonGradient)
        configureButton.contentHorizontalAlignment = .left
        updateConfigureButtonValue()
    }
    
    private func updateConfigureButtonValue() {
        let styleConstants = AMIStyleConstants.sharedInstance
        var text = "Unpaired"
        if let entity = entity {
            text = entity.unreachableFlag ? "Unreachable" : "Paired"
        }
        
        let attrTitle = NSAttributedString.title(withPDFIcon: "ic-paired.pdf", iconHeight: 21, spaces: 0, text: text,
                                                 font: styleConstants.detailViewMediumFont,
                                                 textColor: UIColor.white,
                                                 additionalOffset: -1.0)
        configureButton.setAttributedTitle(attrTitle, for: .normal)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant:-8.0).isActive = true
        tableView.separatorStyle = .none
        self.view.backgroundColor = UIColor.clear
        tableView.backgroundColor = UIColor.clear
        tableView.register(AMIDeviceSensorChartCell.self, forCellReuseIdentifier: "AMIDeviceSensorChartCell")
        
        updateTableViewHeight()
    }
    
    private func updateTableViewHeight() {
        let count = entity?.availableSensorsCount() ?? 0
        if (count > 0) {
            let styleConstants = AMIStyleConstants.sharedInstance
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: styleConstants.detailViewChartsTableYOffset(count) - 10.0).isActive = true
            tableView.isHidden = false
        }
        else {
            tableView.isHidden = true
        }
    }
    
    private func setupCurrentIndicatorsLabel() {
        let styleConstants = AMIStyleConstants.sharedInstance
        currentIndicatorsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(currentIndicatorsLabel)
        currentIndicatorsLabel.font = styleConstants.detailViewMediumFont
        currentIndicatorsLabel.textColor = styleConstants.brightTextColor
        currentIndicatorsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16.0).isActive = true
        currentIndicatorsLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -12.0).isActive = true
        updateCurrentIndicatorsLabelValue()
    }
    
    private func updateCurrentIndicatorsLabelValue() {
        let count = entity?.availableSensorsCount() ?? 0
        if (count > 0) {
            currentIndicatorsLabel.text = "\(count) Sensor Indicators"
        }
        else {
            currentIndicatorsLabel.text = nil
        }
    }
    
    private func setupTimeframeLabel() {
        let styleConstants = AMIStyleConstants.sharedInstance
        timeframeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timeframeLabel)
        timeframeLabel.text = "Last 15 minutes"
        timeframeLabel.font = styleConstants.detailViewMediumFont
        timeframeLabel.textColor = styleConstants.dimmedTextColor
        timeframeLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16.0).isActive = true
        timeframeLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -12.0).isActive = true
    }
    
    private func setupMockInput() {
        let t = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] t in
            guard let strongSelf = self else {
                t.invalidate()
                return
            }
            
            let unreachableChange = Int.random(in: 0..<100) < 1
            if var entity = strongSelf.entity {
                if unreachableChange {
                    entity.unreachableFlag = false//!entity.unreachableFlag
                }
                strongSelf.entity = entity
                
                strongSelf.tableView.visibleCells.forEach{ tvc in
                    if let cell = tvc as? AMIDeviceSensorChartCell {
                        cell.updateWithEntity(entity, sensorType:.batteryVoltage)
                    }
                }
            }
        }
        
        RunLoop.current.add(t, forMode: .default)
    }
    
    private func updateCharts() {
        if let entity = entity {
            let types = entity.availableSensorTypes()
            for index in 0..<types.count {
                if let cell = tableView.cellForRow(at: IndexPath(indexes: [0, index])) as? AMIDeviceSensorChartCell {
                    cell.updateWithEntity(entity, sensorType: types[index])
                }
            }
        }
    }
    
    @objc func onBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entity?.availableSensorsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AMIStyleConstants.sharedInstance.detailViewCellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AMIDeviceSensorChartCell", for: indexPath)
        cell.selectionStyle = .none
        
        if let entity = entity, let cell = cell as? AMIDeviceSensorChartCell {
            let types = entity.availableSensorTypes()
            cell.updateWithEntity(entity, sensorType: types[indexPath.row])
        }
        
        return cell
    }
}
