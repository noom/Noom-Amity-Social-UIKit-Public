//
//  AmityAvatarView.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 29/5/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import AmitySDK
import UIKit

public enum AmityAvatarShape {
    
    /// A shape for circle
    case circle
    
    /// A shape for square
    case square
    
    /// A custom for customize shape of view
    case custom(radius: CGFloat, borderWith: CGFloat, borderColor: UIColor)
}

public enum AmityAvatarPosition {
    
    case fullSize
    
    case center
    
}

/// Amity avatar view
/// An object that displays a single image or load image from url remote resource
public final class AmityAvatarView: AmityImageView {
    
    @IBOutlet private var placeHolderWidthConstraint: NSLayoutConstraint!
    @IBOutlet private var initialsContainer: UIView!
    @IBOutlet private var initialsLabel: UILabel!
    
    /// A shape of imageView
    public var avatarShape: AmityAvatarShape = .circle {
        didSet {
            updateAvatarShape()
        }
    }
    
    public var placeholderPostion: AmityAvatarPosition = .center {
        didSet {
            updatePlaceholderConstraint()
        }
    }

    public func setEdgeColor(_ color: UIColor?) {
        layer.borderWidth = color != nil ? 2: 0
        layer.borderColor = color?.cgColor
    }
    
    // MARK: - View lifecycle
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibContent()
        setupView()
    }
    
    private func setupView() {
        // We'll hardcode to set background color of avatar
        backgroundColor = UIColor(hex: "#D9E5FC")
        avatarShape = .circle
        initialsContainer.isHidden = true
        initialsLabel.font = AmityFontSet.title
        initialsLabel.textColor = .white
        initialsLabel.text = nil
        updateAvatarShape()
        updatePlaceholderConstraint()
    }
    
    private func updateAvatarShape() {
        switch avatarShape {
        case .circle:
            layer.cornerRadius = frame.height / 2
            clipsToBounds = true
        case .square:
            layer.cornerRadius = 0
            clipsToBounds = false
        case let .custom(radius, borderWidth, borderColor):
            layer.cornerRadius = radius
            layer.borderWidth = borderWidth
            layer.borderColor = borderColor.cgColor
            clipsToBounds = true
        }
    }
    
    private func updatePlaceholderConstraint()  {
        switch placeholderPostion {
        case .center:
            placeHolderWidthConstraint.isActive = false
        case .fullSize:
            placeHolderWidthConstraint.isActive = true
        }
    }

    public override func setImage(
        withImageURL imageURL: String?,
        size: AmityMediaSize = .small,
        placeholder: UIImage? = AmityIconSet.defaultAvatar,
        completion: (() -> Void)? = nil
    ) {
        self.initialsContainer.isHidden = true
        super.setImage(
            withImageURL: imageURL,
            size: size,
            placeholder: placeholder,
            completion: completion
        )
    }

    public func displayInitials(for name: String) {
        self.initialsContainer.isHidden = false
        self.image = nil
        self.initialsLabel.text = AmityUIKitManager.initials(for: name)
        self.initialsContainer.backgroundColor = AmityUIKitManager.randomColor(for: name)
    }
    
}
