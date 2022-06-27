//
// Created by Matias Crespillo
// Copyright ® 2022 Noom, Inc. All Rights Reserved
//

import Foundation
import UIKit

public final class AmityPostSeparatorTableViewCell: UITableViewCell, AmityPostProtocol {
    private static let height: CGFloat = 16

    public weak var delegate: AmityPostDelegate?

    // MARK: - Properties
    public private(set) var post: AmityPostModel?
    public private(set) var indexPath: IndexPath?


    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    public required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        post = nil
    }

    public func display(post: AmityPostModel, indexPath: IndexPath) {
    }

    // MARK: - Setup views
    private func setupView() {
        selectionStyle = .none
        backgroundColor = AmityThemeManager.currentTheme.separator
        contentView.backgroundColor = AmityThemeManager.currentTheme.separator
        let constraint = NSLayoutConstraint(
            item:contentView,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: AmityPostSeparatorTableViewCell.height
        )
        contentView.addConstraint(constraint)
    }

    // MARK: - Perform Action
    private func performAction(action: AmityPostAction) {
        delegate?.didPerformAction(self, action: action)
    }
}
