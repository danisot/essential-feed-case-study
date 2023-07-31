//
//  UIImageView+Animations.swift
//  EssentialFeediOS
//
//  Created by José Daniel Fernández Sotelo on 30/7/23.
//

import UIKit

extension UIImageView {
    func setImageAnimated(_ newImage: UIImage?) {
        image = newImage

        guard image != nil else { return }

        alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
}
