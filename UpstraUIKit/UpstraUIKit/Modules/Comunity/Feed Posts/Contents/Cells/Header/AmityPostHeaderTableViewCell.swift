//
//  AmityPostHeaderTableViewCell.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 2/5/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit

/// `AmityPostHeaderTableViewCell` for providing a header of `Post`
public final class AmityPostHeaderTableViewCell: UITableViewCell, Nibbable, AmityPostHeaderProtocol {
    public weak var delegate: AmityPostHeaderDelegate?
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var avatarView: AmityAvatarView!
    @IBOutlet private var displayNameLabel: AmityFeedDisplayNameLabel!
    @IBOutlet private var badgeStackView: UIStackView!
    @IBOutlet private var badgeIconImageView: UIImageView!
    @IBOutlet private var badgeLabel: UILabel!
    @IBOutlet private var datetimeLabel: UILabel!
    @IBOutlet private var optionButton: UIButton!
    @IBOutlet private var headerView: UIView!
    @IBOutlet private var headerLabel: UILabel!
    @IBOutlet private var headerViewHeightConstraint: NSLayoutConstraint!

    private(set) public var post: AmityPostModel?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.placeholder = AmityIconSet.defaultAvatar
    }
    
    public func display(post: AmityPostModel) {
        self.post = post
        if let urlString = post.postedUser?.avatarURL,
           !urlString.isEmpty {
            avatarView.setImage(withImageURL: post.postedUser?.avatarURL, placeholder: AmityIconSet.defaultAvatar)
        } else if let name = post.postedUser?.displayName {
            avatarView.displayInitials(for: name)
        }

        avatarView.actionHandler = { [weak self] in
            self?.avatarTap()
        }

        displayNameLabel.configure(displayName: post.displayName,
                                   communityName: post.targetCommunity?.displayName,
                                   isOfficial: post.targetCommunity?.isOfficial ?? false,
                                   shouldShowCommunityName: post.appearance.shouldShowCommunityName,
                                   shouldShowBannedSymbol: post.postedUser?.isGlobalBan ?? false,
                                   noomRole: post.postedUser?.noomRole
        )
        displayNameLabel.delegate = self
        datetimeLabel.text = post.subtitle

        switch post.feedType {
        case .reviewing:
            optionButton.isHidden = !post.isOwner
        default:
            optionButton.isHidden = !(post.appearance.shouldShowOption && post.isCommentable)
        }
        displayNameLabel.delegate = self
        datetimeLabel.text = post.subtitle

        if let role = post.postedUser?.noomRole {
            headerView.isHidden = false
            headerViewHeightConstraint.constant = 20
            headerLabel.text = role.name
        } else {
            headerView.isHidden = true
            headerViewHeightConstraint.constant = 0
            headerLabel.text = nil
        }
    }

    // MARK: - Setup views
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        containerView.backgroundColor = AmityColorSet.backgroundColor
        displayNameLabel.configure(
            displayName: AmityLocalizedStringSet.General.anonymous.localizedString,
            communityName: nil,
            isOfficial: false,
            shouldShowCommunityName: false,
            shouldShowBannedSymbol: false,
            noomRole: nil
        )
        
        // badge
        badgeLabel.text = AmityLocalizedStringSet.General.moderator.localizedString + " • "
        badgeLabel.font = AmityFontSet.captionBold
        badgeLabel.textColor = AmityColorSet.base.blend(.shade1)
        badgeIconImageView.image = AmityIconSet.iconBadgeModerator
        badgeLabel.isHidden = true
        badgeIconImageView.isHidden = true
        
        // date time
        datetimeLabel.font = AmityFontSet.postHeaderAuxiliary
        datetimeLabel.textColor = AmityThemeManager.currentTheme.postHeaderAuxiliary
        datetimeLabel.text = "45 mins"
        
        // option
        optionButton.tintColor = AmityColorSet.base
        optionButton.setImage(AmityIconSet.iconOption, for: .normal)
        headerView.isHidden = true
        headerViewHeightConstraint.constant = 0

        headerLabel.text = nil
        headerLabel.font = AmityFontSet.postHeaderRoleName
    }
    
    // MARK: - Perform Action
    private func performAction(action: AmityPostHeaderAction) {
        delegate?.didPerformAction(self, action: action)
    }
    
}

// MARK: - Action
private extension AmityPostHeaderTableViewCell {
    
    func avatarTap() {
        performAction(action: .tapAvatar)
    }
    
    @IBAction func optionTap() {
        performAction(action: .tapOption)
    }
}

extension AmityPostHeaderTableViewCell: AmityFeedDisplayNameLabelDelegate {
    func labelDidTapUserDisplayName(_ label: AmityFeedDisplayNameLabel) {
        performAction(action: .tapDisplayName)
    }
    
    func labelDidTapCommunityName(_ label: AmityFeedDisplayNameLabel) {
        performAction(action: .tapCommunityName)
    }
}
