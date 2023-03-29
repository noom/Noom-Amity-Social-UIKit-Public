//
// Created by Leke Abolade
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import SwiftUI
import ComposableArchitecture

struct DismissableTooltipView: View {
        
    private static let closeIconSize: CGSize = CGSize(width: 10, height: 10)
    private static let closeIconTopPadding: CGFloat =  8
    private static let closeButtonSize: CGSize = CGSize(width: 44, height: 44)
    private static let horizontalContentPadding: CGFloat = 16
    private static let verticalContentPadding: CGFloat = 8
    private static let textSpacing: CGFloat = 8
    
    let store: InternalNotificationTray.Store

    var body: some View {
        WithViewStore(store) { viewstore in
            HStack(alignment: .top, spacing: 0) {

                VStack(alignment: .leading, spacing: Self.textSpacing) {
                    if !viewstore.title.isEmpty {
                        Text(viewstore.title)
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                    
                    if viewstore.notifications.isEmpty {
                       ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        ForEachStore(
                            self.store.scope(
                                state: \.notifications,
                                action: InternalNotificationTray.Action.notification(id:action:)
                            ),
                            content: NotificationContentView.init(store:)
                        )
                        
                        
                        Button {
                            viewstore.send(.markAllNotificationsAsRead)
                        } label: {
                            Text("mark all notifications as read")
                        }.frame(maxHeight: .infinity, alignment: .bottom)
                    }
                    

                }.onAppear {
                    viewstore.send(.notificationsListAppeared)
                }

                Button(action: {
                    viewstore.send(.didTapClose)
                }) {
                    ZStack(alignment: .top) {
                        Color.clear
                            .frame(
                                width: Self.closeButtonSize.width,
                                height: Self.closeButtonSize.height
                            )
                        
                        Image(systemName: "xmark")
                            .renderingMode(.template)
                            .resizable()
                            .foregroundColor(.black)
                            .frame(
                                width: Self.closeIconSize.width,
                                height: Self.closeIconSize.height
                            )
                            .padding(.top, Self.closeIconTopPadding)
                    }
                }
            }
            .frame(width: 300, height: 400)
            .padding(.leading, Self.horizontalContentPadding)
            .padding(.vertical, Self.verticalContentPadding)
        }
    }
}
