//
//  Verb.swift
//  MVCLesson
//
//  Created by Илья Курлович on 27.11.2023.
//

import Foundation

struct Verb {
    let infinitive: String
    let pastSimple: String
    let participle: String
    var translate: String {
        NSLocalizedString(self.infinitive, comment: "")
    }
}
