import UIKit

public class FontBrand {
    
    class public func SFlightFont(size: CGFloat, isItalic: Bool = false) -> UIFont {
        UIFont(name: isItalic ? "SFUIText-LightItalic" : "SFUIText-Light", size: size)!
    }
    
    class public func SFregularFont(size: CGFloat, isItalic: Bool = false) -> UIFont {
        UIFont(name: isItalic ? "SFUIText-RegularItalic" : "SFUIText-Regular", size: size)!
    }
    
    class public func SFmediumFont(size: CGFloat, isItalic: Bool = false) -> UIFont {
        UIFont(name: isItalic ? "SFUIText-MediumItalic" : "SFUIText-Medium", size: size)!
    }
    
    class public func SFsemiboldFont(size: CGFloat, isItalic: Bool = false) -> UIFont {
        UIFont(name: isItalic ? "SFUIText-SemiboldItalic" : "SFUIText-Semibold", size: size)!
    }

    class public func SFboldFont(size: CGFloat, isItalic: Bool = false) -> UIFont {
        UIFont(name: isItalic ? "SFUIText-BoldItalic" : "SFUIText-Bold", size: size)!
    }
    
    class public func SFheavyFont(size: CGFloat, isItalic: Bool = false) -> UIFont {
        UIFont(name: isItalic ? "SFUIText-HeavyItalic" : "SFUIText-Heavy", size: size)!
    }
    
    class public func MulishBlackFont(size: CGFloat, isItalic: Bool = false) -> UIFont {
        UIFont(name: !isItalic ? "Inter-Black" : "Inter-Black", size: size)!
    }
    
    class public func MulishBoldFont(size: CGFloat, isItalic: Bool = false) -> UIFont {
        UIFont(name: !isItalic ? "Inter-Bold" : "Inter-Bold", size: size)!
    }
    
    class public func MulishExtraBoldFont(size: CGFloat, isItalic: Bool = false) -> UIFont {
        UIFont(name: !isItalic ? "Inter-ExtraBold" : "Inter-ExtraBold", size: size)!
    }
    
    class public func MulishExtraLightFont(size: CGFloat, isItalic: Bool = false) -> UIFont {
        UIFont(name: !isItalic ? "Inter-ExtraLight" : "Inter-ExtraLight", size: size)!
    }
    
    class public func MulishVariableFont(size: CGFloat, isItalic: Bool = false) -> UIFont {
        UIFont(name: !isItalic ? "Inter-VariableFont_wght" : "Inter-Black-VariableFont_wght", size: size)!
    }
    
    class public func MulishLightFont(size: CGFloat, isItalic: Bool = false) -> UIFont {
        UIFont(name: !isItalic ? "Inter-Light" : "Inter-LightItalic", size: size)!
    }
    
    class public func MulishMediumFont(size: CGFloat, isItalic: Bool = false) -> UIFont {
        UIFont(name: !isItalic ? "Inter-Medium" : "Inter-Medium", size: size)!
    }
    
//    class public func MulishFont(size: CGFloat, isItalic: Bool = false) -> UIFont {
//        UIFont(name: !isItalic ? "Inter-Regular" : "Inter-Regular", size: size)!
//    }
    
    class func MulishFont(size: CGFloat, isItalic: Bool = false) -> UIFont {
        let fontName = isItalic ? "Inter-Italic" : "Inter-Regular" // Correct the font name for italic case if needed
        if let font = UIFont(name: fontName, size: size) {
            return font
        } else {
            print("Failed to load the font: \(fontName). Using system font as fallback.")
            return UIFont.systemFont(ofSize: size)
        }
    }

    
    class public func MontserratFont(size: CGFloat, isItalic: Bool = false) -> UIFont {
        UIFont(name: !isItalic ? "Inter-SemiBold" : "Inter-SemiBold", size: size)!
    }
    
    class public func MontserratSemiBoldFont(size: CGFloat, isItalic: Bool = false) -> UIFont {
        UIFont(name: !isItalic ? "Inter-Bold" : "Inter-Bold", size: size)!
    }
    
    class public func MontserratThinFont(size: CGFloat, isItalic: Bool = false) -> UIFont {
        UIFont(name: !isItalic ? "Montserrat-Thin" : "Montserrat-ThinItalic", size: size)!
    }

    class public func MulishSemiBoldFont(size: CGFloat, isItalic: Bool = false) -> UIFont {
        let fontName = isItalic ? "Inter-SemiBoldItalic" : "Inter-SemiBold" // Adjust font name for italic if needed
        if let font = UIFont(name: fontName, size: size) {
            return font
        } else {
            print("Failed to load the font: \(fontName). Using system font as fallback.")
            return UIFont.systemFont(ofSize: size)
        }
    }
    
    class public func MulishThinFont(size: CGFloat, isItalic: Bool = false) -> UIFont {
        UIFont(name: !isItalic ? "Montserrat-Thin" : "Montserrat-ThinItalic", size: size)!
    }

//    class public func MulishSemiBoldFont(size: CGFloat, isItalic: Bool = false) -> UIFont {
//        UIFont(name: !isItalic ? "Mulish-SemiBold" : "Mulish-SemiBoldItalic", size: size)!
//    }

    // --------------------------------------
    // MARK: UINavigationBar
    // --------------------------------------
    
    class public var navBarTitleFont: UIFont {
        MulishBoldFont(size: 18.0)
    }

    class public var navBarSubtitleFont: UIFont {
        MulishSemiBoldFont(size: 12.0)
    }

    class public var largeNavBarTitleFont: UIFont {
        MulishBoldFont(size: 34.0)
    }
    
    // --------------------------------------
    // MARK: UITabBar
    // --------------------------------------
    
    class public var tabbarTitleFont: UIFont {
        MulishFont(size: 11.0)
    }

    class public var tabbarSelectedTitleFont: UIFont {
        MulishSemiBoldFont(size: 11)
    }
    
    // --------------------------------------
    // MARK: UIButton
    // --------------------------------------
    
    class public var buttonTitleFont: UIFont {
        MulishFont(size: 15.0)
    }
    
    // --------------------------------------
    // MARK: UILabel
    // --------------------------------------
    
    class public var labelFont: UIFont {
        MulishFont(size: 15.0)
    }
    
    class public var tableHeaderFont: UIFont {
        MulishSemiBoldFont(size: 20)
    }
}
