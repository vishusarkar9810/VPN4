//
//  SubscriptionVC.swift
//  VPN
//
//  Created by creative on 11/07/24.
//

import UIKit

class SubscriptionVC: BaseViewController {

    @IBOutlet weak var _visualView: UIVisualEffectView!
    @IBOutlet weak var _annualPrice: UILabel!
    @IBOutlet weak var _monthlyPrice: UILabel!
    @IBOutlet weak var _detailLbl: UILabel!
    @IBOutlet weak var _annualView: UIVisualEffectView!
    @IBOutlet weak var _monthlyView: UIVisualEffectView!
    
    var selectedPlanId: String = "com.vice.vpn.year"

    override func viewDidLoad() {
        super.viewDidLoad()
        _detailLbl.text = "Annual  $9.99/Year"
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        _visualView.roundCorners(corners: [.topRight, .topLeft], radius: 20)
    }

    private func _successPurchase() {
        self.alert(title: "Purchase Success!", message: "You have successfully purchased, let's enjoy!") { alert in
            self.navigationController?.popViewController(animated: true)
        }
    }

    private func _purchaseProduct(id: String) {
        self.showloader()
        IAPManager.purchaseProduct(id: id) { [weak self] error in
            guard let self = self else { return }
            self.hideloader()
            guard let error = error else {
                self._successPurchase()
                return
            }

            self.alert(title: "Purchase Failed!", message: error)
        }
    }

    @IBAction func _annualEvent(_ sender: Any) {
        selectedPlanId = "com.vice.vpn.year"
        let blurEft = UIBlurEffect(style: .systemChromeMaterialDark) // You can change the style
        _annualView?.effect = blurEft
        _annualView?.borderColor = UIColor(named: "switchToggle")!
        _annualView?.borderWidth = 1
        
        let blurEffectt = UIBlurEffect(style: .light) // You can change the style
        _monthlyView?.effect = blurEffectt
        _monthlyView?.borderColor = UIColor(named: "switchToggle")!
        _monthlyView?.borderWidth = 0
        
        _detailLbl.text = "Annual  $9.99/Year"
    }

    @IBAction func _monthlyEvent(_ sender: Any) {
        selectedPlanId = "com.vice.vpn.month"
        let blurEffect = UIBlurEffect(style: .systemChromeMaterialDark) // You can change the style
        _monthlyView?.effect = blurEffect
        _monthlyView?.borderColor = UIColor(named: "switchToggle")!
        _monthlyView?.borderWidth = 1
        
        let blur = UIBlurEffect(style: .light) // You can change the style
        _annualView?.effect = blur
        _annualView?.borderColor = UIColor(named: "switchToggle")!
        _annualView?.borderWidth = 0
        
        _detailLbl.text = "Monthly  $1.99/Month"
    }

    @IBAction func _restorePurchaseEvent(_ sender: Any) {
        self.showloader()
        IAPManager.restorePurchase { [weak self] error in
            guard let self = self else { return }
            self.hideloader()
            guard let error = error else {
                self.alert(title: "Restore Success!", message: "You have successfully restored, let's enjoy!"){ alert in
                    self.navigationController?.popViewController(animated: true)
                }
                return
            }
            self.alert(title: "Restore Failed!", message: error)
        }
    }

    @IBAction func _closeEvent(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func _continuePurchaseEvent(_ sender: Any){
        _purchaseProduct(id: selectedPlanId)
    }
}
