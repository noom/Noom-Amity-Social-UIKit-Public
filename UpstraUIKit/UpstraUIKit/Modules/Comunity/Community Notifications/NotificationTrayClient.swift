//
// Created by Leke Abolade
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import Foundation
import ComposableArchitecture
import RxSwift

public struct InternalNotificationTray: ReducerProtocol {
    public struct Client {
        public init(
            getNotifications: @escaping () -> EffectTask<Action>,
            markAllNotificationsAsRead: @escaping () -> EffectTask<Action>,
            markNotificationAsRead: @escaping (String) -> EffectTask<Action>,
            updateNotificationTrayUser: @escaping () -> EffectTask<Action>,
            getNotificationTrayUser: @escaping () -> EffectTask<Action>
        ) {
            self.getNotifications = getNotifications
            self.markAllNotificationsAsRead = markAllNotificationsAsRead
            self.markNotificationAsRead = markNotificationAsRead
            self.updateNotificationTrayUser = updateNotificationTrayUser
            self.getNotificationTrayUser = getNotificationTrayUser
        }
        
        public var getNotifications: () -> EffectTask<Action>
        public var markAllNotificationsAsRead: () -> EffectTask<Action>
        public var markNotificationAsRead: (String) -> EffectTask<Action>
        public var updateNotificationTrayUser: () -> EffectTask<Action>
        public var getNotificationTrayUser: () -> EffectTask<Action>
    }
    
    public struct State: Equatable {
        public var notifications: IdentifiedArrayOf<CommunityNotification>
    }
    
    public enum Action {
        case notificationsListAppeared
        case markAllNotificationsAsRead
        case updateNotificationTrayUser
        case notificationsResponse(Result<Void, Error>)
        case notification(id: CommunityNotification.ID, action: NotificationAction)
    }
    
    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .notificationsListAppeared:
            return client.getNotifications()
        case .notificationsResponse:
            return .none
        default:
            return .none
        }
    }
    
    let client: Client

    public init(client: Client) {
        self.client = client
    }
    
    public typealias Store = ComposableArchitecture.Store<State, Action>
    public typealias ViewStore = ComposableArchitecture.ViewStore<State, Action>
}
