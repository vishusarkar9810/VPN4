//
//  VPNListVC.swift
//  VPN
//
//  Created by creative on 10/07/24.
//

import UIKit

class VPNListVC: BaseViewController {

    @IBOutlet weak var _tableView: CustomTableView!
    @IBOutlet weak var _searchTxtField: UITextField!
    @IBOutlet weak var _searchVisualView: UIVisualEffectView!

    private let kCellIdentifier = String(describing: VPNListTableCell.self)
    private var _vpnFilter: [VPNModel] = []
    
    var _VPNModel:[VPNModel] = []
    var isName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        showloader()
        _requestData()
        setupSearchField()
    }
    
    private func setupUI() {
        _tableView.setup(
            cellPrototypes: _prototypes,
            hasHeaderSection: true,
            hasFooterSection: false,
            isHeaderCollapsible: false,
            isDummyLoad: false,
            enableRefresh: true,
            emptyDataText: kEmptyString,
            emptyDataIconImage: nil,
            emptyDataDescription: kEmptyString,
            delegate: self)
        _tableView.proxyDelegate = self
    }
    
    private var _prototypes: [[String: Any]]? {
        return [ [kCellIdentifierKey: kCellIdentifier, kCellNibNameKey: String(describing: VPNListTableCell.self), kCellClassKey: VPNListTableCell.self,kCellHeightKey: VPNListTableCell.height] ]
    }
    
    private func setupSearchField() {
           _searchTxtField.addTarget(self, action: #selector(searchTextChanged(_:)), for: .editingChanged)
       }
       
       @objc private func searchTextChanged(_ textField: UITextField) {
           _loadData(searchText: textField.text ?? "")
       }
  
    private func _requestData() {
        
        VPNApiService.getVPNList() { [weak self] container, error in
            guard let self = self else { return }
            self.hideloader()
            self.showError(error)
            guard let model = container?.data else { return }

            self._VPNModel = model
            self._loadData(searchText: kEmptyString)
        }
    }
    
    private func _loadData(searchText: String) {
        _vpnFilter.removeAll()
        
        if searchText.isEmpty {
           _vpnFilter = _VPNModel
         } else {
           _vpnFilter = _VPNModel.filter { vpnModel in
             return vpnModel.country.lowercased().contains(searchText.lowercased())
           }
         }

        var cellSectionData = [[String: Any]]()
         if _vpnFilter.isEmpty {
           // Handle empty search case (e.g., show empty view)
             cellSectionData.append(["emptyMessage": "No VPNs found."])
         } else {
           var cellData = [[String: Any]]()
           _vpnFilter.forEach { userInfo in
             cellData.append([
               kCellIdentifierKey: kCellIdentifier,
               kCellTagKey: kCellIdentifier,
               kCellObjectDataKey: userInfo,
               kCellClassKey: VPNListTableCell.self,
               kCellHeightKey: VPNListTableCell.height
             ])
           }
           cellSectionData.append([kSectionTitleKey: kEmptyString, kSectionDataKey: cellData])
         }
         _tableView.loadData(cellSectionData)
    }

    @IBAction func backEvent(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension VPNListVC: CustomTableViewDelegate, UITableViewDelegate {
    
    func setupCell(_ cell: UITableViewCell, cellDict: [String : Any]?, indexPath: IndexPath) {
        guard let cell = cell as? VPNListTableCell,
              let object = cellDict?[kCellObjectDataKey] as? VPNModel else { return }
        cell.setup(object)
        cell._selectionBtn.isSelected = isName == cell._countryNameLbl.text ? true : false
    }

    func didSelectTableCell(_ cell: UITableViewCell, sectionTitle: String?, cellDict: [String : Any]?, indexPath: IndexPath) {
        let vpn = cellDict?[kCellObjectDataKey] as? VPNModel
        if vpn?.isPremium ?? false {
            if Preferences.isPlanActivated {
                vpn?.save()
                guard let cell = cell as? VPNListTableCell else { return }
                cell._selectionBtn.isSelected = true
                navigationController?.popViewController(animated: true)
            } else {
                alert(message: "Please subscribe to use premiume servers.")
            }
        } else {
            vpn?.save()
            guard let cell = cell as? VPNListTableCell else { return }
            cell._selectionBtn.isSelected = true
            navigationController?.popViewController(animated: true)
        }

    }
    
    
//    private func _installVPNConfigurationAndNavigateBack() {
//            // Trigger VPN configuration installation
//            let dashboardVC = INIT_CONTROLLER_XIB(DashboardVC.self)
//            dashboardVC.installVPNConfiguration()
//            
//            // Navigate back to DashboardVC
//            self.navigationController?.popViewController(animated: true)
//        }
    }
