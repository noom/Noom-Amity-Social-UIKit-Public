//
//  AmityTheme.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 11/6/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit

/// Interface style
enum AmityInterfaceStyle {
    case light
    case dark
}

public struct AmityTheme {
    
    // The key color reflects the mood and tones of the application
    // It will apply to interactable components, e.g., button, highlighted menu, and component background
    let primary: UIColor
    
    // The color for filling up and making the boundary of components
    // It will apply to component background, separater line, and border color
    let secondary: UIColor
    
    // The noticeable color for attacting users attention
    // It will apply to badge, remark, and destructive button
    let alert: UIColor
    
    // The color for interactable text
    // It will apply to link-type text and read more button
    let highlight: UIColor
    
    // Color for text, content and menu
    // It will apply to text components, e.g., title, subtitle, icons, and navigation item tint color
    let base: UIColor
    
    // Color for text, content and menu if its background is a primary color
    // It will apply to text components, e.g., title, subtitle, icons, and navigation item tint color
    let baseInverse: UIColor
    
    // Color for message bubble background
    // It will apply to outgoing message components
    let messageBubble: UIColor
    
    // Color for message bubble background
    // It will apply to incoming message components
    let messageBubbleInverse: UIColor

    // Color for cell spacing
    let separator: UIColor

    let unselectedToggle: UIColor

    let pollBackground: UIColor

    let pollVotedOther: UIColor

    let avatarCoachHighlight: UIColor

    let avatarWriterHighlight: UIColor

    let buttonDisabled: UIColor
    
    public init(primary: UIColor? = nil,
                secondary: UIColor? = nil,
                alert: UIColor? = nil,
                highlight: UIColor? = nil,
                base: UIColor? = nil,
                baseInverse: UIColor? = nil,
                messageBubble: UIColor? = nil,
                messageBubbleInverse: UIColor? = nil,
                separator: UIColor? = nil,
                unselectedToggle: UIColor? = nil,
                pollBackground: UIColor? = nil,
                pollVotedOther: UIColor? = nil,
                avatarCoachHighlight: UIColor? = nil,
                avatarWriterHighlight: UIColor? = nil,
                buttonDisabled: UIColor? = nil
            ) {
        self.primary = primary ?? UIColor(hex: "#1054DE")
        self.secondary = secondary ?? UIColor(hex: "#292B32")
        self.alert = alert ?? UIColor(hex: "#FA4D30")
        self.highlight = highlight ?? UIColor(hex: "#1054DE")
        self.base = base ?? UIColor(hex: "#292B32")
        self.baseInverse = baseInverse ?? .white
        self.messageBubble = messageBubble ?? UIColor(hex: "#1054DE")
        self.messageBubbleInverse = messageBubbleInverse ?? UIColor(hex: "#EBECEF")
        self.separator = separator ?? UIColor(hex: "#FFFFFF")
        self.unselectedToggle = unselectedToggle ?? UIColor.black
        self.pollBackground = pollBackground ?? UIColor(hex: "#EBECEF")
        self.pollVotedOther = pollVotedOther ?? UIColor(hex: "#292B32")
        self.avatarCoachHighlight = avatarCoachHighlight ?? UIColor(hex: "#292B32")
        self.avatarWriterHighlight = avatarWriterHighlight ?? UIColor(hex: "#292B32")
        self.buttonDisabled = buttonDisabled ?? .gray
    }
    
}
