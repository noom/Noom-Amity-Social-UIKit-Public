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
