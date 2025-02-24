import UIKit

struct Preferences {

    @propertyWrapper
    struct UserDefault<T> {
        let key: String
        let defaultValue: T

        init(_ key: String, defaultValue: T) {
            self.key = key
            self.defaultValue = defaultValue
        }

        var wrappedValue: T {
            get {
                UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
            }
            set {
                UserDefaults.standard.set(newValue, forKey: key)
            }
        }
    }

    @propertyWrapper
    struct UserDefaultURL {
        let key: String
        let defaultValue: String

        init(_ key: String, defaultValue: String) {
            self.key = key
            self.defaultValue = defaultValue
        }

        var wrappedValue: String {
            get {
                guard let localUrl = UserDefaults.standard.string(forKey: key) else { return defaultValue }
                let trimmedUri = uriWithoutTrailingSlashes(localUrl).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                if !validateUrl(trimmedUri) { return defaultValue }
                return trimmedUri
            }
            set {
                UserDefaults.standard.set(newValue, forKey: key)
            }
        }
    }
   
    private static let defaults = UserDefaults.standard
    @UserDefault("token", defaultValue: kEmptyString) static var token: String
    @UserDefault("didlogin", defaultValue: false) static var didLogin: Bool
    @UserDefault("didPin", defaultValue: false) static var didPin: Bool
    @UserDefault("userDetailModel", defaultValue: kEmptyString) static var userDetailModel: String
    @UserDefault("searchHistory", defaultValue: kEmptyString) static var searchHistory: String
    @UserDefault("searchText", defaultValue: []) static var searchText: [String]
    @UserDefault("didShowInfo", defaultValue: true) static var didShowInfo: Bool
    @UserDefault("email", defaultValue: kEmptyString) static var email: String
    @UserDefault("password", defaultValue: kEmptyString) static var password: String
    @UserDefault("currentVPN", defaultValue: kEmptyString) static var currentVPN: String
    @UserDefault("isPlanActivated", defaultValue: false) static var isPlanActivated: Bool
    @UserDefault("bidzVpnConnection", defaultValue: false) static var bidzVpnConnection: Bool
    @UserDefault("connectedDate", defaultValue: nil) static var vpnConnectedDate: Date?
    @UserDefault("isVPNConnected", defaultValue: false) static var isVPNConnected: Bool
    @UserDefault("isDarkMode", defaultValue: false) static var isDarkMode: Bool
    @UserDefault("isSelected", defaultValue: true) static var isSelected: Bool
    @UserDefault("currentProductId", defaultValue: kEmptyString) static var currentProductId: String
   
    
    private static func validateUrl(_ stringURL: String) -> Bool {
        let url: URL? = URL(string: stringURL)
        return url != nil
    }

    static func uriWithoutTrailingSlashes(_ hostUri: String) -> String {
        if !hostUri.hasSuffix("/") {
            return hostUri
        }
        return String(hostUri[..<hostUri.index(before: hostUri.endIndex)])
    }
    
    static func clearConnectedDate() {
        defaults.removeObject(forKey: "connectedDate")
        defaults.synchronize()
    }
}
