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
