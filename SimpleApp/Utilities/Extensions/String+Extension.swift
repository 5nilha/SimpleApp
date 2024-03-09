//
//  String+Extension.swift
//  SimpleApp
//
//  Created by Fabio Quintanilha on 3/5/24.
//

import Foundation

extension String {
    
    var localized: String {
        guard let bundle = Utils.bundle else { return self }
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "Localizable")
    }
}
