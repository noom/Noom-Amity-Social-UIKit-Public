//
// Created by Leke Abolade
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import UIKit

extension UIPopoverPresentationController {
    func adaptiveSourceFrame(insets: UIEdgeInsets) -> CGRect {
        if let sourceView = sourceView {
            return sourceView.frameInWindow().inset(by: insets)
        } else if let barButtonItem = barButtonItem {
            return barButtonItem.frameInWindow().inset(by: insets)
        } else {
            return .zero
        }
    }
}

extension UIView {

    /// Convert a view's frame to global coordinates.
    func frameInWindow() -> CGRect {
        return convert(bounds, to: nil)
    }
}

extension UIBarButtonItem {

    /// Convert a view's frame to global coordinates.
    func frameInWindow() -> CGRect {
        guard let view = value(forKey: "view") as? UIView else {
            return .zero
        }
        return view.frameInWindow()
    }
}

extension UIViewController {
    func addChildFittingSuperview(_ child: UIViewController) {
        addChildFittingSuperview(child, to: view)
    }

    func addChildFittingSuperview(_ child: UIViewController, to containerView: UIView) {
        addChild(child)
        containerView.addSubview(child.view)
        child.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            child.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            child.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            child.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            child.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        child.didMove(toParent: self)
    }
}

public extension DateFormatter {
    static let yyyymmdd: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY/MM/dd"
        return dateFormatter
    }()
}

public extension ISO8601DateFormatter {
    static let iso8601Full: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}
