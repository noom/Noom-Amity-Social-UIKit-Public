//
//  AmityCategoryPreviewCollectionViewCell.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 6/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityCategoryPreviewCollectionViewCellDelegate: AnyObject {
    func cellDidTapOnAvatar(_ cell: AmityCategoryPreviewCollectionViewCell)
}

class AmityCategoryPreviewCollectionViewCell: UICollectionViewCell, Nibbable {

    @IBOutlet private var containerView: UIView!
    @IBOutlet private var avatarView: AmityAvatarView!
    @IBOutlet private var categoryNameLabel: UILabel!
    @IBOutlet private var communityCount: UILabel!
    
    weak var delegate: AmityCategoryPreviewCollectionViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func display(with model: AmityCommunityCategoryModel) {
        avatarView.setImage(withImageURL: model.avatarURL, placeholder: AmityIconSet.defaultCategory)
        categoryNameLabel.text = model.name
        let string: String
        if model.communityCount == 1 {
            string = AmityLocalizedStringSet.categoryCommunityCountSingular.localizedString
        } else {
            string = AmityLocalizedStringSet.categoryCommunityCount.localizedString
        }
        let countString = String.localizedStringWithFormat(string, "\(model.communityCount)")
        communityCount.text = countString
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.image = nil
    }
}

// MARK: - Setup view
private extension AmityCategoryPreviewCollectionViewCell {
    func setupView() {
        self.layer.backgroundColor = AmityThemeManager.currentTheme.messageBubble.cgColor
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        setupAvatarView()
        setupCategoryName()
        setupCommunityCount()
    }
    
    func setupAvatarView() {
        avatarView.placeholder = AmityIconSet.defaultCategory
        
        avatarView.actionHandler = { [weak self] in
            self?.avatarTap()
        }
    }
    
    func setupCategoryName() {
        categoryNameLabel.text = ""
        categoryNameLabel.textColor = AmityColorSet.base
        categoryNameLabel.font = AmityFontSet.bodyBold
    }

    func setupCommunityCount() {
        communityCount.text = ""
        communityCount.textColor = AmityColorSet.base.blend(.shade1)
        communityCount.font = AmityFontSet.caption
    }
}

// MARK:- Actions
private extension AmityCategoryPreviewCollectionViewCell {
    func avatarTap() {
        delegate?.cellDidTapOnAvatar(self)
    }
}
