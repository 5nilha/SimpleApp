//
//  Theme.swift
//  SimpleApp
//
//  Created by Fabio Quintanilha on 3/8/24.
//

import UIKit

protocol Theme {
    var primaryColor: UIColor { get }
    var secondaryColor: UIColor { get }
    var backgroundColor: UIColor { get }
    var accentColor: UIColor { get }
    var textTitleColor: UIColor { get }
    var textBodyColor: UIColor { get }
    var buttonTheme: ButtonTheme { get }
   
    // Fonts
    var titleFont: UIFont { get }
    var headLineFont: UIFont { get }
    var captionFont: UIFont { get }
}

struct ButtonTheme {
    var backgroundColor: UIColor
    var textColor: UIColor
    var borderColor: UIColor?
    var borderWidth: CGFloat?
    var cornerRadius: CGFloat
}

struct LightTheme: Theme {
    let primaryColor = ColorPalette.primary
    let secondaryColor = ColorPalette.white
    let backgroundColor = ColorPalette.white
    let accentColor = ColorPalette.accentColor
    let textTitleColor = ColorPalette.darkGray
    let textBodyColor = ColorPalette.gray
    let buttonTheme = ButtonTheme(
        backgroundColor: ColorPalette.primary,
        textColor: ColorPalette.white,
        borderColor: ColorPalette.primary,
        borderWidth: 1,
        cornerRadius: 5)
    
    var titleFont: UIFont {
        return UIFont.preferredFont(forTextStyle: .title2)
    }
    
    var headLineFont: UIFont {
        return UIFont.preferredFont(forTextStyle: .headline)
    }
    
    var captionFont: UIFont {
        return UIFont.preferredFont(forTextStyle: .footnote)
    }
}
