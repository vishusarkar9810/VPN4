import Foundation
import AVFoundation
import UIKit

extension Date {
    
    func isBetween(_ date1: Date, and date2: Date, isDateOnly: Bool = true) -> Bool {
        var dateF = date1
        var dateL = date2
        if isDateOnly {
            dateF = Utils.dateOnly(date1) ?? date1
            dateL = Utils.dateOnly(date2) ?? date2
        }
        return (min(dateF, dateL) ... max(dateF, dateL)).contains(self)
    }
    
    var timeAgoSince: String {
        
        let calendar = Calendar.current
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: self, to: Date(), options: [])
        
        if let year = components.year, year >= 2 {
            return "\(year) years ago"
        }
        
        if let year = components.year, year >= 1 {
            return "Last year"
        }
        
        if let month = components.month, month >= 2 {
            return "\(month) months ago"
        }
        
        if let month = components.month, month >= 1 {
            return "Last month"
        }
        
        if let week = components.weekOfYear, week >= 2 {
            return "\(week) weeks ago"
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return "Last week"
        }
        
        if let day = components.day, day >= 2 {
            return "\(day) days ago"
        }
        
        if let day = components.day, day >= 1 {
            return "Yesterday"
        }
        
        if let hour = components.hour, hour >= 2 {
            return "\(hour) hours ago"
        }
        
        if let hour = components.hour, hour >= 1 {
            return "An hour ago"
        }
        
        if let minute = components.minute, minute >= 2 {
            return "\(minute) minutes ago"
        }
        
        if let minute = components.minute, minute >= 1 {
            return "A minute ago"
        }
        
        if let second = components.second, second >= 3 {
            return "\(second) seconds ago"
        }
        
        return "Just now"
        
    }
    
    func days(_ date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    
    func hours(_ date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }

    func minutes(_ date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    
    var remainTime: String {
        let components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date(), to: self)

        return "\(components.day ?? 0)d \(components.hour ?? 0)h \(components.minute ?? 0)m \(components.second ?? 0)s Left"
    }
    
    var currentUTCTimeZoneHour: String {
         let formatter = DateFormatter()
         formatter.timeZone = TimeZone(identifier: "UTC")
         formatter.amSymbol = "AM"
         formatter.pmSymbol = "PM"
         formatter.dateFormat = "HH"

         return formatter.string(from: self)
     }
    
    var currentUTCTimeZoneMinute: String {
         let formatter = DateFormatter()
         formatter.timeZone = TimeZone(identifier: "UTC")
         formatter.amSymbol = "AM"
         formatter.pmSymbol = "PM"
         formatter.dateFormat = "mm"

        return formatter.string(from: self)
     }
}


extension String {
    
    var trim: String {
        return trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
//    var isValidURL: Bool {
//        if let url = URL(string: self) {
//            return UIApplication.shared.canOpenURL(url)
//        }
//        return false
//    }
    
    var encode: String? {
        if let data = data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    var decode: String? {
        if let data = Data(base64Encoded: self) {
            return String(decoding: data, as: UTF8.self)
        }
        return nil
    }
    
    var toURL: URL? {
        return URL(string: self)
    }
    
    var numbersOnly: String {
        
        let numbers = self.replacingOccurrences(
            of: "[^0-9]",
            with: "",
            options: .regularExpression,
            range:nil)
        return numbers
    }
}

extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}

extension URL {
    
    var toString: String {
        return absoluteString
    }
    
    var lastPathName: String {
        return lastPathComponent
    }
    
    var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}


extension UIView {
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    var parentBaseController: BaseViewController? { parentViewController as? BaseViewController }
        
    func addBottomLine(_ color: UIColor, _ width: Double) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lineView)

        let metrics = ["width" : NSNumber(value: width)]
        let views = ["lineView" : lineView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
    }
    
    func addTopLine(_ color: UIColor, _ width: Double) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lineView)

        let metrics = ["width" : NSNumber(value: width)]
        let views = ["lineView" : lineView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
    }
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        layer.add(animation, forKey: nil)
    }
    
    func borders(for edges: [UIRectEdge], width: CGFloat = 1, color: UIColor = .black) {
        if edges.contains(.all) {
            layer.borderWidth = width
            layer.borderColor = color.cgColor
        } else {
            let allSpecificBorders: [UIRectEdge] = [.top, .bottom, .left, .right]

            for edge in allSpecificBorders {
                if let view = viewWithTag(Int(edge.rawValue)) {
                    view.removeFromSuperview()
                }

                if edges.contains(edge) {
                    let view = UIView()
                    view.tag = Int(edge.rawValue)
                    view.backgroundColor = color
                    view.translatesAutoresizingMaskIntoConstraints = false
                    addSubview(view)

                    var horizontalVisualFormat = "H:"
                    var verticalVisualFormat = "V:"

                    switch edge {
                        case UIRectEdge.bottom:
                            horizontalVisualFormat += "|-(0)-[v]-(0)-|"
                            verticalVisualFormat += "[v(\(width))]-(0)-|"
                        case UIRectEdge.top:
                            horizontalVisualFormat += "|-(0)-[v]-(0)-|"
                            verticalVisualFormat += "|-(0)-[v(\(width))]"
                        case UIRectEdge.left:
                            horizontalVisualFormat += "|-(0)-[v(\(width))]"
                            verticalVisualFormat += "|-(0)-[v]-(0)-|"
                        case UIRectEdge.right:
                            horizontalVisualFormat += "[v(\(width))]-(0)-|"
                            verticalVisualFormat += "|-(0)-[v]-(0)-|"
                        default:
                            break
                    }

                    addConstraints(NSLayoutConstraint.constraints(
                        withVisualFormat: horizontalVisualFormat,
                        options: .directionLeadingToTrailing,
                        metrics: nil,
                        views: ["v": view]))
                    addConstraints(NSLayoutConstraint.constraints(
                        withVisualFormat: verticalVisualFormat,
                        options: .directionLeadingToTrailing,
                        metrics: nil,
                        views: ["v": view]))
                }
            }
        }
    }
    
    func pinEdgesToSuperView() {
        guard let superView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        leftAnchor.constraint(equalTo: superView.leftAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        rightAnchor.constraint(equalTo: superView.rightAnchor).isActive = true
    }
    
   

}

extension Date {
    var toExpireDate: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        return dateFormatter.string(from: self)
    }
}

extension Notification.Name {
    static let changeReachability = Notification.Name("changeReachabilityNotification")
    static let updateNotificationBadge = Notification.Name("updateNotificationBadge")
    static let updateWhoIsInBadge = Notification.Name("updateWhoIsInBadge")
    static let updateLocationState = Notification.Name("updateLocationStatu")
    static let changeSubscriptionState = Notification.Name("changeSubscriptionState")
}

//extension AVPlayer {
//    func addProgressObserver(action:@escaping ((Double) -> Void)) -> Any {
//        return self.addPeriodicTimeObserver(forInterval: CMTime.init(value: 1, timescale: 1), queue: .main, using: { time in
//            if let duration = self.currentItem?.duration {
//                let duration = CMTimeGetSeconds(duration), time = CMTimeGetSeconds(time)
//                let progress = (time/duration)
//                action(progress)
//            }
//        })
//    }
// 

extension Double {

    func roundTo(_ places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
