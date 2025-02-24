import MediaPlayer
import ObjectMapper
import UIKit
import UserNotifications
//import MediaBrowser

class Utils: NSObject {

	// --------------------------------------
	// MARK: Notification
	// --------------------------------------

	class func dispatchNotification(title: String, body: String, identifier: String = UUID().uuidString, data: [String: Any] = [:]) {
		let content = UNMutableNotificationContent()

		content.title = title
		content.body = body
		content.sound = UNNotificationSound.default
		content.userInfo = data

		let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
		UNUserNotificationCenter.current().add(request) { error in
			if let error = error {
				print("Error \(error.localizedDescription)")
			}
		}
	}

	// --------------------------------------
	// MARK: Strings
	// --------------------------------------

	class func getBooleanString(_ value: Bool) -> String {
		return value ? "true" : "false"
	}

	class func formatFirstname(_ firstname: String, andLastName lastname: String) -> String {
		return "\(firstname) \(lastname)"
	}

	class func stringIsNullOrEmpty(_ string: String?) -> Bool {
		return (string == nil || string == kEmptyString || string == "NULL" || string == "null")
	}
    
//    class func isValidNumber(_ number: String, _ countryCode: String) -> Bool {
//        let phoneUtil = NBPhoneNumberUtil()
//        do {
//            let phoneNumber: NBPhoneNumber = try phoneUtil.parse(number, defaultRegion: countryCode == "UAE" ? "AE" : countryCode)
//            return phoneUtil.isValidNumber(phoneNumber)
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
//        return false
//    }

	class func formatNumber(_ number: Int) -> String {
		let formatter = NumberFormatter()
		formatter.numberStyle = NumberFormatter.Style.decimal
		formatter.groupingSeparator = ","
		if let formattedNumber = formatter.string(from: NSNumber(value: number)) {
			return "\(formattedNumber)"
		}
		return "0"
	}

	class func formatCurrency(_ amount: Float) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencySymbol = "$"

