//
//  UIView+Ex.swift
//  Verregular
//
//  Created by Илья Курлович on 06.12.2023.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { view in
            addSubview(view)
        }
    }
}
