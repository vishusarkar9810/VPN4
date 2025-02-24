//
//  OVOApiService.swift
//  OVOApp
//
//  Created by Creative on 20/12/23.
//

import UIKit
import Alamofire

private let kGetVPNListEndpoint = "get_vpn_list.php"

class VPNApiService: BaseApiService {

    // --------------------------------------
    // MARK: Overrides
    // --------------------------------------

    override class public var headers: [String: String] {
        var baseHeaders = super.headers
        baseHeaders[httpRequestHeaderNameAccept] = httpRequestContentAll
        baseHeaders[httpRequestHeaderAuthorization] = APPSESSION.token
        baseHeaders[httpRequestHeaderConnection] = httpRequestContentKeepAlive
//        baseHeaders[httpDeviceInfo] = deviceInfo
        print(baseHeaders)
        return baseHeaders
    }

    private class var _service: VPNApiService {
        VPNApiService()
    }

    
    public class func getVPNList(callback: ObjectResult<ContainerListModel<VPNModel>>? = nil) {
        let url = URLMANAGER.baseUrl(endPoint: kGetVPNListEndpoint)
        let request = POST(url, parameters: nil)
        _service.request(request, model: ContainerListModel<VPNModel>.self, callback: callback)
    }
  
}

