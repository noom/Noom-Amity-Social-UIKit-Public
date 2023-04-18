//
// Created by Leke Abolade
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import SwiftUI

protocol PopoverPresentationDelegate: AnyObject {
    func willPresentPopover(
        in containerView: UIView,
        sourceRect: CGRect,
        transitionCoordinator: UIViewControllerTransitionCoordinator?
    )
    func willHidePopover()
    func willRepositionPopover(to sourceRect: CGRect)
    func willDismissPopover(transitionCoordinator: UIViewControllerTransitionCoordinator?)
}

final class PopoverContentViewController<
    Content: View,
    Background: View
>: UIHostingController<Content>, UIPopoverPresentationControllerDelegate {

    private let isPresented: Binding<Bool>
    private let attributes: PopoverAttributes
    private let backgroundController: PopoverBackgroundViewController<Background>

    weak var presentationDelegate: PopoverPresentationDelegate?

    init(
        rootView: Content,
        backgroundController: PopoverBackgroundViewController<Background>,
        isPresented: Binding<Bool>,
        attributes: PopoverAttributes
    ) {
        self.isPresented = isPresented
        self.attributes = attributes
        self.backgroundController = backgroundController

        super.init(rootView: rootView)
        presentationDelegate = backgroundController
    }

    @available(*, unavailable)
    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        presentationDelegate?.willHidePopover()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presentationDelegate?.willDismissPopover(transitionCoordinator: transitionCoordinator)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        attributes.onDismiss?()
    }

    // MARK: - UIPopoverPresentationControllerDelegate

    func adaptivePresentationStyle(
        for controller: UIPresentationController,
        traitCollection: UITraitCollection
    ) -> UIModalPresentationStyle {
        return .none
    }

    func popoverPresentationControllerShouldDismissPopover(
        _ popoverPresentationController: UIPopoverPresentationController
    ) -> Bool {
        attributes.onTapOutside?()
        return attributes.allowTapOutsideToDismiss
    }

    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        guard let containerView = popoverPresentationController.containerView else { return }

        let sourceRect = popoverPresentationController.adaptiveSourceFrame(insets: attributes.sourceRectInsets)
        presentationDelegate?.willPresentPopover(
            in: containerView,
            sourceRect: sourceRect,
            transitionCoordinator: popoverPresentationController.presentedViewController.transitionCoordinator
        )
    }

    func popoverPresentationController(
        _ popoverPresentationController: UIPopoverPresentationController,
        willRepositionPopoverTo rect: UnsafeMutablePointer<CGRect>,
        in view: AutoreleasingUnsafeMutablePointer<UIView>
    ) {
        let sourceRect = popoverPresentationController.adaptiveSourceFrame(insets: attributes.sourceRectInsets)
        presentationDelegate?.willRepositionPopover(to: sourceRect)
    }

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        isPresented.wrappedValue = false
    }
}
