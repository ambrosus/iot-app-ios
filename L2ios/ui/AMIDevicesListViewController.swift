//
//  Created by Sergei E. on 12/10/18.
//  (c) 2018 Ambrosus. All rights reserved.
//

import UIKit
import GRDB

@objc class AMIDevicesListViewController : UITableViewController {
    private enum Ordering {
        case byName
        case byTSAdded
        case byTSLastSeen
    }
    
    private var frController: FetchedRecordsController<AMIDeviceEntity>!
    private var countObserver: TransactionObserver?
    
    private var ordering: Ordering = .byTSLastSeen {
        didSet {
            try! frController.setRequest(request)
        }
    }
    
    private var request: QueryInterfaceRequest<AMIDeviceEntity> {
        switch ordering {
        case .byName:
            return AMIDeviceEntity.orderedByName()
        case .byTSAdded:
            return AMIDeviceEntity.orderedByTSAdded()
        case .byTSLastSeen:
            return AMIDeviceEntity.orderedByTSLastSeen()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureToolbar()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        super.viewWillDisappear(animated)
    }
    
    private func configureUI() {
    }
    
    private func configureToolbar() {
    }
    
    private func configureTableView() {
        let styleConstants = AMIStyleConstants.sharedInstance
        
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.contentInset.top = styleConstants.masterViewCellContentInsets.top * 2
        self.tableView.register(AMIDevicesListCell.self, forCellReuseIdentifier: "AMIDevicesListCell")
        
        let dbQueue = AMIDBStarter.sharedInstance.dbQueue
        frController = try! FetchedRecordsController(dbQueue!, request: request)
        
        frController.trackChanges(
            willChange: { [unowned self] _ in
                self.tableView.beginUpdates()
            },
            onChange: { [unowned self] (controller, record, change) in
                switch change {
                case .insertion(let indexPath):
                    self.tableView.insertRows(at: [indexPath], with: .fade)
                    
                case .deletion(let indexPath):
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    
                case .update(let indexPath, _):
                    if let cell = self.tableView.cellForRow(at: indexPath) {
                        self.configure(cell, at: indexPath)
                    }
                    
                case .move(let indexPath, let newIndexPath, _):
                    // Actually move cells around for more demo effect :-)
                    let cell = self.tableView.cellForRow(at: indexPath)
                    self.tableView.moveRow(at: indexPath, to: newIndexPath)
                    if let cell = cell {
                        self.configure(cell, at: newIndexPath)
                    }
                    
                    // A quieter animation:
                    // self.tableView.deleteRows(at: [indexPath], with: .fade)
                    // self.tableView.insertRows(at: [newIndexPath], with: .fade)
                }
            },
            didChange: { [unowned self] _ in
                self.tableView.endUpdates()
        })
        
        try! frController.performFetch()
    }
}

// MARK: - UITableViewDataSource

extension AMIDevicesListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return frController.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frController.sections[section].numberOfRecords
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AMIStyleConstants.sharedInstance.masterViewCellHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AMIDevicesListCell", for: indexPath)
        configure(cell, at: indexPath)
        return cell
    }
    
    private func configure(_ cell: UITableViewCell, at indexPath: IndexPath) {
        cell.selectionStyle = .none
        
        if let dcell: AMIDevicesListCell = cell as? AMIDevicesListCell {
            let device = frController.record(at: indexPath)
            dcell.updateWithEntity(device)
        }
    }
}

