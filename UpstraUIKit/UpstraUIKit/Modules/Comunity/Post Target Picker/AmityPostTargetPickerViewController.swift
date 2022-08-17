//
//  AmityPostTargetSelectionViewController.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 31/7/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit

final public class AmityPostTargetPickerViewController: AmityViewController {
    
    /// Set this variable to indicate post type to create.
    var postContentType: AmityPostContentType = .post
    var analyticsSource: CreatePostSource = .other

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let screenViewModel = AmityPostTargetPickerScreenViewModel()
    
    private init() {
        super.init(nibName: nil, bundle: nil)
        title = AmityLocalizedStringSet.postToTitle.localizedString
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static func make(
        postContentType: AmityPostContentType = .post,
        analyticsSource: CreatePostSource
    ) -> AmityPostTargetPickerViewController {
        let vc = AmityPostTargetPickerViewController()
        vc.postContentType = postContentType
        vc.analyticsSource = analyticsSource
        return vc
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        setupScreenViewModel()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AmityUIKitManager.track(event: .screenViewed(screen: .postTargetSelect))
    }
    
    private func setupView() {
        tableView.backgroundColor = AmityColorSet.backgroundColor
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.register(AmityCommunityTableViewCell.nib, forCellReuseIdentifier: AmityCommunityTableViewCell.amityIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
    
    private func setupScreenViewModel() {
        screenViewModel.delegate = self
        screenViewModel.observe()
    }
    
}

extension AmityPostTargetPickerViewController: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenViewModel.numberOfItems()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AmityCommunityTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        if let item = screenViewModel.dataSource.community(at: indexPath) {
            let model = AmityCommunityModel(object: item)
            cell.configure(with: .community(model))
        }
        if tableView.isBottomReached {
            screenViewModel.loadNext()
        }
        return cell
    }
    
}

extension AmityPostTargetPickerViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 72 : 56
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return screenViewModel.numberOfItems() > 0 ? 44 : 0
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.width, height: 44))
        headerView.backgroundColor = AmityColorSet.backgroundColor
        let label = UILabel(frame: CGRect(x: 16.0, y: 0.0, width: headerView.frame.width - 32.0, height: 44))
        label.text = AmityLocalizedStringSet.myCommunityTitle.localizedString
        label.textColor = AmityColorSet.base.blend(.shade3)
        label.font = AmityFontSet.body
        headerView.addSubview(label)
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let community = screenViewModel.community(at: indexPath) else { return }
        
        AmityEventHandler.shared.postTargetDidSelect(
            from: self,
            postTarget: .community(object: community),
            postContentType: self.postContentType,
            analyticsSource: analyticsSource
        )
    }
    
}

extension AmityPostTargetPickerViewController: AmityPostTargetPickerScreenViewModelDelegate {
    
    func screenViewModelDidUpdateItems(_ viewModel: AmityPostTargetPickerScreenViewModel) {
        tableView.reloadData()
    }
    
}
