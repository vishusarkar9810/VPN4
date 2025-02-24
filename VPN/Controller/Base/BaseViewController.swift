import UIKit
import Toast_Swift
import MBProgressHUD
import Foundation


class BaseViewController: UIViewController {

	var isRequesting: Bool = false
    var isModal: Bool = false
    var didLoad: Bool = false
    var feedbackGenerator: UIImpactFeedbackGenerator?
    @IBInspectable var enableBackgroundImage: Bool = false
    @IBInspectable var isTopShadow: Bool = true
    
    // --------------------------------------
    // MARK: Life Cycle
    // --------------------------------------

    override func viewDidLoad() {
		super.viewDidLoad()
//        _setupBackgroundImageView()
        feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator?.prepare()
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotificationBadgeEvent(_:)), name: .updateNotificationBadge, object: nil)
	}
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .updateNotificationBadge, object: nil)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
		UIStatusBarStyle.lightContent
	}
    
    // --------------------------------------
    // MARK: Private
    // --------------------------------------

//    private func _setupBackgroundImageView() {
//        if enableBackgroundImage {
//            let imageView = UIImageView.init(image: UIImage(named: isTopShadow ? "image_gradientBg" : "image_gradientBg"))
//            imageView.contentMode = .scaleAspectFill
//            view.insertSubview(imageView, at: 0)
//            imageView.snp.makeConstraints { make in
//                make.left.equalToSuperview()
//                make.right.equalToSuperview()
//                make.top.equalToSuperview()
//                make.bottom.equalToSuperview()
//            }
//        }
//    }
    
//    private func _updateSkeletonLoading(isShow: Bool = true) {
//        guard isShow else {
//            view.hideSkeleton(transition: .crossDissolve(0.5))
//            return
//        }
//        
//        DISPATCH_ASYNC_MAIN_AFTER(0.001) {
//            self.view.isSkeletonable = true
//            guard !self.didLoad else { return }
//            let gradient = SkeletonGradient(baseColor: ColorBrand.brandGray)
//            self.view.showAnimatedGradientSkeleton(usingGradient: gradient, transition: .crossDissolve(0.5))
//        }
//    }
    
    // --------------------------------------
    // MARK: Event
    // --------------------------------------
    
    @objc func handleNotificationBadgeEvent(_ sender: Notification) {
        
    }
    
    // --------------------------------------
    // MARK: Public
    // --------------------------------------

    var isVisible: Bool {
		isViewLoaded && view.window != nil
	}

    func setupUi() {}
    
    func alert(title: String = kAppName, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in }))
        DISPATCH_ASYNC_MAIN {[weak self] in self?.present(alert, animated: true) }
    }

    func alert(title: String = kAppName, message: String?, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {action in
            DISPATCH_ASYNC_MAIN { handler?(action) }
        }))
        DISPATCH_ASYNC_MAIN { [weak self] in self?.present(alert, animated: true) }
    }
    
    func alert(title: String = kAppName, message: String?, option : String = "Ok", okHandler: ((UIAlertAction) -> Void)? = nil, cancelHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: option, style: .default, handler: {action in
            DISPATCH_ASYNC_MAIN { okHandler?(action) }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            DISPATCH_ASYNC_MAIN { cancelHandler?(action) }
        }))
        DISPATCH_ASYNC_MAIN {[weak self] in self?.present(alert, animated: true) }
    }

    func alert(title: String = kAppName, message: String?, okActionTitle: String = "Ok", okHandler: ((UIAlertAction) -> Void)? = nil, cancelHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okActionTitle, style: .destructive, handler: {action in
            DISPATCH_ASYNC_MAIN { okHandler?(action) }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
            DISPATCH_ASYNC_MAIN { cancelHandler?(action) }
        }))
        DISPATCH_ASYNC_MAIN {[weak self] in self?.present(alert, animated: true) }
    }

    func confirmAlert(title: String = kAppName, message: String?, okHandler: ((UIAlertAction) -> Void)? = nil, noHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
            DISPATCH_ASYNC_MAIN { noHandler?(action) }
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {action in
            DISPATCH_ASYNC_MAIN { okHandler?(action) }
        }))
        DISPATCH_ASYNC_MAIN { [weak self] in self?.present(alert, animated: true) }
    }
    
    func dismissAllPresentedControllers(animated: Bool, complition: (() -> Void)? = nil) {
        APP.window?.rootViewController?.dismiss(animated: animated, completion: complition)
    }
    func showError(_ error: NSError?) {
        guard let error = error else { return }
        alert(message: error.localizedDescription)
    }

    func showloader() {
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
    }

    func hideloader(){
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: false)
        }
    }

