//
// Created by Leke Abolade
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import Foundation
import ComposableArchitecture
import RxSwift

public struct NotificationTrayClient {
    public init(
        getNotifications: @escaping () -> EffectTask<Result<[CommunityNotification], Error>>,
        markAllNotificationsAsRead: @escaping () -> EffectTask<Void>,
        markNotificationAsRead: @escaping (String) -> EffectTask<Void>,
        updateNotificationTrayUser: @escaping () -> EffectTask<Void>,
        getNotificationTrayUser: @escaping () -> EffectTask<Result<NotificationTrayUser, Error>>
    ) {
        self.getNotifications = getNotifications
        self.markAllNotificationsAsRead = markAllNotificationsAsRead
        self.markNotificationAsRead = markNotificationAsRead
        self.updateNotificationTrayUser = updateNotificationTrayUser
        self.getNotificationTrayUser = getNotificationTrayUser
    }
    
    public var getNotifications: () -> EffectTask<Result<[CommunityNotification], Error>>
    public var markAllNotificationsAsRead: () -> EffectTask<Void>
    public var markNotificationAsRead: (String) -> EffectTask<Void>
    public var updateNotificationTrayUser: () -> EffectTask<Void>
    public var getNotificationTrayUser: () -> EffectTask<Result<NotificationTrayUser, Error>>
}

struct ParentClient {
    let apiClient: NotificationTrayClient
    public var openNotification: () -> EffectTask<Void>
}

extension ParentClient {
    
}
