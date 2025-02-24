import UIKit
import SDWebImage
import Alamofire

extension UIImageView {
    
//    private func _updateSkeletonLoading(isShow: Bool = true) {
//        guard isShow else {
//            if sk.isSkeletonActive { hideSkeleton(transition: .crossDissolve(0.5)) }
//            return
//        }
//        
//        if sk.isSkeletonActive { return }
//        self.isSkeletonable = true
//        let gradient = SkeletonGradient(baseColor: ColorBrand.brandGray)
//        self.showAnimatedGradientSkeleton(usingGradient: gradient, transition: .crossDissolve(0.5))
//    }
    
    private func _loadOriginalImage(url: URL, placeholder: UIImage?, callback: (() -> Void)? = nil) {
        if callback == nil {
            self.sd_setImage(with: url,placeholderImage: placeholder, options: .progressiveLoad)
        } else {
            self.sd_setImage(with: url, placeholderImage: placeholder, options: .progressiveLoad) { image, _, _, _ in
                //            self._updateSkeletonLoading(isShow: false)
                guard let image = image else {
                    self.image = placeholder
                    callback?()
                    return
                }
                self.image = image
                callback?()
            }
        }
    }
    
    func loadWebImage(_ url: String, placeholder: UIImage? = UIImage(named: "placeholder_image") , callback: (() -> Void)? = nil) {
        
        guard let url = URL(string: url) else {
            if placeholder != nil {
                image = placeholder
            }
            return
        }
        
        _loadOriginalImage(url: url, placeholder: placeholder, callback: callback)
    }
    
//    func downloadImageScaleImage(_ url: String?, placeHolder: String = "user_placeholder", name: String? = nil,callback: (() -> Void)? = nil) {
//        var placeHolderImage = UIImage(named: placeHolder)
//        if let name = name {
//            let ipimage = IPImage(text: name, radius: Double(self.layer.cornerRadius), font: FontBrand.MulishSemiBoldFont(size: 30), textColor: ColorBrand.white, backgroundColor: ColorBrand.brandCream.withAlphaComponent(0.70))
//            placeHolderImage = ipimage.generateImage() ?? UIImage(named: placeHolder)
//        }
//
//        guard let url = url, let encoded = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let imageURL = URL(string: encoded) else {
//            self.image = placeHolderImage
//            return
//        }
//        SDImageCache.shared.config.shouldUseWeakMemoryCache = true
//        if let image = SDImageCache.shared.imageFromCache(forKey: encoded) {
//            placeHolderImage = image
//        }
//        sd_setImage(with: imageURL, placeholderImage: placeHolderImage, options: .refreshCached, completed: nil)
//    }
//
//    func bucketImage(_ url: String? = nil, placeHolder: String = "user_placeholder", name: String?) {
//        var placeHolderImage = UIImage(named: placeHolder)
//        if let name = name {
//            let ipimage = IPImage(text: name, radius: Double(self.layer.cornerRadius), font: FontBrand.MulishSemiBoldFont(size: 35), textColor: ColorBrand.brandGray, backgroundColor: ColorBrand.white?.withAlphaComponent(0.70))
//            placeHolderImage = ipimage.generateImage() ?? UIImage(named: placeHolder)
//        }
//        guard let url = url, let encoded = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let imageURL = URL(string: encoded) else {
//            self.image = placeHolderImage
//            return
//        }
//        SDImageCache.shared.config.shouldUseWeakMemoryCache = true
//        if let image = SDImageCache.shared.imageFromCache(forKey: encoded) {
//            placeHolderImage = image
//        }
//        sd_setImage(with: imageURL, placeholderImage: placeHolderImage, options: .refreshCached, completed: nil)
//    }
    
    func setCornerRadius(forTopCorners radius: CGFloat) {
        self.layer.cornerRadius = radius // Adjust the value as needed
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        // Clip sublayers to the bounds of the imageView (optional)
        self.clipsToBounds = true
    }
}

extension UIImage {

    /// place the imageView inside a container view
    /// - parameter superView: the containerView that you want to place the Image inside
    /// - parameter width: width of imageView, if you opt to not give the value, it will take default value of 100
    /// - parameter height: height of imageView, if you opt to not give the value, it will take default value of 30
    func addToCenter(of superView: UIView, width: CGFloat = 60, height: CGFloat = 60) {
        let overlayImageView = UIImageView(image: self)

        overlayImageView.translatesAutoresizingMaskIntoConstraints = false
        overlayImageView.contentMode = .scaleAspectFit
        overlayImageView.layer.cornerRadius = 30
        overlayImageView.layer.borderColor = UIColor.white.cgColor
        overlayImageView.layer.borderWidth = 5
        superView.addSubview(overlayImageView)

        let centerXConst = NSLayoutConstraint(item: overlayImageView, attribute: .centerX, relatedBy: .equal, toItem: superView, attribute: .centerX, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: overlayImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width)
        let height = NSLayoutConstraint(item: overlayImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
        let centerYConst = NSLayoutConstraint(item: overlayImageView, attribute: .centerY, relatedBy: .equal, toItem: superView, attribute: .centerY, multiplier: 1, constant: 0)

        NSLayoutConstraint.activate([width, height, centerXConst, centerYConst])
    }
}
