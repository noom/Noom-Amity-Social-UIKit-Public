//
// Created by Leke Abolade
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import Foundation
import ComposableArchitecture
import RxSwift

struct InternalNotificationTray: ReducerProtocol {
    
    struct State: Equatable {
        var notifications: IdentifiedArrayOf<CommunityNotification>
        var title: String
    }
    
    enum Action {
        case notificationsListAppeared
        case markAllNotificationsAsRead
        case didTapClose
        case notification(id: CommunityNotification.ID, action: NotificationFeature.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce(businessLogic)
            .forEach(\.notifications, action: /Action.notification) {
                NotificationFeature(
                    markNotificationAsRead: client.markNotificationAsRead,
                    openNotification: openNotification
                )
            }
    }
    
    func businessLogic(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .notificationsListAppeared:
            return client.updateNotificationTrayUser().fireAndForget()
        case .markAllNotificationsAsRead:
            for index in state.notifications.indices {
                state.notifications[index].hasRead = true
            }
            return client.markAllNotificationsAsRead().fireAndForget()
        case .notification:
            return .none
        case .didTapClose:
            return .fireAndForget(closeAction)
        }
    }
    
    let client: NotificationTrayClient
    let closeAction: () -> Void
    let openNotification: (NotificationFeature.PostId) -> Void

    init(client: NotificationTrayClient, closeAction: @escaping () -> Void, openNotification: @escaping (NotificationFeature.PostId) -> Void) {
        self.client = client
        self.closeAction = closeAction
        self.openNotification = openNotification
    }
}

