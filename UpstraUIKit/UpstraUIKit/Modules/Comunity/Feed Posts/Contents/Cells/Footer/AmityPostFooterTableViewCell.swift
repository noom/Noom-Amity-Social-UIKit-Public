//
//  AmityPostFooterTableViewCell.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 2/5/21.
//  Copyright © 2021 Amity. All rights reserved.
//
import SnapKit
import UIKit

/// `AmityPostFooterTableViewCell` for providing a footer of `Post`
public final class AmityPostFooterTableViewCell: UITableViewCell, Nibbable, AmityCellIdentifiable, AmityPostFooterProtocol {
    
    public weak var delegate: AmityPostFooterDelegate?

    // MARK: - IBOutlet Properties
    @IBOutlet private var topContainerView: UIView!
    @IBOutlet private var likeLabel: UILabel!
    @IBOutlet private var commentLabel: UILabel!
    @IBOutlet private var shareLabel: UILabel!
    @IBOutlet private var actionStackView: UIStackView!
    @IBOutlet private var likeButton: AmityButton!
    @IBOutlet private var commentButton: AmityButton!
    @IBOutlet private var shareButton: AmityButton!
    @IBOutlet private var separatorView: [UIView]!
    @IBOutlet private var warningLabel: UILabel!
    @IBOutlet private var bottomDivider: UIView!
    @IBOutlet private var stackView: UIStackView!
    
    // MARK: - Properties
    private(set) public var post: AmityPostModel?
    public var indexPath: IndexPath?
    private var commentsDisabledView = CommentsDisabledView()
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        setupWarningLabel()
        setupLikeButton()
        setupCommentButton()
        setupShareButton()
    }
    
    public func display(post: AmityPostModel) {
        self.post = post
        likeButton.isSelected = post.isLiked
        likeLabel.isHidden = post.reactionsCount == 0
        let reactionsPrefix = post.reactionsCount == 1 ? AmityLocalizedStringSet.Unit.likeSingular.localizedString : AmityLocalizedStringSet.Unit.likePlural.localizedString
        likeLabel.text = String.localizedStringWithFormat(reactionsPrefix,
                                                          post.reactionsCount.formatUsingAbbrevation())
        commentLabel.isHidden = post.allCommentCount == 0 || post.commentsHidden
        let commentPrefix = post.allCommentCount == 1 ? AmityLocalizedStringSet.Unit.commentSingular.localizedString : AmityLocalizedStringSet.Unit.commentPlural.localizedString
        commentLabel.text = String.localizedStringWithFormat(commentPrefix,
                                                             post.allCommentCount.formatUsingAbbrevation())
        
        let isReactionExisted = post.reactionsCount == 0 && post.allCommentCount == 0
        actionStackView.isHidden = !post.isCommentable
        warningLabel.isHidden = post.isCommentable
        topContainerView.isHidden = isReactionExisted
        
        shareButton.isHidden = !AmityPostSharePermission.canSharePost(post: post)
        shareLabel.isHidden = post.sharedCount == 0
        let sharePrefix = post.sharedCount > 1 ? AmityLocalizedStringSet.Unit.sharesPlural.localizedString :
            AmityLocalizedStringSet.Unit.sharesSingular.localizedString
        shareLabel.text = String.localizedStringWithFormat(sharePrefix, post.sharedCount)
        if let role = post.postedUser?.noomRole {
            bottomDivider.backgroundColor = AmityColorSet.primary
        } else {
            bottomDivider.backgroundColor = AmityThemeManager.currentTheme.pollBackground
        }

        commentButton.isHidden = !post.canComment
        if !post.canComment {
            if self.commentsDisabledView.superview == nil {
                self.stackView.addArrangedSubview(commentsDisabledView)
            }
        } else {
            self.commentsDisabledView.removeFromSuperview()
        }
    }
    
    // MARK: - Setup views
    private func setupView() {
        selectionStyle = .none
        backgroundColor = AmityColorSet.backgroundColor
        contentView.backgroundColor = AmityColorSet.backgroundColor
        // separator
        separatorView.forEach { $0.backgroundColor = AmityThemeManager.currentTheme.pollBackground }
    }
    
    private func setupWarningLabel() {
        // warning
        warningLabel.isHidden = true
        warningLabel.text = AmityLocalizedStringSet.PostDetail.joinCommunityMessage.localizedString
        warningLabel.font = AmityFontSet.body
        warningLabel.textColor = AmityColorSet.base.blend(.shade2)
    }
    
    private func setupLikeButton() {
        // like button
        likeButton.setTitle(AmityLocalizedStringSet.General.liked.localizedString, for: .selected)
        likeButton.setTitle(AmityLocalizedStringSet.General.like.localizedString, for: .normal)
        likeButton.setTitleColor(AmityColorSet.primary, for: .selected)
        likeButton.setTitleColor(AmityColorSet.base.blend(.shade2), for: .normal)
        likeButton.setImage(AmityIconSet.iconLike, for: .normal)
        likeButton.setImage(AmityIconSet.iconLikeFill, for: .selected)
        likeButton.setTintColor(AmityColorSet.primary, for: .selected)
        likeButton.setTintColor(AmityColorSet.base.blend(.shade2), for: .normal)
        likeButton.setTitleFont(AmityFontSet.bodyBold)
        likeButton.setInsets(forContentPadding: .zero, imageTitlePadding: 4)
        
        // like badge
        likeLabel.textColor = AmityColorSet.base.blend(.shade2)
        likeLabel.font = AmityFontSet.caption
    }
    private func setupCommentButton() {
        // comment button
        commentButton.tintColor = AmityColorSet.base.blend(.shade2)
        commentButton.setTitleColor(AmityColorSet.base.blend(.shade2), for: .normal)
        commentButton.setImage(AmityIconSet.iconComment, for: .normal)
        commentButton.setTintColor(AmityColorSet.base.blend(.shade2), for: .normal)
        commentButton.setTitleFont(AmityFontSet.bodyBold)
        commentButton.setInsets(forContentPadding: .zero, imageTitlePadding: 4)
        
        // comment badge
        commentLabel.textColor = AmityColorSet.base.blend(.shade2)
        commentLabel.font = AmityFontSet.caption
    }
    
    private func setupShareButton() {
        // share button
        shareButton.setInsets(forContentPadding: .zero, imageTitlePadding: 4)
        shareButton.setTitleFont(AmityFontSet.bodyBold)
        
        // share
        shareLabel.textColor = AmityColorSet.base.blend(.shade2)
        shareLabel.font = AmityFontSet.caption
    }
 
    // MARK: - Perform Action
    private func performAction(action: AmityPostFooterAction) {
        delegate?.didPerformAction(self, action: action)
    }
    
}

private extension AmityPostFooterTableViewCell {
    
    @IBAction func likeTap() {
        performAction(action: .tapLike)
    }
    
    @IBAction func commentTap() {
        performAction(action: .tapComment)
    }
    
    @IBAction func shareTap() {
        performAction(action: .tapShare)
    }
    
    @IBAction func panelTap() {
        performAction(action: .tapComment)
    }
    
}

private class CommentsDisabledView: UIView {
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Comments are turned off"
        label.font = AmityFontSet.bodyBold
        label.textColor = AmityThemeManager.currentTheme.base
        return label
    }()

    init() {
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.addSubview(label)
        label.snp.makeConstraints{ make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }
    }
}