//    func showSuccessMessage(_ title: String, subtitle: String) {
//        let banner = NotificationBanner(title: title, subtitle: subtitle, style: .success, colors: self)
//        banner.show(bannerPosition: .top)
//        banner.applyStyling(titleFont: FontBrand.navBarTitleFont, titleColor: .darkText, titleTextAlign: .left, subtitleFont: FontBrand.navBarSubtitleFont, subtitleColor: .darkGray, subtitleTextAlign: .left )
//    }
//
//    func showFailMessage(_ title: String, subtitle: String) {
//        let banner = NotificationBanner(title: title, subtitle: subtitle, style: .danger)
//        banner.show()
//    }
//
//    func requestShare() {
//        Utils.generateDynamicShareLink(businessId: "", title: "", description: "", imageUrl: "") { [weak self] url in
//            guard let self = self else { return }
//
//            let shareMessage = "\("")\n\n\("")\n\n\(url ?? kEmptyString)"
//            Log.debug("============ShareURL============\(url ?? kEmptyString)")
//
//            let items = [shareMessage]
//            let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
//            controller.setValue(kAppName, forKey: "subject")
//            controller.popoverPresentationController?.sourceView = self.view
//            controller.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToTwitter]
//            self.present(controller, animated: true, completion: nil)
//        }
//    }
    
    func hideNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func showNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func hideNavigationSepratorLine() {
        (navigationController as? NavigationController)?.updateSepratorLine(isHidden: true)
    }
    
    func showNavigationSepratorLine() {
        (navigationController as? NavigationController)?.updateSepratorLine()
    }
    
//    var isInternetAvailable: Bool {
//        let isAvailable = NETWORKMANAGER.isConnectionAvailable
//        if !isAvailable { NETWORKMANAGER.presentAlert() }
//        return isAvailable
//    }
    
    func formatRevenue(revenue: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US") // Set locale to US for dollar currency
        
        if let formattedRevenue = formatter.string(from: NSNumber(value: revenue)) {
            return formattedRevenue
        } else {
            return "Unknown"
        }
    }
    
    func makeTextBold(inLabel label: UILabel, fullSentence: String, boldText: String) {
        let attributedString = NSMutableAttributedString(string: fullSentence)
        let boldRange = (fullSentence as NSString).range(of: boldText)
        
        let boldFont = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        attributedString.addAttribute(.font, value: boldFont, range: boldRange)
        
        label.attributedText = attributedString
    }
}

extension BaseViewController {
    public func showToast(_ msg: String, _ position: ToastPosition) {
        view.makeToast(msg, duration: 1.0, position: position)
    }

}

//extension BaseViewController: BannerColorsProtocol {
//
//    public func color(for style: BannerStyle) -> UIColor {
//        switch style {
//            case .danger:
//                return UIColor(red:0.90, green:0.31, blue:0.26, alpha:1.00)
//            case .info:
//                return UIColor(red:0.23, green:0.60, blue:0.85, alpha:1.00)
//            case .customView:
//                return .clear
//            case .success:
//                return UIColor(red:254/256, green:245/256, blue:245/256, alpha:1.00)
//            case .warning:
//                return UIColor(red:1.00, green:0.66, blue:0.16, alpha:1.00)
//        @unknown default:
//            return UIColor(red:0.23, green:0.60, blue:0.85, alpha:1.00)
//        }
//    }
//}
