import UIKit

public class ColorBrand {
    
    static public let white = UIColor(named: "white")
    static public let black = UIColor(named: "black")!
    static public let clear = UIColor(named: "clear")
    static public let brandGray = UIColor(named: "brandGray")!
    static public let brandSubtitleColor = UIColor(named: "brandSubtitleColor")!
    static public let brandPurple = UIColor(hexString: "#40128B")
    static public let tabUnselect = UIColor(named: "tabUnselect")
    static public let redColor = UIColor(hexString: "#C70101")
    static public let greenColor = UIColor(hexString: "#00B955")
    static public let mainBlueColor = UIColor(hexString: "#1B1D4D")
    
    // --------------------------------------
    // MARK: UINavigationBar
    // --------------------------------------

    class public var navBarBackgroundColor: UIColor {
        clear!
    }

    class public var navBarTintColor: UIColor {
        white!
    }

    class public var navBarTextColor: UIColor {
        white!
    }
    
    // --------------------------------------
    // MARK: UITabBar
    // --------------------------------------

    class public var tabBarBackgroundColor: UIColor {
        white!
    }

    class public var tabBarTintColor: UIColor {
        white!
    }

    class public var tabBarUnselectedColor: UIColor {
        tabUnselect!
    }

    class public var tabBarSeltectedColor: UIColor {
        brandPurple
    }
}
