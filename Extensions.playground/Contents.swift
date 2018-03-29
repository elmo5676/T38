//: Playground - noun: a place where people can play

import UIKit
import CoreLocation
// MARK: - Methods



public func lines() -> [String] {
    var result = [String]()
    enumerateLines { line, _ in
        result.append(line)
    }
    return result
}

public var firstCharacterAsString: String? {
    guard let first = self.first else { return nil }
    return String(first)
}

public var isDigits: Bool {
    return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
}

/// SwifterSwift: Check if string contains one or more instance of substring.
///
///        "Hello World!".contain("O") -> false
///        "Hello World!".contain("o", caseSensitive: false) -> true
///
/// - Parameters:
///   - string: substring to search for.
///   - caseSensitive: set true for case sensitive search (default is true).
/// - Returns: true if string contains one or more instance of substring.
public func contains(_ string: String, caseSensitive: Bool = true) -> Bool {
    if !caseSensitive {
        return range(of: string, options: .caseInsensitive) != nil
    }
    return range(of: string) != nil
}
/// SwifterSwift: Check if string ends with substring.
///
///        "Hello World!".ends(with: "!") -> true
///        "Hello World!".ends(with: "WoRld!", caseSensitive: false) -> true
///
/// - Parameters:
///   - suffix: substring to search if string ends with.
///   - caseSensitive: set true for case sensitive search (default is true).
/// - Returns: true if string ends with substring.
public func ends(with suffix: String, caseSensitive: Bool = true) -> Bool {
    if !caseSensitive {
        return lowercased().hasSuffix(suffix.lowercased())
    }
    return hasSuffix(suffix)
}

/// SwifterSwift: Check if string starts with substring.
///
///        "hello World".starts(with: "h") -> true
///        "hello World".starts(with: "H", caseSensitive: false) -> true
///
/// - Parameters:
///   - suffix: substring to search if string starts with.
///   - caseSensitive: set true for case sensitive search (default is true).
/// - Returns: true if string starts with substring.
public func starts(with prefix: String, caseSensitive: Bool = true) -> Bool {
    if !caseSensitive {
        return lowercased().hasPrefix(prefix.lowercased())
    }
    return hasPrefix(prefix)
}
}


public extension CLLocation {
    
    /// SwifterSwift: Calculate the half-way point along a great circle path between the two points.
    ///
    /// - Parameters:
    ///   - start: Start location.
    ///   - end: End location.
    /// - Returns: Location that represents the half-way point.
    public static func midLocation(start: CLLocation, end: CLLocation) -> CLLocation {
        let lat1 = Double.pi * start.coordinate.latitude / 180.0
        let long1 = Double.pi * start.coordinate.longitude / 180.0
        let lat2 = Double.pi * end.coordinate.latitude / 180.0
        let long2 = Double.pi * end.coordinate.longitude / 180.0
        
        // Formula
        //    Bx = cos φ2 ⋅ cos Δλ
        //    By = cos φ2 ⋅ sin Δλ
        //    φm = atan2( sin φ1 + sin φ2, √(cos φ1 + Bx)² + By² )
        //    λm = λ1 + atan2(By, cos(φ1)+Bx)
        // Source: http://www.movable-type.co.uk/scripts/latlong.html
        
        let bx = cos(lat2) * cos(long2 - long1)
        let by = cos(lat2) * sin(long2 - long1)
        let mlat = atan2(sin(lat1) + sin(lat2), sqrt((cos(lat1) + bx) * (cos(lat1) + bx) + (by * by)))
        let mlong = (long1) + atan2(by, cos(lat1) + bx)
        
        return CLLocation(latitude: (mlat * 180 / Double.pi), longitude: (mlong * 180 / Double.pi))
    }
    
    /// SwifterSwift: Calculate the half-way point along a great circle path between self and another points.
    ///
    /// - Parameter point: End location.
    /// - Returns: Location that represents the half-way point.
    public func midLocation(to point: CLLocation) -> CLLocation {
        return CLLocation.midLocation(start: self, end: point)
    }
    
    /// SwifterSwift: Calculates the bearing to another CLLocation.
    ///
    /// - Parameters:
    ///   - destination: Location to calculate bearing.
    /// - Returns: Calculated bearing degrees in the range 0° ... 360°
    public func bearing(to destination: CLLocation) -> Double {
        // http://stackoverflow.com/questions/3925942/cllocation-category-for-calculating-bearing-w-haversine-function
        let lat1 = Double.pi * coordinate.latitude / 180.0
        let long1 = Double.pi * coordinate.longitude / 180.0
        let lat2 = Double.pi * destination.coordinate.latitude / 180.0
        let long2 = Double.pi * destination.coordinate.longitude / 180.0
        
        //Formula: θ = atan2( sin Δλ ⋅ cos φ2 , cos φ1 ⋅ sin φ2 − sin φ1 ⋅ cos φ2 ⋅ cos Δλ )
        //Source: http://www.movable-type.co.uk/scripts/latlong.html
        
        let rads = atan2(sin(long2 - long1) * cos(lat2),
                         cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(long2 - long1))
        let degrees = rads * 180 / Double.pi
        
        return (degrees+360).truncatingRemainder(dividingBy: 360)
    }
    
}

