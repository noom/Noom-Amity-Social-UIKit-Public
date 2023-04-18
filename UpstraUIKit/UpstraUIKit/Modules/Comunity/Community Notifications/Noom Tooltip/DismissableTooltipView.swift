//
// Created by Leke Abolade
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import SwiftUI

/// A default tooltip with default theming
internal struct DismissableTooltipView<Content> where Content: View {
    var title: String = ""
    @ViewBuilder var content: () -> Content

    var closeAction: () -> Void
}

extension DismissableTooltipView {
    var closeIconSize: CGSize { CGSize(width: 10, height: 10) }
    var closeIconTopPadding: CGFloat { 7 }
    var closeButtonSize: CGSize { CGSize(width: 44, height: 44) }
    var horizontalContentPadding: CGFloat { 16 }
    var verticalContentPadding: CGFloat { 8 }
    var textSpacing: CGFloat { 8 }
}

extension DismissableTooltipView: View {

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(alignment: .leading, spacing: textSpacing) {
                if !title.isEmpty {
                    Text(title)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.headline)
                        .foregroundColor(.black)
                }
                content()
            }

            Button(action: closeAction) {
                Image(systemName: "xmark")
                    .renderingMode(.template)
                    .resizable()
                    .foregroundColor(.black)
                    .frame(width: closeIconSize.width, height: closeIconSize.height)
            }
        }
        .padding(.horizontal, horizontalContentPadding)
        .padding(.vertical, verticalContentPadding)
    }
}
