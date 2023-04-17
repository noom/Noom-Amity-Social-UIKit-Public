//
// Created by Leke Abolade
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import SwiftUI
import ComposableArchitecture

extension UIViewController {
    /// Presents a tooltip with a close action.
    /// - Parameters:
    ///   - theme: Used to theme the tooltip and the background overlay.
    ///   - anchorItem: The BarButtonItem from which the popover will anchor itself. The arrow of the popover will touch the view at any of the permitted arrow direction points.
    ///   - title: An optional title for the tooltip. If nil, the tooltips height will adjust by removing this element.
    ///   - popoverAttributes: Popover attributes are used to customise the popover's properties.
    ///   - onDidClose: This block is triggered after the tooltip is dismissed by the user.
    func presentNavbarTooltip(
        anchorItem: UIBarButtonItem,
        client: NotificationTrayClient
    ) {
        presentPopover(
            anchorItem: anchorItem,
            attributes: .init(),
            content: {
                NotificationTray.View(
                    store: .init(
                        initialState: .init(
                            notifications: IdentifiedArray(
                                uniqueElements: []
                            )
                        ),
                        reducer: NotificationTray(client: client)
                    )
                )
            },
            background: { _ in
                PopoverBackgroundMaskView()
            }
        )
    }
    
    /// Presents a popover with a background.
    /// - Parameters:
    ///   - theme: The theme is used to decode the popover color from the attributes and passes it the content and background's environtment.
    ///   - anchorItem: The BarButtonItem from which the popover will anchor itself. The arrow of the popover will touch the view at any of the permitted arrow direction points.
    ///   - attributes: Attributes are used to customise the popover's properties.
    ///   - content: The content of the popover that will be presented.
    ///   - background: The background will be placed between the anchor view and the popover. Has access to the full `UIScreen.bounds`
    func presentPopover<Content: View, Background: View>(
        anchorItem: UIBarButtonItem,
        attributes: PopoverAttributes = .init(),
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder background: @escaping (CGRect) -> Background
    ) {
        guard
            let controller = makePopoverController(
                attributes: attributes,
                content: content,
                background: background
            ),
            let popover = controller.popoverPresentationController
        else { return }
        popover.barButtonItem = anchorItem
        if attributes.sourceRectInsets != .zero {
            popover.sourceRect = anchorItem.frameInWindow().inset(by: attributes.sourceRectInsets)
        }
        present(controller, animated: true, completion: nil)
    }
    
    func makePopoverController<Content: View, Background: View>(
        attributes: PopoverAttributes = .init(),
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder background: @escaping (CGRect) -> Background
    ) -> UIViewController? {
        let contentController = PopoverContentViewController(
            rootView: content(),
            backgroundController: PopoverBackgroundViewController(background: { sourceRect in
                background(sourceRect)
            }),
            isPresented: .constant(false),
            attributes: attributes
        )

        let compressedController = CompressedSizeController(contentViewController: contentController)
        compressedController.modalPresentationStyle = .popover

        guard let popover = compressedController.popoverPresentationController else { return nil }
        popover.delegate = contentController
        popover.permittedArrowDirections = attributes.popoverPermittedArrowDirection
        popover.popoverLayoutMargins = attributes.popoverLayoutMargins

        return compressedController
    }
}
