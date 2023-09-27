//
//  UIView+TestHelpers.swift
//  EssentialAppTests
//
//  Created by José Daniel Fernández Sotelo on 27/9/23.
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
