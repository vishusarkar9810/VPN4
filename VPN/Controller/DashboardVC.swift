//
//  DashboardVC.swift
//  VPN
//
//  Created by creative on 10/07/24.
//

import UIKit
import NetworkExtension
import NDT7
import Lottie


class DashboardVC: BaseViewController {
    
    private var _isAdShownAfterConnection: Bool = false

    @IBOutlet weak var _countryImg: UIImageView!
    @IBOutlet weak var _countryNameLbl: UILabel!
    @IBOutlet weak var _timeLabel: UILabel!
    private var _isConnectedToVpn: Bool = false
    private var _providerManager: NETunnelProviderManager?
    private var _timer: Timer?
    private var _timerCount: Int = 0
    @IBOutlet weak var _downSpeedLbl: UILabel!
    @IBOutlet weak var _upSpeedLbl: UILabel!
    private lazy var _speedTest: NDT7Test = {
        let settings = NDT7Settings()
        let ndt7Test = NDT7Test(settings: settings)
        ndt7Test.delegate = self
        return ndt7Test
    }()
    @IBOutlet weak var switchBtn: UIButton!
    @IBOutlet weak var _vpnBG: UIImageView!
    @IBOutlet weak var _goPremiumBtn: UIVisualEffectView!
    @IBOutlet weak var animationView: LottieAnimationView!

    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
        setupUi()
        _timeLabel.text = "TAP TO CONNECT"
        NotificationCenter.default.addObserver(self, selector: #selector(self._handleVpnStateChange(_:)), name: .NEVPNStatusDidChange, object: nil)

        _loadProviderManager { [weak self] in
            guard let self = self else { return }
            self._updateConnectionStatus()
            self._updateSwitchButtonState()
        }


    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Preferences.isPlanActivated {
            _goPremiumBtn.isHidden = true
        }
        _loadProviderManager { [weak self] in
               guard let self = self else { return }
               self._updateVPN()
               self._updateSwitchButtonState()
           }

    }
    private func _getCurrentPlanDetail() {
        if !Preferences.currentProductId.isEmpty {
            showloader()

            IAPManager._validateReceipt { [weak self] expiredDate, error, isExpired in
                guard let self = self else { return }
                hideloader()
                if isExpired {
                    Preferences.isPlanActivated = false
                    Preferences.currentProductId = kEmptyString
                    self._goPremiumBtn.isHidden = false
                }
            }
        }
    }

