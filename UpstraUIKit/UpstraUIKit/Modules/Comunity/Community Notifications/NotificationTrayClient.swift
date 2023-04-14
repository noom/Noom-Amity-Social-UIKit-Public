//
// Created by Leke Abolade
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import Foundation
import ComposableArchitecture
import RxSwift

public struct NotificationTrayAPIClient {
    public init(
        getNotifications: @escaping GetNotifications,
        markAllNotificationsAsRead: @escaping MarkAllNotificationsAsRead,
        markNotificationAsRead: @escaping MarkNotificationAsRead,
        updateNotificationTrayUser: @escaping UpdateNotificationTrayUser,
        getNotificationTrayUser: @escaping GetNotificationTrayUser
    ) {
        self.getNotifications = getNotifications
        self.markAllNotificationsAsRead = markAllNotificationsAsRead
        self.markNotificationAsRead = markNotificationAsRead
        self.updateNotificationTrayUser = updateNotificationTrayUser
        self.getNotificationTrayUser = getNotificationTrayUser
    }

    public typealias GetNotifications = () -> EffectTask<Result<[CommunityNotification], Error>>
    public var getNotifications: GetNotifications

    public typealias MarkAllNotificationsAsRead = () -> EffectTask<Void>
    public var markAllNotificationsAsRead: MarkAllNotificationsAsRead

    public typealias MarkNotificationAsRead = (String) -> EffectTask<Void>
    public var markNotificationAsRead: (String) -> EffectTask<Void>

    public typealias UpdateNotificationTrayUser = () -> EffectTask<Void>
    public var updateNotificationTrayUser: () -> EffectTask<Void>

    public struct User: Codable {
        let accessCode: String
        let lastViewed: String
    }
    public typealias GetNotificationTrayUser = () -> EffectTask<Result<User, Error>>
    public var getNotificationTrayUser: () -> EffectTask<Result<User, Error>>
}

struct NotificationTrayClient {
    var api: NotificationTrayAPIClient

    var close: () -> EffectTask<Void>
    var openNotification: (String) -> EffectTask<Void>
}
