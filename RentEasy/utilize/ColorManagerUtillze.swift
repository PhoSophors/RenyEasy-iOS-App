//
//  ColorManagerUtillze.swift
//  RentEasy
//
//  Created by Apple on 20/8/24.
//

import Foundation
import UIKit

class ColorManagerUtilize {
    
    // Singleton instance
    static let shared = ColorManagerUtilize()
    
    private init() { }
    
    // Define your custom colors with names and codes
    let forestGreen: UIColor = UIColor(hex: "#00995C") // Forest Green
    let darkGreenTeal: UIColor = UIColor(hex: "#006341") // Dark Green Teal
    let deepGreen: UIColor = UIColor(hex: "#00704a") // Deep Green
    let deepCharcoal: UIColor = UIColor(hex: "#27251F")// Deep Charcoal
    let darkGray: UIColor = UIColor(hex: "#A9A9A9") // Dark Gray
    let lightTeal: UIColor = UIColor(hex: "#D8E8E3") // Light Teal
    let veryLightTeal: UIColor = UIColor(hex: "#F1F8F6") // Very Light Teal
    let beige: UIColor = UIColor(hex: "#F2F0EB") // Beige
    let white: UIColor = UIColor(hex: "#FFFFFF") // White
    let black: UIColor = UIColor(hex: "#000000") // Black
    let lightGray: UIColor = UIColor(hex: "#F3F3F3") // Light Gray
}

// UIColor extension to initialize with hex color codes
extension UIColor {
    convenience init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        
        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