    override func setupUi() {
        _getCurrentPlanDetail()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .NEVPNStatusDidChange, object: nil)
    }

    private func _loadProviderManager(handler: (() -> Void)? = nil) {
        NETunnelProviderManager.loadAllFromPreferences { [weak self] managers, error in
            guard let self = self else { return }
            guard error == nil else {
                self.alert(title: kAppName, message: "Please allow VPN to connect")
                return
            }
            self._providerManager = managers?.first ?? NETunnelProviderManager()
            handler?()
        }
    }

    private func _loadProfiles() {
        if _isConnectedToVpn { _stopVPN() }

        guard _providerManager == nil else {
            self._createTunnelProvider()
            return
        }

        NETunnelProviderManager.loadAllFromPreferences { [weak self] managers, error in
            guard let self = self else { return }
            guard error == nil else {
                self.alert(title: kAppName, message: "Please allow VPN to connect")
                return
            }
            self._providerManager = managers?.first ?? NETunnelProviderManager()
        }
    }

    private func _createTunnelProvider() {
        guard let providerManager = _providerManager,
              let model = VPNModel.current,
              let configData = model.ovpn.data(using: .utf8),
              let vpnConfigs = model.vpnConfigs else { return }

        providerManager.loadFromPreferences { [weak self] error in
            guard let self = self else { return }
            guard error == nil else {
                self.alert(title: kAppName, message: "Please allow VPN to connect")
                return
            }

            let tunnelProtocol = NETunnelProviderProtocol()
            tunnelProtocol.username = vpnConfigs.username ?? kEmptyString
            tunnelProtocol.serverAddress = vpnConfigs.remoteHost ?? model.ipAddress
            tunnelProtocol.providerBundleIdentifier = kAppExtensionId
            tunnelProtocol.providerConfiguration = ["ovpn": configData, "username": kEmptyString, "password": kEmptyString]
            providerManager.protocolConfiguration = tunnelProtocol
            providerManager.localizedDescription = "\(kAppName) - \(model.country)"
            providerManager.isEnabled = true

            providerManager.saveToPreferences { error in
                guard error == nil else {
                    self.alert(title: kAppName, message: error?.localizedDescription)
                    return
                }

                providerManager.loadFromPreferences { error in
                    guard error == nil else {
                        self.alert(title: kAppName, message: error?.localizedDescription)
                        return
                    }
                    self._startTunnel()
                }
            }
        }
    }

    private func _startTunnel() {
        do {
            try _providerManager?.connection.startVPNTunnel()
        } catch let error {
            self.alert(title: kAppName, message: error.localizedDescription)
        }
    }

    private func _stopVPN() {
        _providerManager?.connection.stopVPNTunnel()
    }

    // --------------------------------------
    // MARK: Private
    // --------------------------------------

    private func _updateConnectionStatus(isReset: Bool = false) {
        let isConnected = _providerManager?.connection.status == .connected
        if isConnected {
            _startTimer()
            _startSpeedTest()
        } else {
            if isReset { Preferences.clearConnectedDate() }
            _stopTimer()
            _stopSpeedTest()
        }
        _isConnectedToVpn = isConnected
    }
    
    private func _updateSwitchButtonState() {
        guard let providerManager = _providerManager else { return }
        if providerManager.connection.status == .connected {
            if !switchBtn.isSelected {
                switchBtn.isSelected = true
                animationView.play(fromProgress: 0, toProgress: 1, loopMode: .playOnce)
            }
            _timeLabel.text = "Connected"
            _startTimer()

        } else if providerManager.connection.status == .disconnected {
            
            if switchBtn.isSelected {
                switchBtn.isSelected = false
                animationView.play(fromProgress: 1, toProgress: 0, loopMode: .playOnce)
            }
            _timeLabel.text = "TAP TO CONNECT"
            _stopTimer()

        } else if providerManager.connection.status == .connecting {
           
            _timeLabel.text = "Connecting..."
        }
    }

    private func _updateVPN() {
        guard let model = VPNModel.current else { return }
        _countryNameLbl.text = model.country
        _countryImg.loadWebImage(model.image)
    }

    private func _checkInterNetConnection() {
        guard APP.isConnectedToInternet else {
            alert(title: kAppName, message: "Please Check Your internet Connection")
            return
        }
        self._loadProfiles()
    }

    private func _stopTimer() {
        isRequesting = false
        if _timer != nil {
            _timer?.invalidate()
            _timer = nil
        }
        _timeLabel.text = "TAP TO CONNECT"
    }

    private func _startTimer(isReset: Bool = false) {
        isRequesting = false
        if _timer != nil {
            _timer?.invalidate()
            _timer = nil
        }
        _timeLabel.text = "Connected"
        if let connectedDate = Preferences.vpnConnectedDate {
            _timerCount = Int(Date().timeIntervalSince(connectedDate))
            _updateConnectionTime()
        }
        _timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(_updateConnectionTime), userInfo: nil, repeats: true)
    }

    // --------------------------------------
    // MARK: Public
    // --------------------------------------

    public func stopVPN() {
        _stopVPN()
    }

    // --------------------------------------
    // MARK: Event
    // --------------------------------------

    @IBAction func goPremiumEvent(_ sender: Any) {
        let vc = INIT_CONTROLLER_XIB(SubscriptionVC.self)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func _handleConnectEvent(_ sender: UIButton){
        guard !isRequesting else { return }

            guard VPNModel.current != nil else {
                _handleVpnEvent(sender)
                return
            }

            _timeLabel.text = "Connecting..."

            if switchBtn.isSelected {
                switchBtn.isSelected = false
                animationView.play(fromProgress: 1, toProgress: 0, loopMode: .playOnce)
                if Preferences.isPlanActivated {
                    _stopVPN()
                    _timeLabel.text = "TAP TO CONNECT"
                    return
                }

                // Stop VPN directly (no ad logic here)
                DISPATCH_ASYNC_MAIN {
                    self._stopVPN()
                }
                self._timeLabel.text = "TAP TO CONNECT"

            } else {
                switchBtn.isSelected = true
                animationView.play(fromProgress: 0, toProgress: 1, loopMode: .playOnce)

                if Preferences.isPlanActivated {
                    guard _isConnectedToVpn == false else {
                        switchBtn.isSelected = false
                        animationView.play(fromProgress: 1, toProgress: 0, loopMode: .playOnce)
                        _stopVPN()
                        return
                    }

                  
                    _timeLabel.text = "Connecting..."
                    _checkInterNetConnection()
                    return
                }

                // Start VPN connection directly (no ad logic here)
                guard self._isConnectedToVpn == false else {
                    self.switchBtn.isSelected = false
                    self.animationView.play(fromProgress: 1, toProgress: 0, loopMode: .playOnce)
                    DISPATCH_ASYNC_MAIN {
                        self._stopVPN()
                    }
                    return
                }

                DISPATCH_ASYNC_MAIN {
                    self._checkInterNetConnection()
                }
            }
        }

    @IBAction private func _handleVpnEvent(_ sender: UIControl) {
        let controller = INIT_CONTROLLER_XIB(VPNListVC.self)
        let name = _countryNameLbl.text?.trim
        controller.isName = name ?? ""
        navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction private func _handleMenuEvent(_ sender: UIControl) {
        let controller = INIT_CONTROLLER_XIB(SettingVC.self)

        navigationController?.pushViewController(controller, animated: true)
    }

    @objc private func _updateConnectionTime() {
        _timerCount += 1
        let seconds = _timerCount % 60
        let minutes = (_timerCount / 60) % 60
        let hours = (_timerCount / 3600)
        let text = String(format:"%d : %02d : %02d", hours, minutes, seconds)
        _timeLabel.text = text
    }

    @objc private func _handleVpnStateChange(_ notification: Notification?) {
        guard let tunnelProvider = notification?.object as? NETunnelProviderSession else { return }

        switch tunnelProvider.status {
        case NEVPNStatus.invalid:
            isRequesting = false
            _stopTimer()
            _timeLabel.text = "Invalid"
            Log.debug("CONNECTION STATUS: Invalid")
        case NEVPNStatus.disconnected:
            _updateConnectionStatus(isReset: _isConnectedToVpn)
            Preferences.isVPNConnected = false
            _isAdShownAfterConnection = false // Reset the flag when disconnected
            Log.debug("CONNECTION STATUS: Disconnected")
        case NEVPNStatus.connecting:
            isRequesting = true
            _timeLabel.text = "Connecting..."
            Log.debug("CONNECTION STATUS: Connecting")
        case NEVPNStatus.connected:
            if Preferences.vpnConnectedDate == nil { Preferences.vpnConnectedDate = Date() }
            _updateConnectionStatus()
            Preferences.isVPNConnected = true
            Log.debug("CONNECTION STATUS: Connected")
            
            
            // Show interstitial ad only if it hasn't been shown yet
                    if !Preferences.isPlanActivated && !_isAdShownAfterConnection {
                        _isAdShownAfterConnection = true // Set the flag to true
                        FULLSCREENADS.show(controller: self) { [weak self] in
                            // Ad dismissed or failed to load
                            Log.debug("Ad dismissed or failed to load.")
                        }
                    }
            
        case NEVPNStatus.disconnecting:
            isRequesting = true
            _timeLabel.text = "Dissconnecting..."
            Log.debug("CONNECTION STATUS: Dissconnecting")
        case NEVPNStatus.reasserting:
            isRequesting = true
            _timeLabel.text = "ReConnecting..."
            Log.debug("CONNECTION STATUS: ReConnecting")
        default:
            _stopTimer()
            Log.debug("CONNECTION STATUS: \(tunnelProvider.status)")
            break
        }
    }

    private func _stopSpeedTest() {
        _speedTest.cancel()
        _downSpeedLbl.text = "0 MB"
        _upSpeedLbl.text = "0 MB"
    }

    private func _startSpeedTest() {
        _speedTest.startTest(download: true, upload: true) { (error) in
            Log.debug("SPEED TEST ERROR: \(String(describing: error))")
        }
    }
}

extension DashboardVC: NDT7TestInteraction {

    func error(kind: NDT7TestConstants.Kind, error: NSError) {
        _stopSpeedTest()
    }

    func measurement(origin: NDT7TestConstants.Origin, kind: NDT7TestConstants.Kind, measurement: NDT7Measurement) {

        if origin == .client,
           let elapsedTime = measurement.appInfo?.elapsedTime,
           let numBytes = measurement.appInfo?.numBytes,
           elapsedTime >= 1000000 {
            let seconds = elapsedTime / 1000000
            let mbit = numBytes / 125000
            let rounded = Double(Float64(mbit)/Float64(seconds)).roundTo(2)
            switch kind {
            case .download:
                DISPATCH_ASYNC_MAIN { [weak self] in
                    self?._downSpeedLbl.text = "\(rounded) MB"
                }
            case .upload:
                DISPATCH_ASYNC_MAIN { [weak self] in
                    self?._upSpeedLbl.text = "\(rounded) MB"
                }
            }
        } else if origin == .server,
                  let elapsedTime = measurement.tcpInfo?.elapsedTime,
                  elapsedTime >= 1000000 {
            let seconds = elapsedTime / 1000000
            switch kind {
            case .download:
                if let numBytes = measurement.tcpInfo?.bytesSent {
                    let mbit = numBytes / 125000
                    let rounded = Double(Float64(mbit)/Float64(seconds)).roundTo(2)
                    DISPATCH_ASYNC_MAIN { [weak self] in
                        self?._downSpeedLbl.text = "\(rounded) MB"
                    }
                }
            case .upload:
                if let numBytes = measurement.tcpInfo?.bytesReceived {
                    let mbit = numBytes / 125000
                    let rounded = Double(Float64(mbit)/Float64(seconds)).roundTo(2)
                    DISPATCH_ASYNC_MAIN { [weak self] in
                        self?._upSpeedLbl.text = "\(rounded) MB"
                    }
                }
            }
        }
    }
}
