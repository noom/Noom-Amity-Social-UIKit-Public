//
// Created by Matias Crespillo
// Copyright ® 2022 Noom, Inc. All Rights Reserved
//

import Foundation
import SnapKit
import UIKit

class AmityMeProfileHeaderTableViewCell: UITableViewCell {
    private let avatarView = AmityAvatarView()
    private let displayNameLabel = UILabel()
    private let followingButton = AmityButton(frame: .zero)
    private let followersButton = AmityButton(frame: .zero)
    public weak var delegate: AmityMeProfileHeaderTableViewCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.selectionStyle = .none
        contentView.addSubview(avatarView)
        avatarView.layer.cornerRadius = 20
        avatarView.layer.masksToBounds = true
        avatarView.contentMode = .scaleAspectFill
        avatarView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().inset(16)
            make.width.height.equalTo(40)
        }
        contentView.addSubview(displayNameLabel)
        displayNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarView.snp.trailing).offset(8)
            make.top.equalTo(avatarView)
            make.trailing.equalToSuperview().inset(16)
        }
        contentView.addSubview(followingButton)
        followingButton.snp.makeConstraints { make in
            make.leading.equalTo(displayNameLabel)
            make.top.equalTo(displayNameLabel.snp.bottom)
            make.height.equalTo(20)
        }
        contentView.addSubview(followersButton)
        followersButton.snp.makeConstraints { make in
            make.leading.equalTo(followingButton.snp.trailing).offset(8)
            make.top.equalTo(displayNameLabel.snp.bottom)
            make.height.equalTo(20)
        }
        setupDisplayName()
        setupFollowingButton()
        setupFollowersButton()
    }

    private func setupDisplayName() {
        avatarView.placeholder = AmityIconSet.defaultAvatar
        displayNameLabel.text = ""
        displayNameLabel.font = AmityFontSet.headerLine
        displayNameLabel.textColor = AmityColorSet.base
        displayNameLabel.numberOfLines = 3
    }

    private func setupFollowingButton() {
        let attribute = AmityAttributedString()
        attribute.setBoldFont(for: AmityFontSet.captionBold)
        attribute.setNormalFont(for: AmityFontSet.caption)
        attribute.setColor(for: AmityColorSet.secondary)
        followingButton.attributedString = attribute
        followingButton.isHidden = false
        followingButton.isUserInteractionEnabled = false

        followingButton.addTarget(
            self,
            action: #selector(followingButtonTapped(sender: )),
            for: .touchUpInside
        )

        followingButton.attributedString.setTitle(String.localizedStringWithFormat(AmityLocalizedStringSet.userDetailFollowingCount.localizedString, "0"))
    }

    private func setupFollowersButton() {
        let attribute = AmityAttributedString()
        attribute.setBoldFont(for: AmityFontSet.captionBold)
        attribute.setNormalFont(for: AmityFontSet.caption)
        attribute.setColor(for: AmityColorSet.secondary)
        followersButton.attributedString = attribute
        followersButton.isHidden = false
        followersButton.isUserInteractionEnabled = false
        followersButton.addTarget(
            self,
            action: #selector(followersButtonTapped(sender:)),
            for: .touchUpInside
        )

        followersButton.attributedString.setTitle(
            String.localizedStringWithFormat(
                AmityLocalizedStringSet.userDetailFollowersCount.localizedString,
                "0"
            )
        )
    }

    public func update(with user: AmityUserModel?, followInfo: AmityFollowInfo?) {
        if let user = user {
            avatarView.setImage(
                withImageURL: user.avatarURL, placeholder: AmityIconSet.defaultAvatar)
            displayNameLabel.text = user.displayName
        } else {
            avatarView.setImage(withImageURL: nil, placeholder: AmityIconSet.defaultAvatar)
            displayNameLabel.text = nil
        }
        let followers: String
        let following: String
        if let followInfo = followInfo {
            followers = "\(followInfo.followerCount)"
            following = "\(followInfo.followingCount)"
        } else {
            followers = "0"
            following = "0"
        }
        followersButton.attributedString.setTitle(
            String.localizedStringWithFormat(
                AmityLocalizedStringSet.userDetailFollowersCount.localizedString,
                followers
            )
        )
        followersButton.setAttributedTitle()
        followingButton.attributedString.setTitle(
            String.localizedStringWithFormat(
                AmityLocalizedStringSet.userDetailFollowersCount.localizedString,
                following
            )
        )
        followingButton.setAttributedTitle()
    }

    @objc
    private func followersButtonTapped(sender: UIButton) {
        self.delegate?.handleTapAction(isFollowersSelected: true)
    }

    @objc
    private func followingButtonTapped(sender: UIButton) {
        self.delegate?.handleTapAction(isFollowersSelected: false)
    }

}

protocol AmityMeProfileHeaderTableViewCellDelegate: AnyObject {
    func handleTapAction(isFollowersSelected: Bool)
}
