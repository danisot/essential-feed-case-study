//
//  UIControl+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by José Daniel Fernández Sotelo on 15/7/23.
//

import UIKit

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
