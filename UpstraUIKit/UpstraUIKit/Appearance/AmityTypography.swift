//
//  AmityTypography.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 10/6/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit

// Note
// See more:
// https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/typography/
// https://uxdesign.cc/a-five-minute-guide-to-better-typography-for-ios-4e3c2715ceb4
// https://docs.sendbird.com/ios/ui_kit_themes#3_fontset_4_customize_font

public struct AmityTypography {
    
    let headerLine: UIFont
    let title: UIFont
    let bodyBold: UIFont
    let body: UIFont
    let captionBold: UIFont
    let caption: UIFont
    let postHeaderAuxiliary: UIFont
    let postHeaderCommunityName: UIFont
    let postHeaderRoleName: UIFont
    
    public init(headerLine: UIFont = .systemFont(ofSize: 20, weight: .bold),
                title: UIFont = .systemFont(ofSize: 17, weight: .semibold),
                bodyBold: UIFont = .systemFont(ofSize: 15, weight: .semibold),
                body: UIFont = .systemFont(ofSize: 15, weight: .regular),
                captionBold: UIFont = .systemFont(ofSize: 13, weight: .semibold),
                caption: UIFont = .systemFont(ofSize: 13, weight: .regular),
                postHeaderAuxiliary: UIFont = .systemFont(ofSize: 12, weight: .regular),
                postHeaderCommunityName: UIFont = .systemFont(ofSize: 12, weight: .regular),
                postHeaderRoleName: UIFont = .systemFont(ofSize: 10, weight: .regular)
    ) {
        self.headerLine = headerLine
        self.title = title
        self.bodyBold = bodyBold
        self.body = body
        self.captionBold = captionBold
        self.caption = caption
        self.postHeaderAuxiliary = postHeaderAuxiliary
        self.postHeaderCommunityName = postHeaderCommunityName
        self.postHeaderRoleName = postHeaderRoleName
    }
}

public class AmityFontSet {
    
    static private(set) var currentTypography: AmityTypography = AmityTypography()
    
    static func set(typography: AmityTypography) {
        currentTypography = typography
    }
    
    public static var headerLine: UIFont {
        return currentTypography.headerLine
    }
    
    public static var title: UIFont {
        return currentTypography.title
    }
    
    public static var bodyBold: UIFont {
        return currentTypography.bodyBold
    }
    
    public static var body: UIFont {
        return currentTypography.body
    }
    
    public static var captionBold: UIFont {
        return currentTypography.captionBold
    }
    
    public static var caption: UIFont {
        return currentTypography.caption
    }

    public static var postHeaderAuxiliary: UIFont {
        return currentTypography.postHeaderAuxiliary
    }

    public static var postHeaderCommunityName: UIFont {
        return currentTypography.postHeaderCommunityName
    }

    public static var postHeaderRoleName: UIFont {
        return currentTypography.postHeaderRoleName
    }
    
}
