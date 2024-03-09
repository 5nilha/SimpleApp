//
//  ThemeManager.swift
//  SimpleApp
//
//  Created by Fabio Quintanilha on 3/8/24.
//

import UIKit

class ThemeManager {
    static let shared = ThemeManager()
    private init() {}

    var currentTheme: Theme = LightTheme() {
        didSet {
            applyTheme(theme: currentTheme)
        }
    }

    func applyTheme(theme: Theme) {
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().tintColor = theme.accentColor
    }

    func applyButtonTheme(button: UIButton, theme: ButtonTheme) {
        button.backgroundColor = theme.backgroundColor
        button.setTitleColor(theme.textColor, for: .normal)
        if let borderColor = theme.borderColor {
            button.layer.borderColor = borderColor.cgColor
        }
        button.layer.borderWidth = theme.borderWidth ?? 0
        button.layer.cornerRadius = theme.cornerRadius
    }
}
