import UIKit

public class Graphics : NSObject {

	// --------------------------------------
	// MARK: Views
	// --------------------------------------

    public class func dropShadow(_ view: UIView, opacity: CGFloat, radius: CGFloat, offset: CGSize) {
		dropShadow(view, color: UIColor.black, opacity: opacity, radius: radius, offset: offset)
	}

    public class func dropShadow(_ view: UIView, color: UIColor?, opacity: CGFloat, radius: CGFloat, offset: CGSize) {
		view.layer.masksToBounds = false
		view.layer.rasterizationScale = UIScreen.main.scale
		view.layer.shouldRasterize = true
		view.layer.shadowColor = color?.cgColor
		view.layer.shadowOffset = offset
		view.layer.shadowRadius = radius
		view.layer.shadowOpacity = Float(opacity)
	}
    
    public class func bottomSheetShadow(_ view: UIView) {
        view.layer.masksToBounds = false
        
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.layer.cornerRadius).cgPath
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = CGFloat.init(10)
        view.layer.shadowOffset = CGSize.init(width: 0.0, height: 4.0)
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = 0.0
        animation.toValue = 0.5
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.duration = 0.3
        view.layer.add(animation, forKey: "fadeout")
    }

   
    public class func showActionSheet(_ at: UIViewController, title:String?, message:String? = nil, options:[String], handler: @escaping(_ item: String) -> Void){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        options.forEach { title in
            let action = UIAlertAction(title: title, style: UIAlertAction.Style.default) { _ in
                handler(title)
            }
            alertController.addAction(action)
        }
        let cancelAction = UIAlertAction(title: LOCALIZED("dismiss"), style: UIAlertAction.Style.cancel) { _ in}
        alertController.addAction(cancelAction)
        at.present(alertController, animated: true, completion: nil)
    }

    

	// --------------------------------------
	// MARK: Buttons
	// --------------------------------------
    
    public class func createBackButton() -> UIButton {
        let backButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: kBarButtonDefaultWidth, height: kBarButtonDefaultHeight))
        backButton.setImage(UIImage(named: "icon-action-back"), for: .normal)
        return backButton
    }
    
    public class func createBarButton(image: String) -> UIButton {
        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        button.setImage(UIImage(named: image), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = ColorBrand.white
        return button
    }

    public class func createBarButton(_ title: String?) -> UIButton {
		let size = title?.size(withAttributes: [NSAttributedString.Key.font: FontBrand.buttonTitleFont])
		let button = UIButton.init(type: .system)
		button.frame = CGRect.init(x: 0, y: 0, width: size?.width ?? 0, height: size?.height ?? 0)
		button.setTitle(title, for: .normal)
		button.setTitle(title, for: .highlighted)
		button.setTitle(title, for: .selected)
		button.titleLabel?.font = FontBrand.buttonTitleFont
		return button
	}
    
    public class func createActivityBarButton() -> UIButton {
        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: kBarButtonDefaultWidth, height: kBarButtonDefaultWidth))
        let activity = UIActivityIndicatorView(style: .white)
        let halfButtonHeight = button.bounds.size.height/2
        let buttonWidth = button.bounds.width
        activity.center = CGPoint(x: buttonWidth - halfButtonHeight, y: halfButtonHeight)
        button.addSubview(activity)
        activity.startAnimating()
        return button
    }

	// --------------------------------------
	// MARK: Colors
	// --------------------------------------


	// --------------------------------------
	// MARK: Texts
	// --------------------------------------

    public class func calculateMaxLines(text: String, width: CGFloat, font: UIFont!) -> Int {
		let maxSize = CGSize(width: width, height: CGFloat(Float.infinity))
		let charSize = font.lineHeight
		let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font!], context: nil)
		let linesRoundedUp = Int(ceil(textSize.height/charSize))
		return linesRoundedUp
	}

//    public class func setZoomImage(imageview: UIImageView) {
//		let imageName = "icon-lightbox"
//		let image = UIImage(named: imageName)
//		let lightBoxImage = UIImageView(image: image!)
//		lightBoxImage.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
//		imageview.addSubview(lightBoxImage)
//
//		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:)))
//		imageview.addGestureRecognizer(tapGesture)
//		imageview.isUserInteractionEnabled = true
//
//	}
//
//	@objc public static func imageTapped(gesture: UIGestureRecognizer) {
//		if (gesture.view as? UIImageView) != nil {
//			let imageview = (gesture.view as? UIImageView)!
//            guard let window = UIApplication.shared.delegate?.window else { return }
//            guard let presentingController = window?.rootViewController else { return }
//            ImageViewer.show(imageview, presentingVC: presentingController)
//		}
//	}
    
    // --------------------------------------
    // MARK: Images
    // --------------------------------------
    
    public class func imageWithColor(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}
