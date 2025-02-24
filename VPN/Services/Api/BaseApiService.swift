import ObjectMapper
import PINCache
import SwiftyJSON
import Alamofire

public typealias ObjectResult<T: Mappable> = (T?, NSError?) -> Void
public typealias ObjectArrayResult<T: Mappable> = ([T]?, NSError?) -> Void
public typealias BooleanResult = (Bool, NSError?) -> Void
public typealias StringResult = (String?, NSError?) -> Void
public typealias JsonResult = (JSON?, NSError? ) -> Void
public typealias JsonAndObjectResult<T: Mappable> = ([String: Any]?, T?, NSError? ) -> Void
public typealias JsonArrayResult<T: Mappable> = ([[String: Any]]?, T?, NSError? ) -> Void

open class BaseApiService: NSObject {

    let _restClient = RestClient()

    // --------------------------------------
    // MARK: Class
    // --------------------------------------
    
    
    class var headers: [String: String] {
        [httpRequestHeaderNameAccept: httpRequestContentJson, httpRequestHeaderNameContentType: httpRequestContentJson]
    }

    class var customHeaders: [String: String] {
        [httpRequestHeaderNameAccept: httpRequestContentJson, httpRequestHeaderNameContentType: httpRequestContentJson]
    }
    class var customHeadersNonAuth: [String: String] {
        [httpRequestHeaderNameAccept: httpRequestContentJson, httpRequestHeaderNameContentType: httpRequestContentJson]
    }
    class var customHeadersForUploadFile: [String: String] {
        let boundary = Utils.generateBoundaryString()
        return [httpRequestHeaderNameAccept: httpRequestContentJson, httpRequestHeaderNameContentType: "multipart/form-data; boundary=\(boundary)"]
    }

    class func GET(_ url: String) -> RestRequest {
        RestRequest.build(url, method: httpRequestMethodGet, parameters: nil, customHeaders: headers)
    }

    class func GET(_ url: String, _ parameters: [String: Any]? = nil) -> RestRequest {
        RestRequest.build(url, method: httpRequestMethodGet, parameters: parameters, customHeaders: headers)
    }

    class func POST(_ url: String, parameters: [String: Any]? = nil) -> RestRequest {
        RestRequest.build(url, method: httpRequestMethodPost, parameters: parameters, customHeaders: headers)
    }

    class func POST_UPLOAD_FILE(_ url: String, parameters: [String: Any]? = nil) -> RestRequest {
        RestRequest.build(url, method: httpRequestMethodPost, parameters: parameters, customHeaders: customHeadersForUploadFile)
    }

    class func POST_FORM_DATA(_ url: String, parameters: [String: Any]? = nil) -> RestRequest {
        RestRequest.build(url, method: httpRequestMethodPost, parameters: parameters, customHeaders: customHeadersForUploadFile)
    }

    class func POST(_ url: String, arrayParameters: [[String: Any]]? = nil) -> RestRequest {
        RestRequest.build(url, method: httpRequestMethodPost, arrayParameters: arrayParameters, customHeaders: headers)
    }

    class func POST(_ url: String, _ parameters: [String: Any]? = nil, _ filePath: String?) -> RestRequest {
        RestRequest.build(url, filePath: filePath, method: httpRequestMethodPost, parameters: parameters, customHeaders: headers)
    }

    class func PUT(_ url: String, parameters: [String: Any]? = nil) -> RestRequest {
        RestRequest.build(url, method: httpRequestMethodPut, parameters: parameters, customHeaders: headers)
    }

    class func DELETE(_ url: String, parameters: [String: Any]? = nil) -> RestRequest {
        RestRequest.build(url, method: httpRequestMethodDelete, parameters: parameters, customHeaders: headers)
    }

    class func DELETE(_ url: String) -> RestRequest {
        RestRequest.build(url, method: httpRequestMethodDelete, parameters: nil, customHeaders: headers)
    }

    class func PATCH(_ url: String, parameters: [String: Any]? = nil) -> RestRequest {
        RestRequest.build(url, method: httpRequestMethodPatch, parameters: parameters, customHeaders: headers)
    }

    class func PATCH(_ url: String, _ filePath: String?) -> RestRequest {
        RestRequest.build(url, filePath: filePath, method: httpRequestMethodPatch, parameters: nil, customHeaders: customHeaders)
    }

    class func BUILDURL(_ url: String, params: [String]?) -> String {
        var resultUrl = url
        for param in params ?? [] {
            resultUrl += param
        }
        return resultUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }

    // --------------------------------------
    // MARK: Private
    // --------------------------------------
    private func _loadDataFromCache(_ request: RestRequest) -> RestResponse? {
        if PINCache.shared.containsObject(forKey: request.url) {
            Log.debug("CACHE RESPONSE load cached object for url=\(request.url!)")
            let cachedResult = PINCache.shared.object(forKey: request.url)
            return RestResponse.build(cachedResult, allHeaderFields: request.headers)
        }
        return nil
    }

    private func _saveDataToCache(_ request: RestRequest, _ response: RestResponse) {
        if response.isSuccess && response.result != nil {
            Log.debug("CACHE SAVE save object for url=\(request.url!)")
            DISPATCH_ASYNC_BG {
                PINCache.shared.setObject(response.result, forKey: request.url!)
            }
        }
    }