        if let formattedNumber = numberFormatter.string(from: NSNumber(value: amount)) {
            return formattedNumber
        }
		return "$0"
	}


	class func removeFileExtension(_ fileName: String?) -> String? {
		var components = fileName?.components(separatedBy: ".")
		if components?.count ?? 0 > 1 {
			components?.removeLast()
			return components?.joined(separator: ".")
		} else {
			return fileName
		}
	}
    
    // --------------------------------------
    // MARK: Message
    // --------------------------------------

    class func generateMessageId(_ userId: String) -> String {
        let timestamp = Date().timeIntervalSince1970
        let messageStr = "\(userId)_\(timestamp)"
        return messageStr
    }
    
	// --------------------------------------
	// MARK: Date
	// --------------------------------------

	class func localTimeZoneDate(timeZone: TimeZone = TimeZone.current) -> Date {
		return Date().addingTimeInterval(Double(timeZone.secondsFromGMT()))
	}
    
    class func toUtcDate(_ date: Date) -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: date))
        return Date(timeInterval: seconds, since: date)
    }
    
    class func dateOnly(_ date: Date?) -> Date? {
        let dateStr = dateToString(date, format: kFormatDateUS)
        let dateOnly = stringToDate(dateStr, format: kFormatDateUS)
        return dateOnly
    }
    
    public class func dateOnlyWithTimeZone(_ date: Date?) -> Date? {
            let dateStr = dateToStringWithTimezone(date, format: kFormatDateUS)
            let dateOnly = stringToDate(dateStr, format: kFormatDateUS)
            return dateOnly
        }
    
    class func timeOnly(_ date: Date?) -> String {
        guard let date = date else { return "" }

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = kFormatDateHourMinuteAM
        let dateOnly = timeFormatter.string(from: date)
        return dateOnly
    }

	class func dateToString(_ date: Date?, format: String) -> String {
		if date == nil {
			return kEmptyString
		}
		let dateFormatter = DATEFORMATTER.dateFormatterWith(format: format, locale: Locale.current)
		return dateFormatter.string(from: date!)
	}

	class func dateToStringWithTimezone(_ date: Date?, format: String) -> String {
		if date == nil {
			return kEmptyString
		}

		var convertedDate = date
		// UTC -> Local time
		let timeZoneOffset = TimeZone.current.secondsFromGMT()
		convertedDate?.addTimeInterval(TimeInterval(timeZoneOffset))

		let dateFormatter = DATEFORMATTER.dateFormatterWith(format: format, locale: Locale.current)
		return dateFormatter.string(from: convertedDate!)
	}

	class func dateToStringEST(_ date: Date?, format: String) -> String {
		if date == nil {
			return kEmptyString
		}

		var convertedDate = date

		// Offset EST -> Local time
		let timeZoneOffset = TimeZone.current.secondsFromGMT()
		convertedDate?.addTimeInterval(TimeInterval(timeZoneOffset + 5 * 3600))

		let dateFormatter = DATEFORMATTER.dateFormatterWith(format: format, locale: Locale.current)
		return dateFormatter.string(from: convertedDate!)
	}

	class func dateToStringUTC(_ date: Date?, format: String) -> String {
		if date == nil {
			return kEmptyString
		}

		var convertedDate = date

		let timeZoneOffset = TimeZone.current.secondsFromGMT()
		convertedDate?.addTimeInterval(TimeInterval(timeZoneOffset))

		let dateFormatter = DATEFORMATTER.dateFormatterWith(format: format, locale: Locale.current)
		return dateFormatter.string(from: convertedDate!)
	}

	class func stringToDate(_ string: String?, format: String) -> Date? {
		if Utils.stringIsNullOrEmpty(string) {
			return nil
		}
		let dateFormatter = DATEFORMATTER.dateFormatterWith(format: format, locale: Locale.current)
		return dateFormatter.date(from: string!)
	}
    
    class func stringToDateLocal(_ string: String?, format: String) -> Date? {
        if Utils.stringIsNullOrEmpty(string) {
            return nil
        }
        let dateFormatter = DATEFORMATTER.dateFormatterWith(format: format, locale: Locale.current)
        
        // Offset EST -> Local time
        let timeZoneOffset = TimeZone.current.secondsFromGMT()
        return dateFormatter.date(from: string!)?.addingTimeInterval(TimeInterval(timeZoneOffset + 5 * 3600))
    }
    
    class func currentDayOnly() -> String {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: today).lowercased()
    }
    
    class func currentTimeOnly() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let dateString = formatter.string(from: Date())
        return formatter.date(from: dateString)!
    }

    class func getDay(from dateString: String) -> String? {
        let dateFormatter = ISO8601DateFormatter()
        guard let date = stringToDate(dateString, format: kStanderdDate) else { return nil }//dateFormatter.date(from: dateString) else { return nil }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: date)

        if let day = components.weekday {
            let dayName = calendar.weekdaySymbols[day - 1]
            return dayName
        } else {
            return nil
        }
    }
        
	// --------------------------------------
	// MARK: Systems
	// --------------------------------------

	class func saveDictionaryToUserDefaults(_ dict: NSDictionary?) {
		let userDefaults: UserDefaults = UserDefaults.standard
		for key in dict?.allKeys ?? [] {
			userDefaults.set(dict![key], forKey: (key as? String)!)
		}
		userDefaults.synchronize()
	}

	class func saveObjectToUserDefaults(_ key: String, object: Any?) {
		let userDefaults: UserDefaults = UserDefaults.standard
		if object != nil {
			userDefaults.set(object, forKey: key)
		}
		userDefaults.synchronize()
	}

	class func removeObjectFromUserDefaults(_ key: String) {
		let userDefaults: UserDefaults = UserDefaults.standard
		userDefaults.removeObject(forKey: key)
		userDefaults.synchronize()
	}

	class func getObjectFromUserDefaults(_ key: String) -> Any? {
		let userDefaults: UserDefaults = UserDefaults.standard
		return userDefaults.object(forKey: key)
	}

	class func getLocalDirectory(_ folderName: String?) -> URL? {
		if stringIsNullOrEmpty(folderName) {
			return nil
		}
		let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
		let folderPath = (documentDirectory as NSString).appendingPathComponent(folderName!)
		if !FileManager.default.fileExists(atPath: folderPath) {
			Log.debug("Create new folder: \(folderPath)")
			do {
				try FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: nil)
			} catch {
				Log.debug("Error creating local directory: \(error.localizedDescription)")
				return nil
			}
		}
		return URL(string: folderPath)
	}

	class func fileSizeFromPath(path: String!) -> Int {
		if Utils.stringIsNullOrEmpty(path) {
			return 0
		} else {
			var fileSize: Int = 0
			do {
				let attr = try FileManager.default.attributesOfItem(atPath: path)
				fileSize = attr[FileAttributeKey.size] as? Int ?? 0
				// if you convert to NSDictionary, you can get file size old way as well.
				let dict = attr as NSDictionary
				fileSize = Int(dict.fileSize())
			} catch {
				print("Error: \(error)")
			}
			return fileSize
		}
	}

	class func saveFileToLocal(_ image: UIImage, fileName: String) {
		let data = image.jpegData(compressionQuality: 0.8) // UIImageJPEGRepresentation(image, 0.5)
		let filePath = getDocumentsDirectory().appendingPathComponent(fileName)
		try? data!.write(to: URL(fileURLWithPath: filePath), options: [.atomic])
	}
    
    class func saveFileToLocal(data: Data, fileName: String) {
        let filePath = getDocumentsDirectory().appendingPathComponent(fileName)
        try? data.write(to: URL(fileURLWithPath: filePath), options: [.atomic])
    }

	class func getDocumentsUrl() -> URL {
		let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
		return documentsURL
	}

	class func getDocumentsDirectory() -> NSString {
		let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
		let documentsDirectory = paths[0]
		return documentsDirectory as NSString
	}
    
    class func getAssetImageUrl(forImageNamed name: String) -> URL? {
        let fileManager = FileManager.default
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let url = cacheDirectory.appendingPathComponent("\(name).png")
        guard fileManager.fileExists(atPath: url.path) else {
            guard
                let image = UIImage(named: name),
                let data = image.pngData()
            else { return nil }

            fileManager.createFile(atPath: url.path, contents: data, attributes: nil)
            return url
        }

        return url
    }
    
    class func isFileExist(atPath filePath: String) -> Bool {
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: filePath)
    }

    
    class func getAssetImageUrlString(forImageNamed name: String) -> String? {
        return getAssetImageUrl(forImageNamed: name)?.absoluteString
    }
    
	// --------------------------------------
	// MARK: Validator
	// --------------------------------------

	class func validateEmail(_ candidate: String?) -> Bool {
		let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
		let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
		return predicate.evaluate(with: candidate)
	}

	class func validatePhoneNumber(_ candidate: String?) -> Bool {
		if candidate!.count < 10 { return false }
		let regex = "(\\+[0-9]+[\\- \\.]*)?(\\([0-9]+\\)[\\- \\.]*)?([0-9][0-9\\- \\.][0-9\\- \\.]+[0-9])"
		let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
		return predicate.evaluate(with: candidate)
	}

	class func validateUrl(_ url: URL?) -> Bool {
		if url != nil, url?.scheme != nil, url?.host != nil,
			url?.scheme == "http" || url?.scheme == "https" || url?.scheme == "ftp" || url?.scheme == "file" {
			return true
		} else {
			return false
		}
	}

	class func setVolumeStealthily(_ view: UIView, _ volume: Float) {

		let volumeView = MPVolumeView(frame: .zero)

		guard let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider else {
			assertionFailure("Unable to find the slider")
			return
		}

		volumeView.clipsToBounds = true
		view.addSubview(volumeView)

		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) { [weak slider, weak volumeView] in
			slider?.setValue(volume, animated: false)
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) { [weak volumeView] in
				volumeView?.removeFromSuperview()
			}
		}
	}
    
    class func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
