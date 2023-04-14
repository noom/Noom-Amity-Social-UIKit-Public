//
// Created by Leke Abolade
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import ComposableArchitecture
import SwiftUI

struct NotificationTray: ReducerProtocol {

    let client: NotificationTrayClient
    
    struct State {
        var notifications: IdentifiedArrayOf<NotificationRow.State>
    }
    
    enum Action {
        case closeTapped
        case onFirstAppear

        case markAllNotificationsAsRead
        case notification(id: CommunityNotification.ID, action: NotificationRow.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        core
            .forEach(\.notifications, action: /Action.notification) {
                NotificationRow(client: client)
            }
    }

    private var core: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .closeTapped:
                return client.close().fireAndForget()
            case .onFirstAppear:
                return client.api.updateNotificationTrayUser().fireAndForget()

            case .markAllNotificationsAsRead:
                for index in state.notifications.indices {
                    state.notifications[index].hasRead = true
                }
                return client.api.markAllNotificationsAsRead().fireAndForget()

            case .notification:
                return .none
            }
        }
    }
}

// MARK: - UI
extension NotificationTray {

    struct View {
        let store: StoreOf<NotificationTray>
    }
}

extension NotificationTray.View: View {

    var body: some View {
        WithViewStore(store.stateless) { viewStore in
            DismissableTooltipView(title: "Notifications") {
                VStack(alignment: .leading, spacing: 8.0) {
                    ForEachStore(
                        store.scope(
                            state: \.notifications,
                            action: NotificationTray.Action.notification
                        ),
                        content: NotificationRow.View.init
                    )

                    Spacer(minLength: 0)

                    Button {
                        viewStore.send(.markAllNotificationsAsRead)
                    } label: {
                        Text("Mark all notifications as read")
                    }
                }
            } closeAction: {
                viewStore.send(.closeTapped)
            }
            .onFirstAppear {
                viewStore.send(.onFirstAppear)
            }
        }
    }
}