    private func _parse<T: Mappable>(response: RestResponse, model: T.Type) -> (Mappable?, NSError?) {

        // Check to see if response is success
        if !response.isSuccess {
            return (nil, ErrorUtils.error(response.headerStatusCode, message: response.statusMessage))
        }

        // Check to see if object is parsed and conform to protocols
        let object = Mapper<T>().map(JSONObject: response.result)
        if object == nil || !(object is ModelProtocol) {
            return (nil, ErrorUtils.error(ErrorCode.objectParsing))
        }

        // Check to see if model is valid
        let model = object as! ModelProtocol
        if !model.isValid() {
            if model.statusMessage != nil {
                return (nil, ErrorUtils.error(response.headerStatusCode, message: model.statusMessage!))
            }
            return (nil, ErrorUtils.error(ErrorCode.invalidObject))
        }

        // Return valid object
        return (object, nil)
    }

    // --------------------------------------
    // MARK: Public
    // --------------------------------------

    func requestToken<T: Mappable>(_ restRequest: RestRequest, model: T.Type, callback: ObjectResult<T>? = nil) {
        _restClient.invoke(restRequest, callback: RestCallback.callbackWithResult({ restResponse in
            let (object, error) = self._parse(response: restResponse, model: model)
            callback?(object as? T, error)
        }))
    }

    func request<T: Mappable>(_ restRequest: RestRequest, model: T.Type, shouldRefresh: Bool = true, shouldCache: Bool = true, callback: ObjectResult<T>? = nil) {

        // If the data is not refreshed, load from cache (if any)
        if !shouldRefresh {
            let cachedResponse = _loadDataFromCache(restRequest)
            if cachedResponse != nil {
                let (object, error) = _parse(response: cachedResponse!, model: model)
                if object != nil {
                    callback?(object as? T, error)
                }
            }
        }

        _restClient.invoke(restRequest, callback: RestCallback.callbackWithResult({ restResponse in
            let (object, error) = self._parse(response: restResponse, model: model)
            if object != nil && shouldCache {
                self._saveDataToCache(restRequest, restResponse)
            }
            callback?(object as? T, error)

        }))
    }

    func request(_ restRequest: RestRequest, callback: BooleanResult?) {
        _restClient.invoke(restRequest, callback: RestCallback.callbackWithResult({ response in
            guard response.headerStatusCode == httpStatusCodeUnauthorized else {
                if !response.isSuccess {
                    callback?(false, ErrorUtils.error(response.headerStatusCode, message: response.statusMessage))
                } else {
                    callback?(true, nil)
                }
                return
            }

        }))
    }

    func uploadRequest(_ restRequest: RestRequest, callback: BooleanResult?) {
        _restClient.uploadInvoke(restRequest, callback: RestCallback.callbackWithResult({ response in
            guard response.headerStatusCode == httpStatusCodeUnauthorized else {
                if !response.isSuccess {
                    callback?(false, ErrorUtils.error(response.headerStatusCode, message: response.statusMessage))
                } else {
                    callback?(true, nil)
                }
                return
            }

        }))
    }

    func multipartRequest<T: Mappable>(_ restRequest: RestRequest, model: T.Type, callback: ObjectResult<T>? = nil){
        _restClient.multipartInvoke(restRequest, callback: RestCallback.callbackWithResult({ restResponse in

            let (object, error) = self._parse(response: restResponse, model: model)
            if object != nil {
                self._saveDataToCache(restRequest, restResponse)
            }
            callback?(object as? T, error)


        }))
    }

    func genericRequest<T: Mappable>(_ restRequest: RestRequest, model: T.Type, shouldRefresh: Bool = true, shouldCache: Bool = true, callback: ObjectResult<T>? = nil) {

        // If the data is not refreshed, load from cache (if any)
        if !shouldRefresh {
            let cachedResponse = _loadDataFromCache(restRequest)
            if cachedResponse != nil {
                let (object, error) = _parse(response: cachedResponse!, model: model)
                if object != nil {
                    callback?(object as? T, error)
                }
            }
        }

        _restClient.genericInvoke(restRequest, callback: RestCallback.callbackWithResult({ restResponse in
            let (object, error) = self._parse(response: restResponse, model: model)
            if object != nil && shouldCache {
                self._saveDataToCache(restRequest, restResponse)
            }
            callback?(object as? T, error)

        }))
    }

    func genericJsonRequest(_ restRequest: RestRequest, shouldRefresh: Bool = true, shouldCache: Bool = true, callback: JsonResult? = nil) {

        // If the data is not refreshed, load from cache (if any)
        if !shouldRefresh {
            let cachedResponse = _loadDataFromCache(restRequest)
            if cachedResponse != nil {
                if cachedResponse?.result != nil {
                    callback?(JSON(cachedResponse?.result as Any), nil)
                }
            }
        }

        _restClient.genericInvoke(restRequest, callback: RestCallback.callbackWithResult({ restResponse in
            var error: NSError?
            if restResponse.statusMessage != nil {
                error = ErrorUtils.error(restResponse.headerStatusCode, message: restResponse.statusMessage!)
            }
            if restResponse.result != nil && shouldCache {
                self._saveDataToCache(restRequest, restResponse)
            }
            callback?(JSON(restResponse.result as Any), error)

        }))
    }

    func requestArrayInvoke<T: Mappable>(_ restRequest: RestRequest, model: T.Type, shouldRefresh: Bool = true, shouldCache: Bool = true, callback: ObjectResult<T>? = nil) {
        // If the data is not refreshed, load from cache (if any)
        if !shouldRefresh {
            let cachedResponse = _loadDataFromCache(restRequest)
            if cachedResponse != nil {
                let (object, error) = _parse(response: cachedResponse!, model: model)
                if object != nil {
                    callback?(object as? T, error)
                }
            }
        }

        _restClient.invokeArray(restRequest, callback: RestCallback.callbackWithResult { restResponse in
            let (object, error) = self._parse(response: restResponse, model: model)
            if object != nil && shouldCache {
                self._saveDataToCache(restRequest, restResponse)
            }
            callback?(object as? T, error)

        })
    }
}