public extension Optional {
    
    /// SwifterSwift: Get self of default value (if self is nil).
    ///
    ///        let foo: String? = nil
    ///        print(foo.unwrapped(or: "bar")) -> "bar"
    ///
    ///        let bar: String? = "bar"
    ///        print(bar.unwrapped(or: "foo")) -> "bar"
    ///
    /// - Parameter defaultValue: default value to return if self is nil.
    /// - Returns: self if not nil or default value if nil.
    public func unwrapped(or defaultValue: Wrapped) -> Wrapped {
        // http://www.russbishop.net/improving-optionals
        return self ?? defaultValue
    }
}

public extension UITabBar {
    
    /// SwifterSwift: Set tabBar colors.
    ///
    /// - Parameters:
    ///   - background: background color.
    ///   - selectedBackground: background color for selected tab.
    ///   - item: icon tint color for items.
    ///   - selectedItem: icon tint color for item.
    public func setColors(
        background: UIColor? = nil,
        selectedBackground: UIColor? = nil,
        item: UIColor? = nil,
        selectedItem: UIColor? = nil) {
        
        // background
        barTintColor = background ?? barTintColor
        
        // selectedItem
        tintColor = selectedItem ?? tintColor
        // shadowImage = UIImage()
        backgroundImage = UIImage()
        isTranslucent = false
        
        // selectedBackgoundColor
        guard let barItems = items else {
            return
        }
        
        if let selectedbg = selectedBackground {
            let rect = CGSize(width: frame.width/CGFloat(barItems.count), height: frame.height)
            selectionIndicatorImage = { (color: UIColor, size: CGSize) -> UIImage in
                UIGraphicsBeginImageContextWithOptions(size, false, 1)
                color.setFill()
                UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
                guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
                    return UIImage()
                }
                UIGraphicsEndImageContext()
                guard let aCgImage = image.cgImage else {
                    return UIImage()
                }
                return UIImage(cgImage: aCgImage)
            }(selectedbg, rect)
        }
        
        if let itemColor = item {
            for barItem in barItems as [UITabBarItem] {
                // item
                guard let image = barItem.image else {
                    continue
                }
                
                barItem.image = { (image: UIImage, color: UIColor) -> UIImage in
                    UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
                    color.setFill()
                    guard let context = UIGraphicsGetCurrentContext() else {
                        return image
                    }
                    
                    context.translateBy(x: 0, y: image.size.height)
                    context.scaleBy(x: 1.0, y: -1.0)
                    context.setBlendMode(CGBlendMode.normal)
                    
                    let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
                    guard let mask = image.cgImage else {
                        return image
                    }
                    context.clip(to: rect, mask: mask)
                    context.fill(rect)
                    
                    let newImage = UIGraphicsGetImageFromCurrentImageContext()!
                    UIGraphicsEndImageContext()
                    return newImage
                    }(image, itemColor).withRenderingMode(.alwaysOriginal)
                
                barItem.setTitleTextAttributes([.foregroundColor: itemColor], for: .normal)
                if let selected = selectedItem {
                    barItem.setTitleTextAttributes([.foregroundColor: selected], for: .selected)
                }
            }
        }
    }
    
}

public extension UITextField {
    /// SwifterSwift: Check if text field is empty.
    public var isEmpty: Bool {
        return text?.isEmpty == true
    }
    /// SwifterSwift: Return text with no spaces or new lines in beginning and end.
    public var trimmedText: String? {
        return text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    /// SwifterSwift: Check if textFields text is a valid email format.
    ///
    ///        textField.text = "john@doe.com"
    ///        textField.hasValidEmail -> true
    ///
    ///        textField.text = "swifterswift"
    ///        textField.hasValidEmail -> false
    ///
    public var hasValidEmail: Bool {
        // http://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
        return text!.range(of: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}",
                           options: String.CompareOptions.regularExpression,
                           range: nil, locale: nil) != nil
    }
    /// SwifterSwift: Clear text.
    public func clear() {
        text = ""
        attributedText = NSAttributedString(string: "")
    }
    /// SwifterSwift: Set placeholder text color.
    ///
    /// - Parameter color: placeholder text color.
    public func setPlaceHolderTextColor(_ color: UIColor) {
        guard let holder = placeholder, !holder.isEmpty else { return }
        self.attributedPlaceholder = NSAttributedString(string: holder, attributes: [.foregroundColor: color])
    }
}
