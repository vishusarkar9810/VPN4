//
//  File.swift
//
//  Created by Creati      ve on 30/09/23.
//

import Foundation
import AVFoundation
import UIKit
import ObjectMapper



let APPSESSION = ApplicationSessionManager.shared

class ApplicationSessionManager: NSObject {
    
    
    // -------------------------------------
    // MARK: Singleton
    // --------------------------------------
    
    class var shared: ApplicationSessionManager {
        struct Static {
            static let instance = ApplicationSessionManager()
        }
        return Static.instance
    }

    public var token: String {
        Preferences.token == kEmptyString ? kEmptyString : "Bearer \(Preferences.token)"
    }

//    public var userDetail: UserModel? {
//        guard let members = Mapper<UserModel>().map(JSONString: Preferences.userDetailModel) else {
//            return nil
//        }
//        return members
//    }
//
//    private var userSettings: UserSettingModel?
//    public var countryList: [CountriesModel]? {
//        return userSettings?.countries
//    }

//    public var iqdToUsd: Int {
//        return Int(userSettings?.iqdToUsd ?? "0") ?? 0
//    }
//
//    public var transferFee: Double {
//        return Double(userSettings?.transferFee ?? "0.0") ?? 0.0
//    }
//
//    public var privacyPolicy: String {
//        return userSettings?.privacyPolicy ?? kEmptyString
//    }
//
//    public var termsAndCondition: String {
//        return userSettings?.termsCondition ?? kEmptyString
//    }
//
//    override init() {
//        super.init()
//    }
//
    
    // --------------------------------------
    // MARK: Acccesors
    // --------------------------------------

//    func login(params: [String: Any], callback: BooleanResult?) {
//         OVOApiService.login(params: params) { [weak self] container, error in
//            guard let self = self else { return }
//            guard let model = container?.data else {
//
//                callback?(false, error)
//                return
//            }
//            if !model.token.isEmpty {
//                Preferences.token = model.token
//                Preferences.didLogin = true
//            }
//            self._saveLoginData(model)
//            callback?(true, nil)
//        }
//    }

//    private func _saveLoginData(_ model: ) {
//        if let jsonStr = model.toJSONString() {
//            Preferences.didLogin = true
//            Preferences.userDetailModel = jsonStr
//        }
//    }

//    func getUserSettings(callback: BooleanResult? = nil) {
//        BidzpayApiService.getUserSettings() { [weak self] container, error in
//            guard let self = self else { return }
//            guard let model = container?.data else {
//                callback?(false, error)
//                return
//            }
//            self.userSettings = model
//            callback?(true, error)
//        }
//    }
//
//
//    public func logout(callback: BooleanResult?) {
//        Preferences.didLogin = false
//        callback?(true, nil)
//    }
//
//    func signup( params: [String: Any],callback: BooleanResult?) {
//        OVOApiService.signup(params: params) { [weak self] container, error in
//            guard let self = self else { return }
//            guard let model = container?.data else {
//                callback?(false, error)
//                return
//            }
//            if !model.token.isEmpty {
//                Preferences.token = model.token
//                Preferences.didLogin = true
//            }
//            self._saveLoginData(model)
//            callback?(true, nil)
//        }
//    }
//
//    func createpin(params: [String: Any], callback: BooleanResult?) {
//        BidzpayApiService.CreatePin(params: params) { [weak self] container, error in
//            guard let self = self else { return }
//            guard let model = container?.data else {
//                callback?(false, error)
//                return
//            }
//            self._savecreatePin(model)
//            callback?(true, nil)
//        }
//    }
//
//    private func _savecreatePin(_ model: VerifyModel) {
//        if let jsonStr = model.toJSONString() {
//            Preferences.didPin = true
//        }
//    }
//
//    func verifypin(params: [String: Any], callback: BooleanResult?) {
//        BidzpayApiService.VerifyPinSendMoney(params: params) { [weak self] container, error in
//            guard let self = self else { return }
//            guard let model = container?.data else {
//                callback?(false, error)
//                return
//            }
//            self._saveVerifyPin(model)
//            callback?(true, nil)
//        }
//    }
//
//    private func _saveVerifyPin(_ model: SendMoneyModel) {
//        if let jsonStr = model.toJSONString() {
//            Preferences.didPin = true
//        }
//    }
//
//    func UpdateProfile( params: [String: Any],callback: BooleanResult?) {
//        BidzpayApiService.updateProfile(params: params) { [weak self] container, error in
//            guard let self = self else { return }
//            guard let model = container?.data else {
//                callback?(false, error)
//                return
//            }
//            self._saveLoginData(model)
//            callback?(true, nil)
//        }
//    }
//
//    func uploadProfileImage( image: UIImage, callback: BooleanResult?) {
//        BidzpayApiService.uploadProfileImg(image: image) {  [weak self] container, error in
//            guard let self = self else { return }
//            guard let model = container?.data else {
//                callback?(false, error)
//                return
//            }
//            self._saveLoginData(model)
//            callback?(true, nil)
//        }
//    }
    
//    func getUserInfo(callback: BooleanResult?) {
//        ElevateApiService.getUserDetail { [weak self] container, error in
//            guard let self = self else { return }
//            guard let model = container?.data else {
//                callback?(false, error)
//                return
//            }
//
//            self._saveLoginData(model)
//            callback?(true, nil)
//        }
//    }

    
    // --------------------------------------
    // MARK: Public
    // --------------------------------------
    func moveToBoarding() {
        if Preferences.didShowInfo == true  {
            guard let window = APP.window else { return }
            let navController = NavigationController(rootViewController: INIT_CONTROLLER_XIB(OnBoardingVC.self))
            navController.setNavigationBarHidden(true, animated: false)
            window.setRootViewController(navController, options: UIWindow.TransitionOptions(direction:.fade, style: .easeInOut))
            Preferences.didShowInfo = false
            return
        }
        else
        {
            guard let window = APP.window else { return }
            let navController = NavigationController(rootViewController: INIT_CONTROLLER_XIB(DashboardVC.self))
            navController.setNavigationBarHidden(true, animated: false)
            window.setRootViewController(navController, options: UIWindow.TransitionOptions(direction:.fade, style: .easeInOut))
        }
    }
    
