//
//  ErrorView.swift
//  EssentialFeediOS
//
//  Created by José Daniel Fernández Sotelo on 31/7/23.
//

import UIKit

public final class ErrorView: UIButton {
    public var message: String? {
        get { isVisible ? configuration?.title : nil }
        set { setMessageAnimated(newValue) }
    }

    public var onHide: (() -> Void)?

    private var titleAttributes: AttributeContainer {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center

        var attributes = AttributeContainer()
        attributes.paragraphStyle = paragraphStyle
        attributes.font = UIFont.preferredFont(forTextStyle: .body)
        return attributes
    }

    private var isVisible: Bool {
        return alpha > 0
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func configure() {
        var configuration = Configuration.plain()
        configuration.titlePadding = 0
        configuration.baseForegroundColor = .white
        configuration.background.backgroundColor = .errorBackgroundColor
        configuration.background.cornerRadius = 0
        self.configuration = configuration

        addTarget(self, action: #selector(hideMessageAnimated), for: .touchUpInside)
        hideMessage()
    }

    private func setMessageAnimated(_ message: String?) {
        if let message {
            showAnimated(message)
        } else {
            hideMessageAnimated()
        }
    }

    private func showAnimated(_ message: String) {
        configuration?.attributedTitle = AttributedString(message, attributes: titleAttributes)

        configuration?.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }

    @objc
    private func hideMessageAnimated() {
        UIView.animate(
            withDuration: 0.25,
            animations: { self.alpha = 0 },
            completion: { completed in
                if completed { self.hideMessage() }
            })
    }

    private func hideMessage() {
        configuration?.attributedTitle = nil
        configuration?.contentInsets = .zero
        onHide?()
    }
}

extension UIColor {
    static var errorBackgroundColor: UIColor {
        UIColor(red: 0.99951404330000004, green: 0.41759261489999999, blue: 0.4154433012, alpha: 1)
    }
}
