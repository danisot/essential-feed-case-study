//
//  UITableView+Dequeueing.swift
//  EssentialFeediOS
//
//  Created by José Daniel Fernández Sotelo on 30/7/23.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
