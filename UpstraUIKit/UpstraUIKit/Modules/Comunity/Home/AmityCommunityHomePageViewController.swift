//
//  AmityCommunityHomePageViewController.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 18/8/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import SwiftUI

public class AmityCommunityHomePageViewController: AmityPageViewController, AmityRootViewController {

    public var exitClosure: (() -> Void)? = nil
    // MARK: - Properties
    public let newsFeedVC = AmityNewsfeedViewController.make()
    public let exploreVC = AmityCommunityExplorerViewController.make()
    public let myCommunitiesVC = AmityMyCommunityViewController.make()
    private var notificationsItem: UIBarButtonItem?

    private init() {
        super.init(nibName: AmityCommunityHomePageViewController.identifier, bundle: AmityUIKitManager.bundle)
        title = AmityLocalizedStringSet.communityHomeTitle.localizedString
        AmityUIKitManager.setRootViewController(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AmityUIKitManager.setRoutingEnabled(true)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }

    public override func willMove(toParent parent: UIViewController?) {
        AmityUIKitManager.setRoutingEnabled(false)
        if parent == nil {
            exitClosure?()
        }
        super.willMove(toParent: parent)
    }

    public static func make(
        analytics: AmityAnalytics,
        initialRouting: AmityRoute = .none,
        exitClosure: (@escaping () -> Void) = {}
    ) -> AmityCommunityHomePageViewController {
        AmityUIKitManager.set(analyticsClient: analytics)
        let viewController = AmityCommunityHomePageViewController()
        viewController.exitClosure = exitClosure
        AmityUIKitManager.route(to: initialRouting)
        return viewController
    }
    
    override func viewControllers(for pagerTabStripController: AmityPagerTabViewController) -> [UIViewController] {
        newsFeedVC.pageTitle = AmityLocalizedStringSet.newsfeedTitle.localizedString
        exploreVC.pageTitle = AmityLocalizedStringSet.exploreTitle.localizedString
        myCommunitiesVC.pageTitle = AmityLocalizedStringSet.Home.homeMe.localizedString
        return [newsFeedVC, exploreVC, myCommunitiesVC]
    }
    
    // MARK: - Setup view
    
    private func setupNavigationBar() {
        let searchItem = UIBarButtonItem(image: AmityIconSet.iconSearch, style: .plain, target: self, action: #selector(searchTap))
        searchItem.tintColor = AmityColorSet.base
        searchItem.accessibilityIdentifier = "home_search_button"
        let notificationsItem = UIBarButtonItem(
            image: UIImage(systemName: "bell.fill"),
            style: .plain,
            target: self,
            action: #selector(notificationsTapped)
        )
        notificationsItem.tintColor = AmityColorSet.base
        notificationsItem.accessibilityIdentifier = "notifications_button"
        self.notificationsItem = notificationsItem
        navigationItem.rightBarButtonItems = [searchItem, notificationsItem]
        let closeItem = UIBarButtonItem(
            image: AmityIconSet.iconClose,
            style: .plain,
            target: self,
            action: #selector(closeTapped)
        )
        closeItem.accessibilityIdentifier = "home_close_button"
        navigationItem.leftBarButtonItem = closeItem
    }
}

// MARK: - Action
private extension AmityCommunityHomePageViewController {
    @objc func searchTap() {
        let searchVC = AmitySearchViewController.make()
        let nav = UINavigationController(rootViewController: searchVC)
        nav.modalPresentationStyle = .fullScreen
        nav.modalTransitionStyle = .crossDissolve
        present(nav, animated: true, completion: nil)
    }

    @objc func closeTapped() {
        navigationController?.popViewController(animated: true)
        AmityUIKitManager.track(event: .userClosedAmity)
        // Unset analytics to prevent dangling references.
        AmityUIKitManager.set(analyticsClient: nil)
    }
    
    @objc func notificationsTapped() {
        // Make view in swift UI.
        // call API
        let notificationsVC = CommunityNotificationsViewController()
        let nav = UINavigationController(rootViewController: notificationsVC)
        guard let notificationsItem = notificationsItem else { return }
        presentNavbarTooltip(anchorItem: notificationsItem, title: "Notifications", description: "list of notifications")
    }
}

public extension AmityCommunityHomePageViewController {
    func canShowExplore() -> Bool {
        return true
    }

    func showExplore() {
        moveTo(viewController: exploreVC)
    }
}


final class CommunityNotificationsViewController: UIHostingController<NotificaitonsTrayList> {
    init() {
        super.init(rootView: NotificaitonsTrayList())
        rootView.dismiss = dismiss
      }
      @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
      }
    
      func dismiss() {
        let transition = CATransition()
        transition.duration = 0.5
          transition.type = CATransitionType.push
          transition.subtype = CATransitionSubtype.fromBottom
        view.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension UIViewController {
    /// Presents a tooltip with a close action.
    /// - Parameters:
    ///   - theme: Used to theme the tooltip and the background overlay.
    ///   - anchorItem: The BarButtonItem from which the popover will anchor itself. The arrow of the popover will touch the view at any of the permitted arrow direction points.
    ///   - title: An optional title for the tooltip. If nil, the tooltips height will adjust by removing this element.
    ///   - description: Used to describe the anchor view.
    ///   - popoverAttributes: Popover attributes are used to customise the popover's properties.
    ///   - onDidClose: This block is triggered after the tooltip is dismissed by the user.
    public func presentNavbarTooltip(
        anchorItem: UIBarButtonItem,
        title: String = "",
        description: String,
        popoverAttributes: PopoverAttributes = .init(),
        onDidClose: @escaping () -> Void = {}
    ) {
        presentPopover(
            anchorItem: anchorItem,
            attributes: popoverAttributes,
            content: {
                DismissableTooltipView(
                    title: title,
                    description: description,
                    closeAction: { [weak self] in
                        self?.presentedViewController?.dismiss(animated: true, completion: onDidClose)
                    }
                )
            },
            background: { sourceRect in
                TooltipBackground()
            }
        )
    }
    
    /// Presents a popover with a background.
    /// - Parameters:
    ///   - theme: The theme is used to decode the popover color from the attributes and passes it the content and background's environtment.
    ///   - anchorItem: The BarButtonItem from which the popover will anchor itself. The arrow of the popover will touch the view at any of the permitted arrow direction points.
    ///   - attributes: Attributes are used to customise the popover's properties.
    ///   - content: The content of the popover that will be presented.
    ///   - background: The background will be placed between the anchor view and the popover. Has access to the full `UIScreen.bounds`
    public func presentPopover<Content: View, Background: View>(
        anchorItem: UIBarButtonItem,
        attributes: PopoverAttributes = .init(),
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder background: @escaping (CGRect) -> Background
    ) {
        guard
            let controller = makePopoverController(
                attributes: attributes,
                content: content,
                background: background
            ),
            let popover = controller.popoverPresentationController
        else { return }
        popover.barButtonItem = anchorItem
    //    if attributes.sourceRectInsets != .zero {
    //        popover.sourceRect = anchorItem.noom.frameInWindow().inset(by: attributes.sourceRectInsets)
    //    }
        present(controller, animated: true, completion: nil)
    }

    
}




// MARK: - Common logic

fileprivate extension UIViewController {

    func makePopoverController<Content: View, Background: View>(
        attributes: PopoverAttributes = .init(),
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder background: @escaping (CGRect) -> Background
    ) -> UIViewController? {
        let contentController = PopoverContentViewController(
            rootView: content(),
            backgroundController: PopoverBackgroundViewController(background: { sourceRect in
                background(sourceRect)
            }),
            isPresented: .constant(false),
            attributes: attributes
        )

        let compressedController = CompressedSizeController(contentViewController: contentController)
        compressedController.modalPresentationStyle = .popover

        guard let popover = compressedController.popoverPresentationController else { return nil }
        popover.delegate = contentController
        popover.permittedArrowDirections = attributes.popoverPermittedArrowDirection
        popover.popoverLayoutMargins = attributes.popoverLayoutMargins

        return compressedController
    }
}


/// Sets the `preferredContentSize` to `UIView.layoutFittingCompressedSize`,
/// allowing the childViewController to control the size presented.
open class CompressedSizeController: UIViewController {

    private let contentViewController: UIViewController

    public init(contentViewController: UIViewController) {
        self.contentViewController = contentViewController
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        //self.noom.addChildFittingSuperview(contentViewController)

        self.preferredContentSize = self.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        preferredContentSize = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}

internal protocol PopoverPresentationDelegate: AnyObject {
    func willPresentPopover(
        in containerView: UIView,
        sourceRect: CGRect,
        transitionCoordinator: UIViewControllerTransitionCoordinator?
    )
    func willHidePopover()
    func willRepositionPopover(to sourceRect: CGRect)
    func willDismissPopover(transitionCoordinator: UIViewControllerTransitionCoordinator?)
}

internal final class PopoverContentViewController<
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
        //view.backgroundColor = theme.color(for: attributes.popoverColor)
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

public extension UIBarButtonItem {

    /// Convert a view's frame to global coordinates.
    func frameInWindow() -> CGRect {
        guard let view = value(forKey: "view") as? UIView else {
            return .zero
        }
        return view.frameInWindow()
    }
}



public struct PopoverAttributes {
    public var allowTapOutsideToDismiss: Bool = true
    public var onTapOutside: (() -> Void)?
    public var onDismiss: (() -> Void)?
    public var popoverPermittedArrowDirection: UIPopoverArrowDirection
    public var popoverLayoutMargins: UIEdgeInsets = .zero
    public var sourceRectInsets: UIEdgeInsets = .zero

    public init(
        allowTapOutsideToDismiss: Bool = true,
        onTapOutside: (() -> Void)? = nil,
        onDismiss: (() -> Void)? = nil,
        popoverPermittedArrowDirection: UIPopoverArrowDirection = .any,
        sourceRectInsets: UIEdgeInsets = .zero
    ) {
        self.allowTapOutsideToDismiss = allowTapOutsideToDismiss
        self.onTapOutside = onTapOutside
        self.onDismiss = onDismiss
        self.popoverPermittedArrowDirection = popoverPermittedArrowDirection
        self.sourceRectInsets = sourceRectInsets
    }
}

internal struct DismissableTooltipView {

    var title: String = ""
    var description: String
    var closeAction: () -> Void
}

extension DismissableTooltipView {
    var closeIcon: Image { Image(systemName: "xmark") }
    var closeIconSize: CGSize { CGSize(width: 10, height: 10) }
    var closeIconTopPadding: CGFloat { 7 }
    var closeButtonSize: CGSize { CGSize(width: 44, height: 44) }
    var horizontalContentPadding: CGFloat { 16 }
    var verticalContentPadding: CGFloat { 8 }
    var textSpacing: CGFloat { 8 }
}

extension DismissableTooltipView: View {

    var body: some View {
        HStack(alignment: .top, spacing: 0) {

            VStack(alignment: .leading, spacing: textSpacing) {
                if !title.isEmpty {
                    Text(title)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.subheadline)
                        .foregroundColor(.black)
                }

                Text(description)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.body)
                    .foregroundColor(.black)
            }

            Button(action: closeAction) {
                ZStack(alignment: .top) {
                    Color.clear
                        .frame(width: closeButtonSize.width, height: closeButtonSize.height)

                    closeIcon
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(.black)
                        .frame(width: closeIconSize.width, height: closeIconSize.height)
                        .padding(.top, closeIconTopPadding)
                }
            }
        }
        .padding(.leading, horizontalContentPadding)
        .padding([.top, .bottom], verticalContentPadding)
    }
}

struct TooltipBackground: View {

    var body: some View {
        PopoverBackgroundMaskView()
    }
}

internal struct PopoverBackgroundMaskView<Mask: View> {
    let sourceRect: CGRect
    @ViewBuilder let mask: () -> Mask
}

extension PopoverBackgroundMaskView {
    var color: Color { .black.opacity(0.3) }
}

internal extension View {

    /// Inverse of a typical mask.
    ///
    /// The content is not masked to the shape of the view, but instead creates a cutout of the view in the content.
    func reverseMask<Mask: View>(@ViewBuilder _ mask: () -> Mask) -> some View {
        self.mask(
            ZStack {
                Rectangle()
                mask()
                    .blendMode(.destinationOut)
            }
        )
    }
}

extension PopoverBackgroundMaskView where Mask == EmptyView {

    init() {
        self.sourceRect = .zero
        self.mask = { EmptyView() }
    }
}



extension PopoverBackgroundMaskView: View {

    var body: some View {
        color
            .reverseMask {
                mask()
                    .frame(width: sourceRect.width, height: sourceRect.height)
                    .position(x: sourceRect.midX, y: sourceRect.midY)
            }
            .edgesIgnoringSafeArea(.all)
    }
}

internal final class PopoverBackgroundViewController<Background: View>: PopoverPresentationDelegate {

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
