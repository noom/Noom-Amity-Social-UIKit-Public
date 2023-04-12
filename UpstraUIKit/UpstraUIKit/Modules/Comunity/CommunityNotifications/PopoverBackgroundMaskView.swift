//
// Created by Leke Abolade
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import SwiftUI

struct PopoverBackgroundMaskView<Mask: View> {
    let sourceRect: CGRect
    @ViewBuilder let mask: () -> Mask
}

extension PopoverBackgroundMaskView where Mask == EmptyView {

    init() {
        self.sourceRect = .zero
        self.mask = { EmptyView() }
    }
}

extension PopoverBackgroundMaskView: View {

    var body: some View {
        Color.black.opacity(0.3)
            .reverseMask {
                mask()
                    .frame(width: sourceRect.width, height: sourceRect.height)
                    .position(x: sourceRect.midX, y: sourceRect.midY)
            }
            .edgesIgnoringSafeArea(.all)
    }
}

extension View {

    /// Inverse of a typical mask.
    ///
    /// The content is not masked to the shape of the view, but instead creates a cutout of the view in the content.
    func reverseMask<Mask: View>(@ViewBuilder _ mask: () -> Mask) -> some View {
        self.mask(
            ZStack {
                Rectangle()
                mask()
                    .blendMode(.destinationOut)
            }
        )
    }
}
