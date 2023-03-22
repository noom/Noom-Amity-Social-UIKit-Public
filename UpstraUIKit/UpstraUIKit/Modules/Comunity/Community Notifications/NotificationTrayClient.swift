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
            getNotifications: @escaping () -> Effect<Action, Never>,
            markAllNotificationsAsRead: @escaping () -> Void,
            markNotificationAsRead: @escaping (String) -> Void,
            updateNotificationTrayUser: @escaping () -> Void,
            getNotificationTrayUser: @escaping () -> Void
        ) {
            self.getNotifications = getNotifications
            self.markAllNotificationsAsRead = markAllNotificationsAsRead
            self.markNotificationAsRead = markNotificationAsRead
            self.updateNotificationTrayUser = updateNotificationTrayUser
            self.getNotificationTrayUser = getNotificationTrayUser
        }
        
        public var getNotifications: () -> Effect<Action, Never>
        public var markAllNotificationsAsRead: () -> Void
        public var markNotificationAsRead: (String) -> Void
        public var updateNotificationTrayUser: () -> Void
        public var getNotificationTrayUser: () -> Void
    }
    
    public struct State: Equatable {
        public var notifications: [CommunityNotification]
    }
    
    public enum Action {
        case screenAppeared
        case markAllNotificationsAsRead
        case updateNotificationTrayUser
        case notificationsResponse(Result<Void, Error>)
        case notification(index: Int, action: NotificationAction)
    }
    
    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .screenAppeared:
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
