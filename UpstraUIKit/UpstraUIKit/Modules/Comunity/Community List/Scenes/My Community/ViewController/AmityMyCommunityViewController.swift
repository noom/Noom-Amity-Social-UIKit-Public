//
//  AmityMyCommunityViewController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 26/4/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import AmitySDK
import SnapKit
import UIKit

/// A view controller for providing all community list.
public final class AmityMyCommunityViewController: AmityViewController, IndicatorInfoProvider {

    func indicatorInfo(for pagerTabStripController: AmityPagerTabViewController) -> IndicatorInfo {
        return IndicatorInfo(title: pageTitle, accessibilityIdentier: "home_screen_tab_me")
    }

    var pageTitle: String?
    // MARK: - IBOutlet Properties
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var createButton: UIButton!
    
    // MARK: - Properties
    private var emptyView = AmitySearchEmptyView()
    private var screenViewModel: AmityMyCommunityScreenViewModelType!
    private var userViewModel: AmityUserProfileHeaderScreenViewModel!
    private var userModel: AmityUserModel? {
        didSet {
            self.tableView.reloadData()
        }
    }
    private var followInfo: AmityFollowInfo? {
        didSet {
            self.tableView.reloadData()
        }
    }

    private enum TableSections: Int {
        case user = 0
        case communities = 1
    }
    
    // MARK: - View lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        setupScreenViewModel()
        createButton.titleLabel?.font = AmityFontSet.bodyBold
        createButton.layer.cornerRadius = 4
        createButton.layer.masksToBounds = true
        userViewModel.delegate = self
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userViewModel.fetchUserData()
        userViewModel.fetchFollowInfo()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AmityUIKitManager.track(event: .screenViewed(screen: .userCommunities))
    }
    
    public static func make() -> AmityMyCommunityViewController {
        let communityListRepositoryManager = AmityCommunityListRepositoryManager()
        let viewModel = AmityMyCommunityScreenViewModel(communityListRepositoryManager: communityListRepositoryManager)
        let profileViewModel = AmityUserProfileHeaderScreenViewModel(userId: AmityUIKitManagerInternal.shared.currentUserId)
        let vc = AmityMyCommunityViewController(nibName: AmityMyCommunityViewController.identifier, bundle: AmityUIKitManager.bundle)
        vc.screenViewModel = viewModel
        vc.userViewModel = profileViewModel
        return vc
    }
    
    // MARK: - Setup viewModel
    private func setupScreenViewModel() {
        screenViewModel.delegate = self
        screenViewModel.action.retrieveAllCommunity()
    }
    
    // MARK: - Setup views
    private func setupView() {
        title = AmityLocalizedStringSet.Home.homeMe.localizedString
        if communityCreationButtonVisible() {
            let rightItem = UIBarButtonItem(image: AmityIconSet.iconAdd, style: .plain, target: self, action: #selector(createCommunityTap))
            rightItem.tintColor = AmityColorSet.base
            navigationItem.rightBarButtonItem = rightItem
        }
    }
    
    private func communityCreationButtonVisible() -> Bool {
        // The default visibility of this button.
        var visible = true
        // If someone override this env, we then force visibility to be that value.
        if let overrideVisible = AmityUIKitManagerInternal.shared.env["amity_uikit_social_community_creation_button_visible"] as? Bool {
            visible = overrideVisible
        }
        return visible
    }
    
    private func setupTableView() {
        tableView.register(cell: AmityMyCommunityTableViewCell.self)
        tableView.register(
            AmityMeProfileHeaderTableViewCell.self,
            forCellReuseIdentifier: AmityMeProfileHeaderTableViewCell.amityIdentifier
        )
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorColor = .clear
        emptyView.topMargin = 100
    }
    
}

private extension AmityMyCommunityViewController {
    @IBAction @objc func createCommunityTap() {
        let vc = AmityCommunityCreatorViewController.make()
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}

extension AmityMyCommunityViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = TableSections(rawValue: indexPath.section) else { return }
        switch section {
        case .user:
            AmityEventHandler.shared.userDidTap(
                from: self,
                userId: AmityUIKitManagerInternal.shared.currentUserId
            )
        case .communities:
            guard let communityId = screenViewModel.dataSource.item(at: indexPath)?.communityId else { return }
            AmityEventHandler.shared.communityDidTap(from: self, communityId: communityId)
        }
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isBottomReached {
            screenViewModel.action.loadMore()
        }
    }
}

