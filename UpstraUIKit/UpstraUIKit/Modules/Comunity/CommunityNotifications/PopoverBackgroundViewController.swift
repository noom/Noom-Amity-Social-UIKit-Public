//
// Created by Leke Abolade
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import SwiftUI

final class PopoverBackgroundViewController<Background: View>: PopoverPresentationDelegate {

    // Constants - Unable to use a Constants enum - [!] Static stored properties not supported in generic types
     /// Used to smooth the animation when device rotates
     private let rotationDelay: CGFloat = 0.3
     /// Used to prevent redundant layout updates.
     private var hasRepositioned: Bool = false
    // --

    private let background: (CGRect) -> Background
    private var backgroundHost: UIHostingController<Background>?

    init(background: @escaping (CGRect) -> Background) {
        self.background = background
    }

    func willPresentPopover(
        in containerView: UIView,
        sourceRect: CGRect,
        transitionCoordinator: UIViewControllerTransitionCoordinator?
    ) {
        let backgroundHost = UIHostingController(rootView: background(sourceRect))

        backgroundHost.view.backgroundColor = .clear
        backgroundHost.view.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(backgroundHost.view)
        containerView.sendSubviewToBack(backgroundHost.view)

        NSLayoutConstraint.activate([
            backgroundHost.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backgroundHost.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            backgroundHost.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            backgroundHost.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        if let transitionCoordinator = transitionCoordinator {
            backgroundHost.view.alpha = 0
            transitionCoordinator.animate { _ in backgroundHost.view.alpha = 1 }
        }

        self.backgroundHost = backgroundHost
    }

    func willHidePopover() {
        guard hasRepositioned else { return }
        // This helps smooth the animation during on device rotations
        animateBackgroundAlpha(to: 0, then: self.animateBackgroundAlpha(to: 1))
    }

    func willRepositionPopover(to sourceRect: CGRect) {
        hasRepositioned = true
        backgroundHost?.rootView = background(sourceRect)
    }

    func willDismissPopover(transitionCoordinator: UIViewControllerTransitionCoordinator?) {
        transitionCoordinator?.animate { _ in self.backgroundHost?.view.alpha = 0 }
    }

    private func animateBackgroundAlpha(to alpha: CGFloat, then completion: @escaping @autoclosure () -> Void = ()) {
        UIView.animate(withDuration: rotationDelay) {
            self.backgroundHost?.view.alpha = alpha
        } completion: { _ in
            completion()
        }
    }
}

// swiftlint:enable file_length
