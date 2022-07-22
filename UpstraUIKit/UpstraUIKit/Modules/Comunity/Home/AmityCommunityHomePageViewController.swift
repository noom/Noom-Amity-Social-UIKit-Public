//
//  AmityCommunityHomePageViewController.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 18/8/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

public class AmityCommunityHomePageViewController: AmityPageViewController {
    
    // MARK: - Properties
    public let newsFeedVC = AmityNewsfeedViewController.make()
    public let exploreVC = AmityCommunityExplorerViewController.make()
    public let myCommunitiesVC = AmityMyCommunityViewController.make()
    
    private init() {
        super.init(nibName: AmityCommunityHomePageViewController.identifier, bundle: AmityUIKitManager.bundle)
        title = AmityLocalizedStringSet.communityHomeTitle.localizedString
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    public static func make(analytics: AmityAnalytics) -> AmityCommunityHomePageViewController {
        AmityUIKitManager.set(analyticsClient: analytics)
        return AmityCommunityHomePageViewController()
    }
    
    override func viewControllers(for pagerTabStripController: AmityPagerTabViewController) -> [UIViewController] {
        newsFeedVC.pageTitle = AmityLocalizedStringSet.newsfeedTitle.localizedString
        exploreVC.pageTitle = AmityLocalizedStringSet.exploreTitle.localizedString
        myCommunitiesVC.pageTitle = AmityLocalizedStringSet.myCommunityTitle.localizedString
        return [newsFeedVC, exploreVC, myCommunitiesVC]
    }
    
    // MARK: - Setup view
    
    private func setupNavigationBar() {
        let searchItem = UIBarButtonItem(image: AmityIconSet.iconSearch, style: .plain, target: self, action: #selector(searchTap))
        searchItem.tintColor = AmityColorSet.base
        navigationItem.rightBarButtonItem = searchItem
        searchItem.tintColor = AmityColorSet.base
        navigationItem.rightBarButtonItem = searchItem
        let closeItem = UIBarButtonItem(
            image: AmityIconSet.iconClose,
            style: .plain,
            target: self,
            action: #selector(closeTapped)
        )
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
}