//    class func webMediaPhoto(url: String, caption: String?) -> Media? {
//        guard let validUrl = URL(string: url) else {
//            return nil
//        }
//        var photo = Media()
//        if let _caption = caption {
//            photo = Media(url: validUrl, caption: _caption)
//        } else {
//            photo = Media(url: validUrl)
//        }
//        return photo
//    }
    
    class func getCountyFlag(code: String) -> String {
        
        return code
            .unicodeScalars
            .map({ 127397 + $0.value })
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }
    
    class func isEmail(emailString: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailString)
    }

//    class func checkDataType(text: String?)-> DataType {
//        if let intVal = text?.toInt() {
//            return DataType.Number
//        } else if isEmail(emailString: text ?? "") {
//           return DataType.Email
//        }
//    }
    
    // --------------------------------------
    // MARK: Story Viewed Check
    // --------------------------------------

    class func saveViewedStory(id: String) {
        var cellIds = UserDefaults.standard.array(forKey: "storyIds") as? [String] ?? []
        cellIds.append(id)
        UserDefaults.standard.set(cellIds, forKey: "storyIds")
    }
    
    class func getViewedStories() -> [String] {
        return UserDefaults.standard.array(forKey: "storyIds") as? [String] ?? []
    }
    
    class func discountPercent(originalPrice: Double, discountedPrice: Double) -> String {
        let discountPercent = ((originalPrice - discountedPrice) / originalPrice) * 100
        return "\(Int(discountPercent))"
    }
    
    class func calculateDiscountValue(originalPrice: Int?, discountPercentage: Int?) -> String {
        guard let discountPercentage = discountPercentage else {
            guard let originalPrice = originalPrice else { return "" }
            return String(originalPrice)
        }
        guard let originalPrice = originalPrice else { return "" }
        let discount = originalPrice * discountPercentage / 100
        let discountValue = Int(discount)
        let price = originalPrice - discountValue
        return String(price)
    }

    class func convertDictionaryToJSONString(_ dictionary: [String: Any]) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            print("Error converting dictionary to JSON string: \(error)")
        }
        return nil
    }

    class func convertJSONStringToDictionary(_ json: String) -> [String: Any]? {
        if let jsonData = json.data(using: .utf8) {
            do {
                if let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    return dictionary
                }
            } catch {
                print("Error converting JSON to dictionary: \(error)")
            }
        }
        return nil
    }

}
