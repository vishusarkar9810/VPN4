//
//  PlanModel.swift
//  VPN
//
//  Created by creative on 13/07/24.
//

import Foundation
import UIKit
import ObjectMapper

class PlanModel: Mappable, ModelProtocol {
    
    var id: String = kEmptyString
    var iapId: String = kEmptyString
    var name: String = kEmptyString
    var price: String = kEmptyString
    var iapPrice: String = kEmptyString
    var description: String = kEmptyString
    var subscriptionType: String = kEmptyString

    // --------------------------------------
    // MARK: <Mappable>
    // --------------------------------------

    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        iapId <- map["iap_id"]
        name <- map["name"]
        price <- map["price"]
        iapPrice <- map["iap_price"]
        description <- map["description"]
        subscriptionType <- map["subscription_type"]
    }
    
    // --------------------------------------
    // MARK: <ModelProtocol>
    // --------------------------------------

    func isValid() -> Bool {
        return true
    }
}
