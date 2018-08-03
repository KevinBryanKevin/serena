//
//  Theme.swift
//  Serena
//
//  Created by Luis Perez on 8/2/18.
//  Copyright © 2018 Luis Perez. All rights reserved.
//

import UIKit

let SelectedThemeKey = "SelectedTheme"

enum Theme: String {
    case Default = "Default"
    case Dark = "Dark"
    case Graphical = "Graphical"
    
    var mainColor: UIColor {
        switch self {
        case .Default:
            return UIColor(red: 237.0/255.0, green: 92/255.0, blue: 92/255.0, alpha: 1.0)
        case .Dark:
            return UIColor(red: 242.0/255.0, green: 101.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        case .Graphical:
            return UIColor(red: 10.0/255.0, green: 10.0/255.0, blue: 10.0/255.0, alpha: 1.0)
        }
    }
    
    var barStyle: UIBarStyle {
        switch self {
        case .Default, .Graphical:
            return .default
        case .Dark:
            return .black
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .Default, .Graphical:
            return UIColor(white: 0.9, alpha: 1.0)
        case .Dark:
            return UIColor(white: 0.8, alpha: 1.0)
        }
    }
    
    var secondaryColor: UIColor {
        switch self {
        case .Default:
            return UIColor(red: 242.0/255.0, green: 101.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        case .Dark:
            return UIColor(red: 34.0/255.0, green: 128.0/255.0, blue: 66.0/255.0, alpha: 1.0)
        case .Graphical:
            return UIColor(red: 140.0/255.0, green: 50.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        }
    }
}

class ThemeManager {
    static func currentTheme() -> Theme {
        if let storedTheme = UserDefaults.standard.value(forKey: SelectedThemeKey) as? String {
            return Theme(rawValue: storedTheme)!
        } else {
            return .Default
        }
    }
    
    static func applyTheme(theme: Theme) {
        
        UserDefaults.standard.setValue(theme.rawValue, forKey: SelectedThemeKey)
        UserDefaults.standard.synchronize()
        
        UIApplication.shared.delegate?.window??.tintColor = theme.mainColor
        UINavigationBar.appearance().barStyle = theme.barStyle
        UITabBar.appearance().barStyle = theme.barStyle
    }
}
