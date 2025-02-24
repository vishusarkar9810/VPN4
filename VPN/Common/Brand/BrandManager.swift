import UIKit

class BrandManager {

    // --------------------------------------
    // MARK: Private
    // --------------------------------------

    private class func _setDefaultNavBarTheme() {
        let appearance = UINavigationBar.appearance()
        appearance.setBackgroundImage(UIImage(), for: .default)
        appearance.shadowImage = nil
        appearance.isTranslucent = true
        appearance.barStyle = .default
        appearance.barTintColor = ColorBrand.navBarBackgroundColor
        appearance.tintColor = ColorBrand.navBarTintColor
        if #available(iOS 11.0, *) {
            appearance.prefersLargeTitles = false
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: ColorBrand.navBarTextColor,
                NSAttributedString.Key.font: FontBrand.navBarTitleFont
            ]
            navBarAppearance.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: ColorBrand.navBarTextColor,
                NSAttributedString.Key.font: FontBrand.largeNavBarTitleFont
            ]
            navBarAppearance.backgroundColor = ColorBrand.navBarBackgroundColor
            appearance.standardAppearance = navBarAppearance
            appearance.scrollEdgeAppearance = navBarAppearance
            navBarAppearance.shadowColor = .clear
        } else {
            if #available(iOS 11.0, *) {
                appearance.largeTitleTextAttributes = [
                    NSAttributedString.Key.foregroundColor: ColorBrand.navBarTextColor,
                    NSAttributedString.Key.font: FontBrand.largeNavBarTitleFont
                ]
            } else {
                // Fallback on earlier versions
            }
            if #available(iOS 11.0, *) {
                appearance.largeTitleTextAttributes = [
                    NSAttributedString.Key.foregroundColor: ColorBrand.navBarTextColor,
                    NSAttributedString.Key.font: FontBrand.largeNavBarTitleFont
                ]
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    private class func _setTabBarTheme() {
        let tabBarAppearance = UITabBar.appearance()
        let tabBarItemAppearance = UITabBarItem.appearance()
        tabBarAppearance.isTranslucent = false
        tabBarAppearance.tintColor = ColorBrand.clear
        tabBarAppearance.unselectedItemTintColor = ColorBrand.tabBarUnselectedColor
        tabBarAppearance.barTintColor = ColorBrand.clear
        tabBarAppearance.backgroundImage = UIImage(named: "tab_background")
        tabBarAppearance.backgroundColor = ColorBrand.clear
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundImage = UIImage(named: "tab_background")
            appearance.shadowColor = ColorBrand.clear
            appearance.stackedLayoutAppearance.normal.iconColor = ColorBrand.tabBarUnselectedColor
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: ColorBrand.tabBarUnselectedColor,
                NSAttributedString.Key.font: FontBrand.tabbarTitleFont
            ]
            appearance.stackedLayoutAppearance.selected.iconColor = ColorBrand.tabBarSeltectedColor
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: ColorBrand.tabBarSeltectedColor,
                NSAttributedString.Key.font: FontBrand.tabbarSelectedTitleFont
            ]
            tabBarAppearance.shadowColor = .clear
            tabBarAppearance.standardAppearance = appearance
            if #available(iOS 15.0, *) { tabBarAppearance.scrollEdgeAppearance = appearance }
        } else {
            tabBarItemAppearance.setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor: ColorBrand.tabBarUnselectedColor,
                NSAttributedString.Key.font: FontBrand.tabbarTitleFont
            ], for: .normal)
            tabBarItemAppearance.setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor: ColorBrand.tabBarSeltectedColor,
                NSAttributedString.Key.font: FontBrand.tabbarSelectedTitleFont
            ], for: .selected)
        }
    }
    
    // --------------------------------------
    // MARK: Public Class
    // --------------------------------------

    class func setDefaultTheme() {
        _setTabBarTheme()
    }
}
