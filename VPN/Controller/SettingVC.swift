//
//  SettingVC.swift
//  VPN
//
//  Created by creative on 11/07/24.
//

import UIKit
import SafariServices
import MessageUI

class SettingVC: BaseViewController {

    @IBOutlet weak var _switchOutlet: UISwitch!
    @IBOutlet weak var _theamName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Preferences.isDarkMode {
            _switchOutlet.isOn = true
        } else {
            _switchOutlet.isOn = false
        }
        _changeTheamName()
    }

    private func _changeTheamName() {
        if Preferences.isDarkMode {
            _theamName.text = "Light"
        } else {
            _theamName.text = "Dark"
        }
    }

    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self // Set the delegate
            mailComposeVC.setToRecipients(["business@aztty.com"])
            mailComposeVC.setSubject("Support")
            present(mailComposeVC, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Email cannot be sent. Please set up an email account.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func _backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func switchThemeDidChange(_ sender: Any) {
        if (sender as AnyObject).isOn {
            Preferences.isDarkMode = true
        } else {
            Preferences.isDarkMode = false
        }
        _changeTheamName()
        APP.updateTheme()
    }

    @IBAction func policyButtonAction(_ sender: Any) {
        if let url = URL(string: "https://vicevpn.com/privacy-policy") {
            let safariVC = SFSafariViewController(url: url)
            safariVC.preferredControlTintColor = Preferences.isDarkMode ? ColorBrand.white : ColorBrand.black
            present(safariVC, animated: true, completion: nil)
        }
    }

    @IBAction func termsButtonAction(_ sender: Any) {
        if let url = URL(string: "https://vicevpn.com/vice-vpn-terms-and-conditions") {
            let safariVC = SFSafariViewController(url: url)
            safariVC.preferredControlTintColor = Preferences.isDarkMode ? ColorBrand.white : ColorBrand.black
            present(safariVC, animated: true, completion: nil)
        }
    }

    @IBAction func supportButtonAction(_ sender: Any) {
        sendEmail()
    }
}

extension SettingVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            // Dismiss the mail compose view controller
            controller.dismiss(animated: true, completion: nil)

            // Handle the result
            switch result {
            case .cancelled:
                print("Mail cancelled")
            case .saved:
                print("Mail saved")
            case .sent:
                print("Mail sent")
            case .failed:
                print("Mail failed with error: \(String(describing: error))")
            @unknown default:
                fatalError("Unknown mail compose result")
            }
        }
}
