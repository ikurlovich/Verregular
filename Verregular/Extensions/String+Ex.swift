//
//  String+Ex.swift
//  Verregular
//
//  Created by Илья Курлович on 03.12.2023.
//

import Foundation


extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
