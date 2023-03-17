//
// Created by Leke Abolade
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import Foundation

struct NotificationTrayClient {
  var getNotifications: (String) -> [CommunityNotification]
  var lastRead: Date
}
