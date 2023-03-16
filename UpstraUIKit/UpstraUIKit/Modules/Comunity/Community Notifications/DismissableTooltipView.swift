//
// Created by Leke Abolade
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import SwiftUI

struct DismissableTooltipView {

    var title: String = ""
    var description: String
    var closeAction: () -> Void
}

extension DismissableTooltipView {
    var closeIcon: Image { Image(systemName: "xmark") }
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
                        .font(.subheadline)
                        .foregroundColor(.black)
                }

                Text(description)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.body)
                    .foregroundColor(.black)
            }

            Button(action: closeAction) {
                ZStack(alignment: .top) {
                    Color.clear
                        .frame(width: closeButtonSize.width, height: closeButtonSize.height)

                    closeIcon
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(.black)
                        .frame(width: closeIconSize.width, height: closeIconSize.height)
                        .padding(.top, closeIconTopPadding)
                }
            }
        }
        .padding(.leading, horizontalContentPadding)
        .padding([.top, .bottom], verticalContentPadding)
    }
}
