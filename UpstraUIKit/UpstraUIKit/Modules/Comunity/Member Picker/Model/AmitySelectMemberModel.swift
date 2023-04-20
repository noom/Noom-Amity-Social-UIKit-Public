//
//  AmitySelectMemberModel.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 30/8/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

public final class AmitySelectMemberModel: Equatable {
    
    public static func == (lhs: AmitySelectMemberModel, rhs: AmitySelectMemberModel) -> Bool {
        return lhs.userId == rhs.userId
    }
    
    public let userId: String
    public let displayName: String?
    public var email = String()
    public var isSelected: Bool = false
    public let avatarURL: String
    public let defaultDisplayName: String = AmityLocalizedStringSet.General.anonymous.localizedString
    let metadata: AmityUserMetadata
    public var isCurrnetUser: Bool {
        return userId == AmityUIKitManagerInternal.shared.client.currentUserId
    }
    
    init(object: AmityUser) {
        self.userId = object.userId
        self.displayName = object.displayName == object.userId ? "Noomer" : object.displayName
        if let metadata = object.metadata {
            self.email = metadata["email"] as? String ?? ""
        }
        self.avatarURL = object.getAvatarInfo()?.fileURL ?? ""
        self.metadata = .init(object.metadata)
    }
    
    init(object: AmityCommunityMembershipModel) {
        self.userId = object.userId
        self.displayName = object.displayName
        self.avatarURL = object.avatarURL
        // Not needed because we don't filter members already in a community
        self.metadata = .init(nil)
    }
    
    init(object: AmityChannelMembershipModel) {
        self.userId = object.userId
        self.displayName = object.displayName
        self.avatarURL = object.avatarURL
        // Not needed because we're not using channels
        self.metadata = .init(nil)
    }
}
