//
//  OnBoardingVC.swift
//  VPN
//
//  Created by creative on 10/07/24.
//

import UIKit
typealias infoData = (tag: Int, title: String, Desc: String, mainImage: UIImage?)
class OnBoardingVC: BaseViewController {
    @IBOutlet weak var _bottomVisualVIew: UIVisualEffectView!
    
    
    @IBOutlet weak var _collectionView: CustomCollectionView!
    private let kCollectionCellIdentifier = String(describing: BoardingCollectionCell.self)
    @IBOutlet weak var pageControl: UIPageControl!
  
    @IBOutlet weak var _visualView: UIVisualEffectView!
    var selectedPlanId: String = "com.vice.vpn.year"
    @IBOutlet weak var _annualView: UIVisualEffectView?
    @IBOutlet weak var _monthlyView: UIVisualEffectView?
    @IBOutlet weak var _detailLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _bottomVisualVIew.addTopBorder(to: _bottomVisualVIew, with: UIColor.white , andWidth: 1.0)
        setupUI()
        _loadCollectionData()
        Preferences.didShowInfo = false
        _detailLbl.text = "Annual  $9.99/Year"
        DISPATCH_ASYNC_MAIN { [weak self] in
            guard let self = self else { return }
            self.showPolicyVC()
        }
    }

    func showPolicyVC() {
        let vc = INIT_CONTROLLER_XIB(PolicyVC.self)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }

    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           _visualView.roundCorners(corners: [.topRight, .topLeft], radius: 20)
       }
    
    func setupUI() {
        Preferences.didShowInfo = true
        _collectionView.setup(cellPrototypes: _prototype,
                                    hasHeaderSection: false,
                                    enableRefresh: false,
                                    columns:1,
                                     rows: 1,
                                    scrollDirection: .horizontal,
                                    emptyDataText: nil,
                                    emptyDataIconImage: nil,
                                    delegate: self)
        _collectionView.showsVerticalScrollIndicator = false
        _collectionView.showsHorizontalScrollIndicator = false
        _collectionView.isPagingEnabled = false // Disable default paging

        pageControl.numberOfPages = infoDt.count
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        _collectionView.addGestureRecognizer(panGesture)
    }

    private var _prototype: [[String: Any]]? {
            return [[kCellIdentifierKey: kCollectionCellIdentifier, kCellNibNameKey: String(describing: BoardingCollectionCell.self), kCellClassKey: BoardingCollectionCell.self, kCellHeightKey: BoardingCollectionCell.height]]
        }
    
    var infoDt: [infoData] {
        [(tag: 0, title: " Vice-VPN  Premium", Desc: "Unlock global access securely with Vice VPN!", mainImage: UIImage(named: "img1")),
         (tag: 1, title: "Get The Fastest Speed", Desc: "Stay anonymous and safe, wherever you go!", mainImage: UIImage(named: "img2")),
         (tag: 2, title: "One-To-one VIP Service", Desc: "Vice VPN: Your key to private, safe browsing!", mainImage: UIImage(named: "img3")),
         (tag: 3, title: "Protect Your Privacy", Desc: "Privacy, freedom, security – Vice VPN has it all!", mainImage: UIImage(named: "img4")),
         (tag: 4, title: "Support 5 Device", Desc: "Vice VPN: Your trusted online security partner!", mainImage: UIImage(named: "img5"))
        ]
    }
    
    private func _loadCollectionData() {
        var cellSectionData = [[String: Any]]()
        var cellData = [[String: Any]]()

        var id = 0
        infoDt.forEach { list in
            cellData.append([
                kCellIdentifierKey: kCollectionCellIdentifier,
                kCellTagKey: id,
                kCellObjectDataKey: list,
                kCellClassKey: BoardingCollectionCell.self,
                kCellHeightKey: _collectionView.frame.size.height
            ])
            id += 1
        }

        cellSectionData.append([kSectionTitleKey: kEmptyString, kSectionDataKey: cellData])
        _collectionView.loadData(cellSectionData)
    }
    
    @objc func pageControlTapped(_ sender: UIPageControl) {
        let page = sender.currentPage
        let indexPath = IndexPath(item: page, section: 0)
        _collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: _collectionView)
        let velocity = gesture.velocity(in: _collectionView)
        let width = _collectionView.frame.width

        switch gesture.state {
        case .changed:
            _collectionView.contentOffset.x -= translation.x
            gesture.setTranslation(.zero, in: _collectionView)

        case .ended:
            let currentOffset = _collectionView.contentOffset.x
            let targetIndex = velocity.x < 0 ? pageControl.currentPage + 1 : pageControl.currentPage - 1
            let newPage = max(0, min(pageControl.numberOfPages - 1, targetIndex))
            let targetOffset = CGFloat(newPage) * width

            UIView.animate(withDuration: 0.3, animations: {
                self._collectionView.contentOffset.x = targetOffset
            })

            pageControl.currentPage = newPage

        default:
            break
        }
    }
    @IBAction func _continueEvent(_ sender: Any) {
        _purchaseProduct(id: selectedPlanId)
    }

    private func _successPurchase() {
        self.alert(title: "Purchase Success!", message: "You have successfully purchased, let's enjoy!") { alert in
            let controller = INIT_CONTROLLER_XIB(DashboardVC.self)
            self.navigationController?.pushViewController(controller, animated: true)
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
                self.alert(title: "Restore Success!", message: "You have successfully restored, let's enjoy!") { alert in
                    let controller = INIT_CONTROLLER_XIB(DashboardVC.self)
                    self.navigationController?.pushViewController(controller, animated: true)
                }
                return
            }
            self.alert(title: "Restore Failed!", message: error)
        }
    }
    @IBAction func _continueWithAds(_ sender: Any) {
        let vc = INIT_CONTROLLER_XIB(DashboardVC.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension OnBoardingVC:CustomCollectionViewDelegate,UICollectionViewDelegate, UIScrollViewDelegate
{
    
    func setupCollectionCell(_ cell: UICollectionViewCell, cellDict: [String : Any]?, indexPath: IndexPath) {
            guard let cell = cell as? BoardingCollectionCell,
                  let object = cellDict?[kCellObjectDataKey] as? infoData else { return }
            cell.setupData(object)
        }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           let pageWidth = scrollView.frame.width
           let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
           pageControl.currentPage = currentPage
       }

}
