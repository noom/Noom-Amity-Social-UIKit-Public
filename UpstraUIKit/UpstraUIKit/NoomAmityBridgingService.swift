//
// Created by Matias Crespillo
// Copyright ® 2022 Noom, Inc. All Rights Reserved
//

import Foundation
import UIKit

public protocol NoomAmityBridgingService: AnyObject {
    func makeConnectNotificationsSettingsViewController() -> UIViewController
    var notificationSettingsEnabled: Bool { get }
}
