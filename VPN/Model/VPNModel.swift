//
//  VPNModel.swift
//  VPN
//
//  Created by Creative on 12/06/24.
//


import Foundation
import ObjectMapper
import OpenVPNAdapter

class VPNModel: Mappable, ModelProtocol {
    
    var id: String = kEmptyString
    var country: String = kEmptyString
    var ovpn: String = kEmptyString
    var ipAddress: String = kEmptyString
    var premium: String = kEmptyString
    var recommend: String = kEmptyString
    var state: String = kEmptyString
    var countryCode: String = kEmptyString
    var image: String = kEmptyString

    // --------------------------------------
    // MARK: Class
    // --------------------------------------
    
    static var current: VPNModel? {
        let object = Mapper<VPNModel>().map(JSONString: Preferences.currentVPN)
        return object
    }
    
    // --------------------------------------
    // MARK: <Mappable>
    // --------------------------------------

    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        country <- map["country"]
        ovpn <- map["ovpn"]
        ipAddress <- map["ipAddress"]
        premium <- map["premium"]
        recommend <- map["recommend"]
        state <- map["state"]
        countryCode <- map["countryCode"]
        image <- map["image"]
    }
    
    // --------------------------------------
    // MARK: <ModelProtocol>
    // --------------------------------------

    func isValid() -> Bool {
        return true
    }
    
    // --------------------------------------
    // MARK: Public
    // --------------------------------------
    
    func save() {
        Preferences.currentVPN = self.toJSONString() ?? kEmptyString
        Preferences.isSelected = true
    }
    
    var vpnConfigs: OpenVPNConfigurationEvaluation? {
        do {
            let adapter = OpenVPNAdapter()
            let configuration = OpenVPNConfiguration()

            configuration.fileContent = ovpn.data(using: .utf8)
            let evaluation = try adapter.apply(configuration: configuration)

            return evaluation
        } catch {
            return nil
        }
    }

    var isPremium: Bool {
        premium == "1"
    }
}
