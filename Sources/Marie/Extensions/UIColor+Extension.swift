//
//  UIColor+Extension.swift
//  Marie
//
//  Created by Gabriel Olbrisch on 15/04/23.
//

import UIKit

extension UIColor {
    
    static var backgroudColor = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return UIColor(hex: "#1a1a1a")
        default:
            return .init(named: "BackgroudColor") ?? .white
        }
    }
    
    static var primaryTextColor = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return UIColor.white
        default:
            return .init(named: "PrimaryTextColor") ?? .black
        }
    }
    
    static var secondaryTextColor = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return UIColor(hex: "#cccccc")
        default:
            return UIColor(hex: "#454545")
        }
    }
    
    static var JSONKeyColor: UIColor = {
        .init(named: "JSONKeyColor") ?? UIColor(hex: "#AAFF7E")
    }()
    
    static var JSONNumbersValueColor: UIColor = {
        .init(named: "JSONNumbersValueColor") ?? UIColor(hex: "#FFEC78")
    }()
    
    static var JSONOtherValuesColor: UIColor = {
        .init(named: "JSONOtherValuesColor") ?? UIColor(hex: "#FF5773")
    }()
    
    static var JSONStringValueColor: UIColor = {
        .init(named: "JSONStringValueColor") ?? UIColor(hex: "#FF9579")
    }()
    
    static var invertedPrimaryTextColor: UIColor = {
        .init(named: "InvertedPrimaryTextColor") ?? .white
    }()
    
    static var invertedSecondaryTextColor: UIColor = {
        .init(named: "InvertedSecondaryTextColor") ?? UIColor(hex: "#BEBEBE")
    }()
    
}

extension UIColor {
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        
        if hexString.count != 6 {
            self.init(red: 0, green: 0, blue: 0, alpha: alpha)
            return
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}
