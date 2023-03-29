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
            markNotificationAsRead: @escaping (String) -> EffectTask<NotificationFeature.Action>,
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
        public var markNotificationAsRead: (String) -> EffectTask<NotificationFeature.Action>
        public var updateNotificationTrayUser: () -> EffectTask<Action>
        public var getNotificationTrayUser: () -> EffectTask<Action>
    }
    
    public struct State: Equatable {
        public var notifications: IdentifiedArrayOf<CommunityNotification>
        public var title: String
    }
    
    public enum Action {
        case notificationsListAppeared
        case markAllNotificationsAsRead
        case updateNotificationTrayUser
        case didTapClose
        case notificationsClientResponse(Result<Void, Error>)
        case getNotificationsResponse(Result<[CommunityNotification], Error>)
        case getNotificationUserResponse(Result<NotificationTrayUser,Error>)
        case notification(id: CommunityNotification.ID, action: NotificationFeature.Action)
    }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce(businessLogic)
            .forEach(\.notifications, action: /Action.notification) { NotificationFeature(markNotificationAsRead: client.markNotificationAsRead) }
    }
    
    public func businessLogic(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .notificationsListAppeared:
            return client.getNotifications()
        case .markAllNotificationsAsRead:
            for i in (0..<state.notifications.count) {
                state.notifications[i].hasRead = true
            }
            return client.markAllNotificationsAsRead()
        case .notification:
            return .none
        case .didTapClose:
            return .fireAndForget(closeAction)
        case .updateNotificationTrayUser:
            return client.updateNotificationTrayUser()
        case .getNotificationsResponse(.failure(let error)):
            print(error)
            return .none
        case .getNotificationsResponse(.success(let notifications)):
                state.notifications = IdentifiedArray(uniqueElements: notifications)
            return .none
        case .getNotificationUserResponse(let response):
            return .none
        case .notificationsClientResponse:
            return .none
        }
    }
    
    let client: Client
    let closeAction: () -> Void

    public init(client: Client, closeAction: @escaping () -> Void) {
        self.client = client
        self.closeAction = closeAction
    }
    
    public typealias Store = ComposableArchitecture.Store<State, Action>
    public typealias ViewStore = ComposableArchitecture.ViewStore<State, Action>
}

