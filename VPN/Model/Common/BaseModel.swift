import Foundation
import ObjectMapper

class BaseModel: Mappable, ModelProtocol {
    
    var code: Int = 0
    var message: String = kEmptyString

    // --------------------------------------
    // MARK: <Mappable>
    // --------------------------------------

    required init?(map _: Map) {}

    func mapping(map: Map) {
        code <- map["status.code"]
        message <- map["status.message"]
    }

    // --------------------------------------
    // MARK: <ModelProtocol>
    // --------------------------------------

    func isValid() -> Bool {
        isSuccess
    }
    
    var statusMessage: String? {
        message
    }
    
    // --------------------------------------
    // MARK: Public
    // --------------------------------------
    
    var isSuccess: Bool {
        code == 1 || message == "Success"
    }
    
    var error: NSError? {
        let code: ErrorCode = code == 2 ? .sessionExpired : .invalidResponse
        return ErrorUtils.error(code, message: message)
    }
}
