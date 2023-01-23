//
// Created by Matias Crespillo
// Copyright ® 2022 Noom, Inc. All Rights Reserved
//

import Foundation
import UIKit

public protocol NoomAmityBridgingService: AnyObject {
    func makeConnectNotificationsSettingsViewController() -> UIViewController
    func urlForUser(userId: String) -> URL?
    var notificationSettingsEnabled: Bool { get }
    var createCommunityButtonDisabled: Bool { get }
}
