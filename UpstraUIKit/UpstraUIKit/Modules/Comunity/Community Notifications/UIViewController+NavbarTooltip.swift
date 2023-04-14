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
                                uniqueElements: self.getMockNotifications().map(NotificationRow.State.init)
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
    
    private func getMockNotifications() -> [CommunityNotification] {
        let json = """
            {
                "result": [
                    {
                        "id": "b7c2d2f6-4f2c-4b53-a251-309c9eb6b260",
                        "description": "Elwin Larkin commented on your post.",
                        "userAccessCode": "8GNTYDFG",
                        "imageUrl": "",
                        "read": true,
                        "path": "https://community.test.wsli.dev/community/62e9a2058dde5a00db8f0d81/post/6421befa023ff60a8109c283/comment/6421bf25cc1efe78a4b02a0c",
                        "actors": [
                            {
                                "userAccessCode": "HBNCAW8B",
                                "name": "Elwin Larkin",
                                "avatarUrl": ""
                            }
                        ],
                        "sourceId": "6421bf25cc1efe78a4b02a0c",
                        "sourceType": "COMMENT",
                        "serverTimeUpdated": "2023-03-27T16:07:02.299474Z"
                    },
                    {
                        "id": "0e2a74f0-f544-4afa-831e-08db36809bec",
                        "description": "Elwin Larkin reacted to your post.",
                        "userAccessCode": "8GNTYDFG",
                        "imageUrl": "",
                        "read": true,
                        "path": "https://community.test.wsli.dev/community/62e9a2058dde5a00db8f0d81/post/6421befa023ff60a8109c283",
                        "actors": [
                            {
                                "userAccessCode": "HBNCAW8B",
                                "name": "Elwin Larkin",
                                "avatarUrl": ""
                            }
                        ],
                        "sourceId": "6421befa023ff60a8109c283",
                        "sourceType": "POST",
                        "serverTimeUpdated": "2023-03-27T16:06:51.344958Z"
                    },
                    {
                        "id": "56f1bfc3-f56b-4edf-85d6-a25f48226ad3",
                        "description": "Elwin Larkin mentioned you in a comment.",
                        "userAccessCode": "8GNTYDFG",
                        "imageUrl": "",
                        "read": true,
                        "path": "https://community.test.wsli.dev/community/62e9a37dcc489500d965db40/post/63f7e18095e7a2313255bc65/comment/6421bec77770a54b724ab5f1",
                        "actors": [
                            {
                                "userAccessCode": "HBNCAW8B",
                                "name": "Elwin Larkin",
                                "avatarUrl": ""
                            }
                        ],
                        "sourceId": "6421bec77770a54b724ab5f1",
                        "sourceType": "COMMENT",
                        "serverTimeUpdated": "2023-03-27T16:05:37.552802Z"
                    }
                ]
            }
        """
        let jsonData = Data(json.utf8)
        let decoder = JSONDecoder()
        struct NotificationsResponse: Codable {
            var result: [CommunityNotification]
            var nextPageUrl: String?
            var previousPageUrl: String?
        }
        
        do {
            let response = try decoder.decode(NotificationsResponse.self, from: jsonData)
            return (response.result)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}
