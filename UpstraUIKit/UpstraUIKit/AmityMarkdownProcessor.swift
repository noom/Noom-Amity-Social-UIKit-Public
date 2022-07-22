//
//  AmityMarkdownProcessor.swift
//  AmityUIKit
//
//  Created by Matias Crespillo on 7/20/22.
//  Copyright © 2022 Amity. All rights reserved.
//

import Foundation

public protocol AmityMarkdownProcessor {
    func attributedText(from: String) -> NSAttributedString
}
