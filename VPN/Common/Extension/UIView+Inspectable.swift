import Foundation
import UIKit
import SDWebImage


extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var shadowColor: UIColor {
        get {
            return UIColor(cgColor: layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var masksToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    func addTopBorder(to view: UIView, with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: borderWidth)

        if let visualEffectView = view as? UIVisualEffectView {
            visualEffectView.contentView.addSubview(border)
        } else {
            view.addSubview(border)
        }
    }
    
    func fadeIn(duration: TimeInterval = 0.4, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.isHidden = false
        }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 0.4, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.isHidden = true
        }, completion: completion)
    }
    
    func removeGradientBorders() {
       if let sublayers = self.layer.sublayers {
           for sublayer in sublayers {
               if sublayer is CAGradientLayer {
                   sublayer.removeFromSuperlayer()
               }
           }
       }
   }
    
    func addRoundedRectGradientStrokeAnimation(strokeWidth: CGFloat, duration: CFTimeInterval) {
        layer.sublayers?.removeAll(where: {$0.name == "gradientLayer"})
        
        let gradient = CAGradientLayer()
        gradient.name = "gradientLayer"
        gradient.frame = self.bounds
        gradient.colors = [ColorBrand.brandSubtitleColor.cgColor,
                           ColorBrand.brandSubtitleColor.cgColor,
                           ColorBrand.brandGray.cgColor,
                           ColorBrand.brandSubtitleColor.cgColor,
                           ColorBrand.brandSubtitleColor.cgColor,
                           ColorBrand.brandGray.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        let strokeLayer = CAShapeLayer()
        strokeLayer.fillColor = UIColor.clear.cgColor
        strokeLayer.strokeColor = UIColor.black.cgColor
        strokeLayer.lineWidth = strokeWidth
        strokeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: frame.width / 2.0).cgPath
        
        gradient.mask = strokeLayer
        self.layer.addSublayer(gradient)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = CGFloat(0.0)
        animation.toValue = CGFloat(1.0)
        animation.duration = duration
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        strokeLayer.add(animation, forKey: "strokeAnimation")
    }
    
    func addGradientBorderWithColor(cornerRadius: CGFloat, _ borderWidth: CGFloat, _ colors: [CGColor]) {
        layer.sublayers?.removeAll(where: {$0.name == "gradientBorderColorLayer"})
        
        clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "gradientBorderColorLayer"
        gradientLayer.frame =  CGRect(origin: .zero, size: bounds.size)
        gradientLayer.startPoint = CGPoint(x: .zero, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.colors = colors
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = borderWidth
        shapeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.black.cgColor
        gradientLayer.mask = shapeLayer
        
        layer.addSublayer(gradientLayer)
    }
    
    func addGradientBorder(cornerRadius: CGFloat, _ borderWidth: CGFloat, _ isGrayBorder: Bool) {
        layer.sublayers?.removeAll(where: {$0.name == "gradientBorderLayer"})
        
        clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "gradientBorderLayer"
        gradientLayer.frame =  CGRect(origin: .zero, size: bounds.size)
        gradientLayer.startPoint = CGPoint(x: .zero, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        if isGrayBorder{
            gradientLayer.colors = [ColorBrand.brandGray.cgColor, ColorBrand.brandGray.cgColor]
        }else {
            gradientLayer.colors = [ColorBrand.brandSubtitleColor.cgColor,
                                    ColorBrand.brandSubtitleColor.cgColor,
                                    ColorBrand.brandGray.cgColor,
                                    ColorBrand.brandSubtitleColor.cgColor,
                                    ColorBrand.brandSubtitleColor.cgColor,
                                    ColorBrand.brandGray.cgColor]
        }
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = borderWidth
        shapeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.black.cgColor
        gradientLayer.mask = shapeLayer
        
        layer.addSublayer(gradientLayer)
    }
    
    func setGradientViewBackground(_ topColor: UIColor, _ bottomColor: UIColor) {
        layer.sublayers?.removeAll(where: {$0.name == "gradientBackgroundLayer"})
        
        let colorTop =  topColor.cgColor
        let colorBottom = bottomColor.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "gradientBackgroundLayer"
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
        gradientLayer.masksToBounds = true
        gradientLayer.cornerRadius = 10
        self.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func superview<T>(of type: T.Type) -> T? {
        return superview as? T ?? superview.map { $0.superview(of: type)! }
    }
    
    func touchStartedAnimation(touched: Bool) {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
            options: .allowUserInteraction,
            animations: {
                if touched {
                    self.layer.shadowRadius = 8
                    self.transform = CGAffineTransform.identity.scaledBy(x: 0.93, y: 0.93)
                } else {
                    self.layer.shadowRadius = 16
                    self.transform = .identity
                }
            }
        )
    }

    func snapshot() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        return renderer.image { context in
            layer.render(in: context.cgContext)
        }
    }
}

public extension String {
    static func format(decimal:Float, _ maximumDigits:Int = 1, _ minimumDigits:Int = 1) ->String? {
        let number = NSNumber(value: decimal)
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = maximumDigits
        numberFormatter.minimumFractionDigits = minimumDigits
        return numberFormatter.string(from: number)
    }
}

public extension URL {
    /// Adds the scheme prefix to a copy of the receiver.
    func convertToRedirectURL(scheme: String) -> URL? {
        var components = URLComponents.init(url: self, resolvingAgainstBaseURL: false)
        let schemeCopy = components?.scheme ?? ""
        components?.scheme = schemeCopy + scheme
        return components?.url
    }
}

//extension UIColor {
//    @available(iOS 13.0, *)
//    static var border = UIColor {
//        if #available(iOS 12.0, *) {
//            $0.userInterfaceStyle == .dark ? .black : .white
//        } else {
//            // Fallback on earlier versions
//        }
//    }
//}

extension CALayer {
    /// function to add animation to layer without key
    func add<A: CAAnimation>(animation: A, forKey: String? = nil) {
        self.add(animation, forKey: forKey)
    }
}

extension UILabel {
    
    func setFontWieght(_ text: String, _ lineSpace: CGFloat) {
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineSpace
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
    }
    
}
extension Double {
    func getDateStringFromUTC() -> String {
        let date = Date(timeIntervalSince1970: self/1000)
        let dateFormatter = DateFormatter(withFormat: kFormatDateHourMinuteAM, locale: Locale.current.identifier)
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
         return localDate
     }
}
