//
// Created by Leke Abolade
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import Foundation

struct PopoverAttributes {
    var allowTapOutsideToDismiss: Bool = true
    var onTapOutside: (() -> Void)?
    var onDismiss: (() -> Void)?
    var popoverPermittedArrowDirection: UIPopoverArrowDirection
    var popoverLayoutMargins: UIEdgeInsets = .zero
    var sourceRectInsets: UIEdgeInsets = .zero
    
    init(
        allowTapOutsideToDismiss: Bool = true,
        onTapOutside: (() -> Void)? = nil,
        onDismiss: (() -> Void)? = nil,
        popoverPermittedArrowDirection: UIPopoverArrowDirection = .any,
        sourceRectInsets: UIEdgeInsets = .zero
    ) {
        self.allowTapOutsideToDismiss = allowTapOutsideToDismiss
        self.onTapOutside = onTapOutside
        self.onDismiss = onDismiss
        self.popoverPermittedArrowDirection = popoverPermittedArrowDirection
        self.sourceRectInsets = sourceRectInsets
    }
}
