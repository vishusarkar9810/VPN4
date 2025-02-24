import Foundation
import SwiftyStoreKit

class IAPManager {
    
    static let shared = "dd91a97968ca4a7c8487adaf3444b52f"

    static func setUp() {

        SwiftyStoreKit.completeTransactions(atomically: true) { (purchases) in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction { SwiftyStoreKit.finishTransaction(purchase.transaction) }
                default: break
                }
            }
        }
    }

    static func purchaseProduct(id: String, _ handler: @escaping(_ error: String?) -> Void){
        SwiftyStoreKit.purchaseProduct(id) { result in
            switch result {
            case .success(let purchase):
                if purchase.needsFinishTransaction { SwiftyStoreKit.finishTransaction(purchase.transaction) }
                Preferences.currentProductId = purchase.productId
                Preferences.isPlanActivated = true
                handler(nil)
            case .error(error: let error):
                Preferences.isPlanActivated = false
                var errorMessage = kEmptyString
                switch error.code{
                case .unknown: errorMessage = "Unknown error. Please contact support"
                case .clientInvalid: errorMessage = "Not allowed to make the payment"
                case .paymentCancelled: errorMessage = "Payment cancel by user"
                case .paymentInvalid: errorMessage = "The purchase identifier was invalid"
                case .paymentNotAllowed: errorMessage = "The device is not allowed to make the payment"
                case .storeProductNotAvailable: errorMessage = "The product is not available in the current storefront"
                case .cloudServicePermissionDenied: errorMessage = "Access to cloud service information is not allowed"
                case .cloudServiceNetworkConnectionFailed: errorMessage = "Could not connect to the network"
                case .cloudServiceRevoked: errorMessage = "User has revoked permission to use this cloud service"
                default: errorMessage = (error as NSError).localizedDescription
                }
                handler(errorMessage)
            }
        }
    }

    static func restorePurchase(_ handler: @escaping(_ error : String?) -> Void){
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                Preferences.isPlanActivated = false
                handler("Restore Failed! please try again after sometime!")
            } else if results.restoredPurchases.count > 0 {
                guard let purchase = results.restoredPurchases.first else { return }
                if purchase.needsFinishTransaction { SwiftyStoreKit.finishTransaction(purchase.transaction) }
                Preferences.currentProductId = purchase.productId
                Preferences.isPlanActivated = true
                handler(nil)
            } else {
                Preferences.isPlanActivated = false
                handler("You have nothing to restore")
            }
        }
    }

    static func _validateReceipt(callback: ((String?,_ error : String?,_ isExpired: Bool) -> Void)? = nil) {
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: shared)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in

            var errorString: String? = "You have nothing to restore! Please try with subscribe."
            var endDate: String? = nil
            var isExpired: Bool = false
            switch result {
            case .success(let receipt):
                let purchaseResult = SwiftyStoreKit.verifySubscription(ofType: .autoRenewable, productId: Preferences.currentProductId, inReceipt: receipt)
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    errorString = nil
                    Preferences.isPlanActivated = true
                    print("\(Preferences.currentProductId) is valid until \(expiryDate.toExpireDate ?? "Wrong formate")\n\(items)\n")
                    endDate = expiryDate.toExpireDate
                case .expired(let expiryDate, let items):
                    Preferences.isPlanActivated = false
                    Preferences.currentProductId = kEmptyString
                    isExpired = true
                    errorString = "Your plan is expired since \(expiryDate.toExpireDate ?? kEmptyString)! Please try with subscribe."
                    endDate = nil
                    print("Your plan is expired since \(expiryDate.toExpireDate ?? kEmptyString)! \n \(items) ")
                case .notPurchased:
                    errorString = nil
                    endDate = nil
                    Preferences.isPlanActivated = false
                    Preferences.currentProductId = kEmptyString
                    print("The user has never purchased ")
                default:
                    errorString = nil
                    endDate = nil
                    print("Default case")
                }
            case .error(let error):
                errorString = error.localizedDescription
                endDate = nil
                print("Receipt verification failed: \(errorString ?? error.localizedDescription)")
            default:
                errorString = nil
                endDate = nil
            }

            callback?(endDate, errorString, isExpired)
        }
    }
}
