import Foundation
import ObjectMapper

class ContainerModel<T: Mappable>: BaseModel {

	var data: T?

	// --------------------------------------
	// MARK: <Mappable>
	// --------------------------------------

	required init?(map: Map) {
		super.init(map: map)
	}

	override func mapping(map: Map) {
		super.mapping(map: map)
        data <- map["data"]
	}

	// --------------------------------------
	// MARK: <ModelProtocol>
	// --------------------------------------

	override func isValid() -> Bool {
		return super.isValid() && data != nil
	}
}

class ContainerBidzPriceApiModel<T: Mappable>: Mappable, ModelProtocol {

    var data: T?

    required init?(map _: Map) {}

    func mapping(map: Map) {
        data <- map["data"]

    }

    // --------------------------------------
    // MARK: <ModelProtocol>
    // --------------------------------------

    func isValid() -> Bool {
        true
    }

    var status: String? {
        "ok"
    }
}


class ContainerIntModel: Mappable, ModelProtocol {

    var status:  Int = 0
    var messsage: String = kEmptyString

    // --------------------------------------
    // MARK: <Mappable>
    // --------------------------------------

    required init?(map _: Map) {}

    func mapping(map: Map) {
        status <- map["status"]
        messsage <- map["message"]
    }

    // --------------------------------------
    // MARK: <ModelProtocol>
    // --------------------------------------

    func isValid() -> Bool {
       status == 1
    }

    var statusMessage: String? {
        messsage
    }
}

class ContainerDemoApiModel<T: Mappable>: Mappable, ModelProtocol {

    var data: [T]?
    var status: String?
    var totalResults: Int?

    required init?(map _: Map) {}

    func mapping(map: Map) {
        data <- map["articals"]
        status <- map["status_message"]
        totalResults <- map["totalResults"]
    }

    // --------------------------------------
    // MARK: <ModelProtocol>
    // --------------------------------------

    func isValid() -> Bool {
        true
    }
}

class ContainerDemoModel<T: Mappable>: Mappable, ModelProtocol {
    var data: [T]?
    var page: Int?
    var total_pages: Int?
    var total_results: Int?

    required init?(map: Map) {}

    func mapping(map: Map) {
        data <- map["results"]
        page <- map["page"]
        total_pages <- map["total_pages"]
        total_results <- map["total_results"]
    }

    // Implement ModelProtocol
    func isValid() -> Bool {
        true
    }

    var status: String? {
        "ok"
    }
}


class ContainerSimilarMovieApiModel<T: Mappable>: Mappable, ModelProtocol {

    var results: [T]?
    var page: Int?
    var total_pages: Int?
    var total_results: Int?

    required init?(map _: Map) {}

    func mapping(map: Map) {
        results <- map["results"]
        page <- map["page"]
        total_pages <- map["total_pages"]
        total_results <- map["total_results"]
    }

    // --------------------------------------
    // MARK: <ModelProtocol>
    // --------------------------------------

    func isValid() -> Bool {
        true
    }
}

class ContainerCastApiModel<T: Mappable>: Mappable, ModelProtocol {

    var id: Int?
    var cast: [T]?
    var crew: [T]?

    required init?(map _: Map) {}

    func mapping(map: Map) {
        id <- map["id"]
        cast <- map["cast"]
        crew <- map["crew"]
    }

    // --------------------------------------
    // MARK: <ModelProtocol>
    // --------------------------------------

    func isValid() -> Bool {
        true
    }
}

class ContainerVideoApiModel<T: Mappable>: Mappable, ModelProtocol {

    var id: Int?
    var results: [T]?

    required init?(map _: Map) {}

    func mapping(map: Map) {
        id <- map["id"]
        results <- map["results"]
    }
    func isValid() -> Bool {
        true
    }
}

class ContainerImageApiModel<T: Mappable>: Mappable, ModelProtocol {

    var id: Int?
    var profiles: [T]?

    required init?(map _: Map) {}

    func mapping(map: Map) {
        id <- map["id"]
        profiles <- map["profiles"]
    }
    func isValid() -> Bool {
        true
    }
}

class ContainerActingApiModel<T: Mappable>: Mappable, ModelProtocol {

    var id: Int?
    var cast: [T]?
    var crew: [T]?

    required init?(map _: Map) {}

    func mapping(map: Map) {
        id <- map["id"]
        cast <- map["cast"]
        crew <- map["crew"]
    }
    func isValid() -> Bool {
        true
    }
}

class ContainerReviewApiModel<T: Mappable>: Mappable, ModelProtocol {

    var id: Int?
    var results: [T]?
    var page: Int?
    var total_pages: Int?
    var total_results: Int?

    required init?(map _: Map) {}

    func mapping(map: Map) {
        id <- map["id"]
        results <- map["results"]
        page <- map["page"]
        total_pages <- map["total_pages"]
        total_results <- map["total_results"]
    }

    // --------------------------------------
    // MARK: <ModelProtocol>
    // --------------------------------------

    func isValid() -> Bool {
        true
    }
}
