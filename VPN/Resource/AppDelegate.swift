//
//  AppDelegate.swift
//  VPN
//
//  Created by Creative on 10/06/24.
//

import UIKit
import SwiftyStoreKit
import GoogleMobileAds
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    let visualGradiantColor = UIColor(red: 0.5, green: 0.3, blue: 0.7, alpha: 1.0) // Example color
    let lightvisualGradiantColor = UIColor.white // Example color

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        SwiftyStoreKit.completeTransactions(atomically: true) { (purchases) in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction { SwiftyStoreKit.finishTransaction(purchase.transaction) }
                default: break
                }
            }
        }
        GADMobileAds.sharedInstance().start()
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers =
            [ "6AA1E83A-6C69-43F6-A222-E957C6F3CCD3" ]

        _ = APP.window
        if APP.window == nil { APP.window = UIWindow(frame: UIScreen.main.bounds) }
        guard let window = APP.window else { return true }
        //window.backgroundColor = .white
        applyCurrentTheme()
        APP.updateTheme()
        applyCurrentTheme()
        IAPManager.setUp()
        APPSESSION.moveToHome()
        BrandManager.setDefaultTheme()
        let backgroundColor = Preferences.isDarkMode ? visualGradiantColor : lightvisualGradiantColor
        window.backgroundColor = backgroundColor
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Show the app open ad when the app is foregrounded.
      //  AppOpenAdManager.shared.showAdIfAvailable()
    }

    private func applyCurrentTheme() {

        if Preferences.isDarkMode && Preferences.didShowInfo {
            applyDarkTheme()
        }

        if Preferences.isDarkMode
        {
            applyDarkTheme()
        }
        else if !Preferences.isDarkMode
        {
            applyLightTheme()
        }
    }

    private func applyDarkTheme()
    {

    }
    private func applyLightTheme()
    {

    }
}