extension AmityMyCommunityViewController: UITableViewDataSource {

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = TableSections(rawValue: section) else { return nil }
        switch section {
            case .user:
                return MeHeaderView(title: AmityLocalizedStringSet.Home.homeMyProfile.localizedString)
            case .communities:
                return MeHeaderView(title: AmityLocalizedStringSet.myCommunityTitle.localizedString)
        }
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = TableSections(rawValue: section) else { return 0 }
        switch section {
        case .user:
            return 1
        case .communities:
            return screenViewModel.dataSource.numberOfCommunity()
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = TableSections(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .user:
            let cell: AmityMeProfileHeaderTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.update(with: self.userModel, followInfo: self.followInfo)
            cell.delegate = self
            return cell
        case .communities:
            let cell: AmityMyCommunityTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            guard let community = screenViewModel.dataSource.item(at: indexPath) else { return UITableViewCell() }
            cell.display(with: community)
            cell.delegate = self
            return cell
        }

    }
}

extension AmityMyCommunityViewController: AmityMyCommunityTableViewCellDelegate {
    
    func cellDidTapOnAvatar(_ cell: AmityMyCommunityTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        guard let community = screenViewModel.dataSource.item(at: indexPath) else { return }
        AmityEventHandler.shared.communityDidTap(from: self, communityId: community.communityId)
    }
    
}

extension AmityMyCommunityViewController: AmityMyCommunityScreenViewModelDelegate {
    
    func screenViewModelDidRetrieveAllCommunity(_ viewModel: AmityMyCommunityScreenViewModelType) {
        emptyView.removeFromSuperview()
    }
    
    func screenViewModelDidSearch(_ viewModel: AmityMyCommunityScreenViewModelType) {
        emptyView.removeFromSuperview()
    }

    func screenViewModelDidSearchNotFound(_ viewModel: AmityMyCommunityScreenViewModelType) {
        tableView.setEmptyView(view: emptyView)
    }
    
    func screenViewModelDidSearchCancel(_ viewModel: AmityMyCommunityScreenViewModelType) {
    }
    
    func screenViewModel(_ viewModel: AmityMyCommunityScreenViewModelType, loadingState: AmityLoadingState) {
        switch loadingState {
        case .initial:
            break
        case .loading:
            emptyView.removeFromSuperview()
            tableView.showLoadingIndicator()
            tableView.reloadData()
        case .loaded:
            tableView.tableFooterView = UIView()
            tableView.reloadData()
        }
    }
  
}

extension AmityMyCommunityViewController: AmityCommunityProfileEditorViewControllerDelegate {
    
    public func viewController(_ viewController: AmityCommunityProfileEditorViewController, didFinishCreateCommunity communityId: String) {
        AmityEventHandler.shared.communityDidTap(from: self, communityId: communityId)
    }
    
}

extension AmityMyCommunityViewController: AmityMeProfileHeaderTableViewCellDelegate {
    func handleTapAction(isFollowersSelected: Bool) {
        let vc = AmityUserFollowersViewController.make(
            withUserId: AmityUIKitManagerInternal.shared.currentUserId,
            isFollowersSelected: isFollowersSelected
        )
        navigationController?.pushViewController(vc, animated: true)
    }
}

private class MeHeaderView: UIView {
    private let label = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = AmityColorSet.base
        label.font = AmityFontSet.title
        return label
    }()

    init(title: String) {
        super.init(frame: .zero)
        setup()
        self.label.text = title
        self.backgroundColor = .white
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(label)
        label.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
    }
}

extension AmityMyCommunityViewController: AmityUserProfileHeaderScreenViewModelDelegate {
    func screenViewModelDidFollowFail() {
        // do nothing
    }

    func screenViewModelDidUnfollowFail() {
        // do nothing
    }

    func screenViewModel(_ viewModel: AmityUserProfileHeaderScreenViewModelType, didGetUser user: AmityUserModel) {
        self.userModel = user
    }

    func screenViewModel(_ viewModel: AmityUserProfileHeaderScreenViewModelType, didGetFollowInfo followInfo: AmityFollowInfo) {
        self.followInfo = followInfo
    }

    func screenViewModel(_ viewModel: AmityUserProfileHeaderScreenViewModelType, didCreateChannel channel: AmityChannel) {
        // do nothing
    }

    func screenViewModel(_ viewModel: AmityUserProfileHeaderScreenViewModelType, didFollowSuccess status: AmityFollowStatus) {
        // do nothing
    }

    func screenViewModel(_ viewModel: AmityUserProfileHeaderScreenViewModelType, didUnfollowSuccess status: AmityFollowStatus) {
        // do nothing
    }

    func screenViewModel(_ viewModel: AmityUserProfileHeaderScreenViewModelType, failure error: AmityError) {
        // do nothing
    }

}
