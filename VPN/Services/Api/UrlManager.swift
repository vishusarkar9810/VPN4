import UIKit

let URLMANAGER = UrlManager.shared

class UrlManager: NSObject {

    private var _baseUrlDev: String = "https://vicevpn.com/xvpn/v2/api/"
    
    // --------------------------------------
    // MARK: Singleton
    // --------------------------------------

    class var shared: UrlManager {
        struct Static {
            static let instance = UrlManager()
        }
        return Static.instance
    }

    override init() {
        super.init()
    }

    // --------------------------------------
    // MARK: Private
    // --------------------------------------

    private func _baseServiceUrl() -> String {
        return _baseUrlDev
    }
    
    // --------------------------------------
    // MARK: Public Functions
    // --------------------------------------

    func baseUrl(endPoint: String) -> String {
        var newUrl = kEmptyString
        let baseServiceUrl = _baseServiceUrl()
        if baseServiceUrl.hasSuffix("/") {
            newUrl = String(format: "%@%@", baseServiceUrl, endPoint)
        } else {
            if endPoint.hasPrefix("/") {
                newUrl = String(format: "%@%@", baseServiceUrl, endPoint)
            } else {
                newUrl = String(format: "%@/%@", baseServiceUrl, endPoint)
            }
        }
        return newUrl
    }

}
