//
//  UIStackView+Ex.swift
//  Verregular
//
//  Created by Илья Курлович on 06.12.2023.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { view in
            addArrangedSubview(view)
        }
    }
}
