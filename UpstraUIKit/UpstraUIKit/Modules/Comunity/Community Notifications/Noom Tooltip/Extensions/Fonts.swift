//
// Created by Leke Abolade
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import UIKit
import SwiftUI

extension Font {
    static func noomFontRegular(ofSize size: CGFloat) -> Self {
        let uiFont = UIFont(name: "UntitledSans-Regular", size: size) ?? .systemFont(ofSize: size)
        return Font(uiFont as CTFont)
    }

    static func noomFontMedium(ofSize size: CGFloat) -> Self {
        let uiFont = UIFont(name: "UntitledSans-Medium", size: size) ?? .systemFont(ofSize: size, weight: .medium)
        return Font(uiFont as CTFont)
    }
}

extension UIFont {
    static let noomRegular = UIFont.systemFont(ofSize: 14)
    static let noomRegularBold = UIFont.systemFont(ofSize: 14, weight: .bold)
}
