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
    public var markNotificationAsRead: MarkNotificationAsRead

    public typealias UpdateNotificationTrayUser = () -> EffectTask<Void>
    public var updateNotificationTrayUser: UpdateNotificationTrayUser

    public struct User {
        let accessCode: String
        let lastViewed: Date
    }
    public typealias GetNotificationTrayUser = () -> EffectTask<Result<User, Error>>
    public var getNotificationTrayUser: GetNotificationTrayUser
}

struct NotificationTrayClient {
    var api: NotificationTrayAPIClient

    var close: () -> EffectTask<Void>
    var openNotification: (CommunityNotification.PostID) -> EffectTask<Void>
}

extension NotificationTrayAPIClient.User: Decodable {

    private enum CodingKeys: String, CodingKey {
        case accessCode = "userAccessCode"
        case lastViewed
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessCode = try container.decode(String.self, forKey: .accessCode)
        let lastViewedString = try? container.decode(String.self, forKey: .lastViewed)
        lastViewed = lastViewedString.flatMap { ISO8601DateFormatter.iso8601Full.date(from: $0) } ?? Date()
    }
}
