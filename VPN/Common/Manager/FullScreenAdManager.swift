import UIKit
import MBProgressHUD
import GoogleMobileAds

let FULLSCREENADS = FullScreenAdManager.shared

class FullScreenAdManager: NSObject {

    //private let kGoogleFullScreenAdId = "ca-app-pub-3940256099942544/4411468910" // Test id
    private let kGoogleFullScreenAdId = "ca-app-pub-9136368944341050/5996798259" // Live id

    private var _interstitialAd: GADRewardedAd?
    private var _controller: UIViewController?
    private var _rewardCallback: (() -> Void)?

    // --------------------------------------
    // MARK: Singleton
    // --------------------------------------

    class var shared: FullScreenAdManager {
        struct Static {
            static let instance = FullScreenAdManager()
        }
        return Static.instance
    }

    override init() {
        super.init()
    }
    
    // --------------------------------------
    // MARK: Private
    // --------------------------------------
    
    private func _loadGoogle() {
        GADRewardedAd.load(withAdUnitID: kGoogleFullScreenAdId, request: GADRequest()) { [weak self] ad, error in
            guard let self = self else { return }
            guard let ad = ad, let controller = self._controller else {
                self._rewardCallback?()
                Log.debug("GOOGLE AD LOAD ERROR: \(error?.localizedDescription ?? kEmptyString)")
                return
            }
            self._interstitialAd = ad
            self._interstitialAd?.fullScreenContentDelegate = self
            DISPATCH_ASYNC_MAIN {
                guard let window = APP.window else { return }
                MBProgressHUD.hide(for: window, animated: false)
            }
            self._interstitialAd?.present(fromRootViewController: controller){
            }
        }
    }
    
    // --------------------------------------
    // MARK: Public
    // --------------------------------------
    
    func show(controller: UIViewController, callback: (() -> Void)? = nil) {
        _controller = controller
        _rewardCallback = callback
        _loadGoogle()
    }
}

extension FullScreenAdManager: GADFullScreenContentDelegate {

    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        DISPATCH_ASYNC_MAIN {
            guard let window = APP.window else { return }
            MBProgressHUD.hide(for: window, animated: false)
        }
        _rewardCallback?()
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        DISPATCH_ASYNC_MAIN {
            guard let window = APP.window else { return }
            MBProgressHUD.hide(for: window, animated: false)
        }
        _rewardCallback?()
        Log.debug("GOOGLE AD SHOW ERROR: \(error.localizedDescription)")
    }
}