    func moveToHome() {
        guard let window = APP.window else { return }
        let navController = NavigationController(rootViewController: INIT_CONTROLLER_XIB(SplashViewController.self))
        navController.setNavigationBarHidden(true, animated: false)
        window.setRootViewController(navController, options: UIWindow.TransitionOptions(direction:.fade, style: .easeInOut))
    }
    
//    func showVideoSplashScreen() {
//        // Get the URL of the video file
//        guard let videoURL = Bundle.main.url(forResource: "your_video_filename", withExtension: "mp4") else {
//            return
//        }
//
//        // Create an AVPlayer
//        let player = AVPlayer(url: videoURL)
//
//        // Create an AVPlayerViewController
//        let playerViewController = AVPlayerViewController()
//        playerViewController.player = player
//
//        // Present the AVPlayerViewController
//        present(playerViewController, animated: false) {
//            // Start playing the video
//            playerViewController.player?.play()
//        }
//    }

//    func moveToInfo() {
//        if Preferences.didShowInfo {
//            if Preferences.didLogin {
//                moveToHome()
//                return
//            } else {
//                moveToSplash()
//                return
//            }
//        }
//
//        guard let window = APP.window else { return }
//        let navController = NavigationController(rootViewController: INIT_CONTROLLER_XIB(InfoVC.self))
//        navController.setNavigationBarHidden(true, animated: false)
//        window.setRootViewController(navController, options: UIWindow.TransitionOptions(direction:.fade, style: .easeInOut))
//    }

//    func moveToHome() {
//        guard let window = APP.window else { return }
//        let navController = NavigationController(rootViewController: INIT_CONTROLLER_XIB(MainTabBarVC.self))
//        navController.setNavigationBarHidden(true, animated: false)
//        window.setRootViewController(navController, options: UIWindow.TransitionOptions(direction:.fade, style: .easeInOut))
//    }
    
//    func moveToSignUp() {
//        guard let window = APP.window else { return }
//        let navController = NavigationController(rootViewController: INIT_CONTROLLER_XIB(SignUpViewController.self))
//        navController.setNavigationBarHidden(true, animated: false)
//        window.setRootViewController(navController, options: UIWindow.TransitionOptions(direction:.fade, style: .easeInOut))
//    }
//
//    func moveToVerifyPin() {
//       guard let window = APP.window else { return }
//        let controller = INIT_CONTROLLER_XIB(VerifyPinViewController.self)
//        controller.isFromSignup = true
//       let navController = NavigationController(rootViewController: controller)
//       navController.setNavigationBarHidden(true, animated: false)
//       window.setRootViewController(navController, options: UIWindow.TransitionOptions(direction:.fade, style: .easeInOut))
//   }

//    func getCountryCodeByCountryId(countryId: Int) -> String? {
//        return countryList?.first(where: { $0.id == countryId})?.code
//    }

}
