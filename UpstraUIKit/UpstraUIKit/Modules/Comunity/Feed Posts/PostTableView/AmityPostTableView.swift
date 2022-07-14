//
//  AmityPostTableView.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 2/15/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit

protocol AmityPostTableViewDelegate: AnyObject {
    func tableView(_ tableView: AmityPostTableView, didSelectRowAt indexPath: IndexPath)
    func tableView(_ tableView: AmityPostTableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    func tableView(_ tableView: AmityPostTableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    func tableView(_ tableView: AmityPostTableView, heightForHeaderInSection section: Int) -> CGFloat
    func tableView(_ tableView: AmityPostTableView, heightForFooterInSection section: Int) -> CGFloat
    func tableView(_ tableView: AmityPostTableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    func tableView(_ tableView: AmityPostTableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
    func tableView(_ tableView: AmityPostTableView, viewForFooterInSection section: Int) -> UIView?
    func tableView(_ tableView: AmityPostTableView, didStartImpressionOn posts: [AmityPostModel])
    func impressionStopped(for tableView: AmityPostTableView)
}
extension AmityPostTableViewDelegate {
    func tableView(_ tableView: AmityPostTableView, didSelectRowAt indexPath: IndexPath) { }
    func tableView(_ tableView: AmityPostTableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return UITableView.automaticDimension }
    func tableView(_ tableView: AmityPostTableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat { return UITableView.automaticDimension }
    func tableView(_ tableView: AmityPostTableView, heightForHeaderInSection section: Int) -> CGFloat { return UITableView.automaticDimension }
    func tableView(_ tableView: AmityPostTableView, heightForFooterInSection section: Int) -> CGFloat { return UITableView.automaticDimension }
    func tableView(_ tableView: AmityPostTableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { }
    func tableView(_ tableView: AmityPostTableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) { }
    func tableView(_ tableView: AmityPostTableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}

protocol AmityPostTableViewDataSource: AnyObject {
    func numberOfSections(in tableView: AmityPostTableView) -> Int
    func tableView(_ tableView: AmityPostTableView, numberOfRowsInSection section: Int) -> Int
    func tableView(_ tableView: AmityPostTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
}

final class AmityPostTableView: UITableView, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    // Internal Delegate
    weak var postDelegate: AmityPostTableViewDelegate?
    // Internal DataSource
    weak var postDataSource: AmityPostTableViewDataSource?
    
    // Feed Delegate
    weak var feedDelegate: AmityFeedDelegate?
    // Feed DataSource
    weak var feedDataSource: AmityFeedDataSource?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupDelegateAndDataSource()
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupDelegateAndDataSource()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDelegateAndDataSource()
    }
    
    private func setupDelegateAndDataSource() {
        feedDelegate = AmityFeedUISettings.shared.delegate
        feedDataSource = AmityFeedUISettings.shared.dataSource
        delegate = self
        dataSource = self
    }
    
    // Register custom cell
    func registerCustomCell() {
        AmityFeedUISettings.shared.customNib.forEach { register($0.nib, forCellReuseIdentifier: $0.identifier) }
        AmityFeedUISettings.shared.customCellClass.forEach { register($0.cellClass.self, forCellReuseIdentifier: $0.identifier) }
    }
    
    // These cell are default post cell
    func registerPostCell() {
        register(cell: AmityPostHeaderTableViewCell.self)
        register(cell: AmityPostFooterTableViewCell.self)
        register(cell: AmityPostPreviewCommentTableViewCell.self)
        register(cell: AmityPostTextTableViewCell.self)
        register(cell: AmityPostGalleryTableViewCell.self)
        register(cell: AmityPostFileTableViewCell.self)
        register(cell: AmityPostLiveStreamTableViewCell.self)
        register(cell: AmityPostPlaceHolderTableViewCell.self)
        register(cell: AmityPostViewAllCommentsTableViewCell.self)
        register(cell: AmityPostPollTableViewCell.self)
        register(
            AmityPostSeparatorTableViewCell.self,
            forCellReuseIdentifier: AmityPostSeparatorTableViewCell.amityIdentifier
        )
    }
    
    
    // MARK: - Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        postDelegate?.tableView(self, didSelectRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return postDelegate?.tableView(self, heightForRowAt: indexPath) ?? UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return postDelegate?.tableView(self, estimatedHeightForRowAt: indexPath) ?? UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return postDelegate?.tableView(self, heightForHeaderInSection: section) ?? UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return postDelegate?.tableView(self, heightForFooterInSection: section) ?? UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        postDelegate?.tableView(self, willDisplay: cell, forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        postDelegate?.tableView(self, didEndDisplaying: cell, forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return postDelegate?.tableView(self, viewForFooterInSection: section)
    }
    
    // MARK: - DatSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return postDataSource?.numberOfSections(in: self) ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postDataSource?.tableView(self, numberOfRowsInSection: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return postDataSource?.tableView(self, cellForRowAt: indexPath) ?? UITableViewCell()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        startTrackingImpression()
    }

    func startTrackingImpression() {
        let visiblePosts = self.visibleCells
            .compactMap({ cell -> AmityPostModel? in
                guard cell.isMainPostCell(),
                      cell.isFullyVisible(within: self) else {
                    return nil
                }
                return cell.cellPost()
            })
        postDelegate?.tableView(
            self,
            didStartImpressionOn: visiblePosts
        )
    }
    func stopTracking() {
        postDelegate?.impressionStopped(for: self)
    }
}

extension UITableViewCell {
    func cellPost() -> AmityPostModel? {
        switch self.self {
        case is AmityPostTextTableViewCell:
            return (self as? AmityPostTextTableViewCell)?.post
        case is AmityPostFileTableViewCell:
            return (self as? AmityPostFileTableViewCell)?.post
        case is AmityPostGalleryTableViewCell:
            return (self as? AmityPostGalleryTableViewCell)?.post
        case is AmityPostPollTableViewCell:
            return (self as? AmityPostPollTableViewCell)?.post
        default:
            return nil
        }
    }

    func isMainPostCell() -> Bool {
        return self.isKind(of: AmityPostTextTableViewCell.self)
        || self.isKind(of: AmityPostFileTableViewCell.self)
        || self.isKind(of: AmityPostGalleryTableViewCell.self)
        || self.isKind(of: AmityPostPollTableViewCell.self)
    }

    func isFullyVisible(within tableView: UITableView) -> Bool {
        guard let indexPath = tableView.indexPath(for: self) else {
            return false
        }

        let cellRect = tableView.rectForRow(at: indexPath)
        let bounds = tableView.bounds
        let insets = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: bounds.height * 0.2,
            right: 0
        )
        let insetBounds = tableView.bounds.inset(by: insets)
        let intersection = insetBounds.intersection(cellRect)
        return intersection.height > cellRect.height / 2.0
    }
}
