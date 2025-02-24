//
//  Copyright 2021 Google LLC
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import GoogleMobileAds
import UIKit

class SplashViewController: UIViewController, AppOpenAdManagerDelegate {
    var secondsRemaining: Int = 3
    var countdownTimer: Timer?
    private var isMobileAdsStartCalled = false
    @IBOutlet weak var splashScreenLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        AppOpenAdManager.shared.appOpenAdManagerDelegate = self
        if !Preferences.isPlanActivated {
            startTimer()

            GoogleMobileAdsConsentManager.shared.gatherConsent(from: self) {
                [weak self] consentError in
                guard let self else { return }

                if let consentError {
                    // Consent gathering failed.
                    print("Error: \(consentError.localizedDescription)")
                }


                if GoogleMobileAdsConsentManager.shared.canRequestAds {
                    self.startGoogleMobileAdsSDK()

                }

                // Move onto the main screen if the app is done loading.
                if self.secondsRemaining <= 0 {
                    self.startMainScreen()
                }
            }

            // This sample attempts to load ads using consent obtained in the previous session.

            if GoogleMobileAdsConsentManager.shared.canRequestAds {
                startGoogleMobileAdsSDK()
            }

        } else {
            self.startMainScreen()
        }
    }

    @objc func decrementCounter() {
        secondsRemaining -= 1
        guard secondsRemaining <= 0 else {
            splashScreenLabel.text = "Loading ..."
            return
        }

        countdownTimer?.invalidate()

        AppOpenAdManager.shared.showAdIfAvailable()

    }

    private func startGoogleMobileAdsSDK() {
        DispatchQueue.main.async {
            guard !self.isMobileAdsStartCalled else { return }

            self.isMobileAdsStartCalled = true

            // Initialize the Google Mobile Ads SDK.
            GADMobileAds.sharedInstance().start()

            // Load an ad.
            Task {
                await AppOpenAdManager.shared.loadAd()
            }
        }
    }

    func startTimer() {
        splashScreenLabel.text = "Loading ..."
        countdownTimer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(SplashViewController.decrementCounter),
            userInfo: nil,
            repeats: true)
    }

    func startMainScreen() {
        AppOpenAdManager.shared.appOpenAdManagerDelegate = nil
        APPSESSION.moveToBoarding()
    }

    // MARK: AppOpenAdManagerDelegate
    func appOpenAdManagerAdDidComplete(_ appOpenAdManager: AppOpenAdManager) {
        startMainScreen()
    }
}
