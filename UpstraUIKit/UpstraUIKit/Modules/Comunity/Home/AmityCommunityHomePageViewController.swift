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
    public var notificationAPIClient: NotificationTrayAPIClient?
    
    // MARK: - Properties
    public let newsFeedVC = AmityNewsfeedViewController.make()
    public let exploreVC = AmityCommunityExplorerViewController.make()
    public let myCommunitiesVC = AmityMyCommunityViewController.make()
    private var notificationsItem: UIBarButtonItem?

    // MARK: - Buttons -

    private lazy var notificationsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bell.fill"), for: .normal)
        button.addTarget(self, action: #selector(notificationsTapped), for: .touchUpInside)
        return button
    }()

    private let badgeSize: CGFloat = 20
    private lazy var badgeCountLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: badgeSize, height: badgeSize))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = label.bounds.size.height / 2
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.textColor = .white
        label.font = label.font.withSize(12)
        label.backgroundColor = .systemRed
        return label
    }()

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
        fetchNotifications()
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
        notificationAPIClient: NotificationTrayAPIClient? = nil,
        exitClosure: (@escaping () -> Void) = {}
    ) -> AmityCommunityHomePageViewController {
        AmityUIKitManager.set(analyticsClient: analytics)
        let viewController = AmityCommunityHomePageViewController()
        viewController.exitClosure = exitClosure
        viewController.notificationAPIClient = notificationAPIClient
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

        setupNotificationsBadge()
        let notificationItem = UIBarButtonItem(customView: notificationsButton)
        notificationItem.tintColor = AmityColorSet.base
        notificationItem.accessibilityIdentifier = "notifications_button"
        self.notificationsItem = notificationItem
        navigationItem.rightBarButtonItems = [searchItem, notificationItem]
        // TODO(LTRGTR-168): Set right bar buttons to include notification bell
        setupCloseItem()
    }

    private func setupCloseItem() {
        let closeItem = UIBarButtonItem(
            image: AmityIconSet.iconClose,
            style: .plain,
            target: self,
            action: #selector(closeTapped)
        )
        closeItem.accessibilityIdentifier = "home_close_button"
        navigationItem.leftBarButtonItem = closeItem
    }

    private func setupNotificationsBadge() {
        badgeCountLabel.isHidden = true
        NSLayoutConstraint.activate([
            notificationsButton.widthAnchor.constraint(equalToConstant: 34),
            notificationsButton.heightAnchor.constraint(equalToConstant: 44),
        ])
        notificationsButton.addSubview(badgeCountLabel)

        NSLayoutConstraint.activate([
            badgeCountLabel.leftAnchor.constraint(equalTo: notificationsButton.leftAnchor, constant: 14),
            badgeCountLabel.topAnchor.constraint(equalTo: notificationsButton.topAnchor, constant: 4),
            badgeCountLabel.widthAnchor.constraint(equalToConstant: badgeSize),
            badgeCountLabel.heightAnchor.constraint(equalToConstant: badgeSize)
        ])
    }

    private func fetchNotifications() {
        guard let client = notificationAPIClient else { return }
        _ = client
            .getNotifications()
            .map({ [weak self] result in
                switch result {
                case .success(let notifications):
                    self?.showBadge(withCount: notifications.count)
                    // TODO: fetch the Notifications.User info to get the lastSeenTime of the notifications and then calculate the number of most recent notifcations that the user has not seen.
                case .failure(let error):
                    print(error)
                }
            })
    }

    private func showBadge(withCount count: Int) {
        badgeCountLabel.isHidden = false
        badgeCountLabel.text = String(count)
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
        guard
            let notificationsItem = notificationsItem,
            let notificationAPIClient = notificationAPIClient
        else {
            return
        }
        presentNavbarTooltip(
            anchorItem: notificationsItem,
            client: .init(
                api: notificationAPIClient,
                close: { [weak self] in
                    .fireAndForget { self?.dismiss(animated: true) }
                },
                openNotification: { [weak self] postId in
                    .fireAndForget {
                        self?.dismiss(animated: true) {
                            let viewController = AmityPostDetailViewController.make(withPostId: postId.value)
                            self?.navigationController?.pushViewController(viewController, animated: true)
                        }
                    }
                }
            )
        )
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
