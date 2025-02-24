//
//  AppOpenAdManager.swift
//  VPN
//
//  Created by Creative Infoway on 12/08/24.
//

import Foundation
import GoogleMobileAds

protocol AppOpenAdManagerDelegate: AnyObject {
    func appOpenAdManagerAdDidComplete(_ appOpenAdManager: AppOpenAdManager)
}

class AppOpenAdManager: NSObject {

   // private let kGoogleOpenAdId = "ca-app-pub-3940256099942544/5575463023" // Test id
    private let kGoogleOpenAdId = "ca-app-pub-9136368944341050/6654401666" // Live id
    let timeoutInterval: TimeInterval = 4 * 3_600

    var appOpenAd: GADAppOpenAd?
    weak var appOpenAdManagerDelegate: AppOpenAdManagerDelegate?

    var isLoadingAd = false

    var isShowingAd = false

    var loadTime: Date?

    static let shared = AppOpenAdManager()

    private func wasLoadTimeLessThanNHoursAgo(timeoutInterval: TimeInterval) -> Bool {
        if let loadTime = loadTime {
            return Date().timeIntervalSince(loadTime) < timeoutInterval
        }
        return false
    }

    private func isAdAvailable() -> Bool {
        return appOpenAd != nil && wasLoadTimeLessThanNHoursAgo(timeoutInterval: timeoutInterval)
    }

    private func appOpenAdManagerAdDidComplete() {

        appOpenAdManagerDelegate?.appOpenAdManagerAdDidComplete(self)
    }

    func loadAd() async {
        // Do not load ad if there is an unused ad or one is already loading.
        if isLoadingAd || isAdAvailable() {
            return
        }
        isLoadingAd = true

        print("Start loading app open ad.")

        do {
            appOpenAd = try await GADAppOpenAd.load(
                withAdUnitID: kGoogleOpenAdId, request: GADRequest())
            appOpenAd?.fullScreenContentDelegate = self
            loadTime = Date()
        } catch {
            appOpenAd = nil
            loadTime = nil
            print("App open ad failed to load with error: \(error.localizedDescription)")
        }
        isLoadingAd = false
    }

    func showAdIfAvailable() {
        // If the app open ad is already showing, do not show the ad again.
        if isShowingAd {
            print("App open ad is already showing.")
            return
        }
        // If the app open ad is not available yet but it is supposed to show,
        // it is considered to be complete in this example. Call the appOpenAdManagerAdDidComplete
        // method and load a new ad.
        if !isAdAvailable() {
            print("App open ad is not ready yet.")
            appOpenAdManagerAdDidComplete()
            if GoogleMobileAdsConsentManager.shared.canRequestAds {
                Task {
                    await loadAd()
                }
            }
            return
        }
        if let ad = appOpenAd {
            print("App open ad will be displayed.")
            isShowingAd = true
            ad.present(fromRootViewController: nil)
        }
    }
}

extension AppOpenAdManager: GADFullScreenContentDelegate {
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("App open ad is will be presented.")
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        appOpenAd = nil
        isShowingAd = false
        print("App open ad was dismissed.")
        appOpenAdManagerAdDidComplete()
        Task {
            await loadAd()
        }
    }

    func ad(
        _ ad: GADFullScreenPresentingAd,
        didFailToPresentFullScreenContentWithError error: Error
    ) {
        appOpenAd = nil
        isShowingAd = false
        print("App open ad failed to present with error: \(error.localizedDescription)")
        appOpenAdManagerAdDidComplete()
        Task {
            await loadAd()
        }
    }
}
