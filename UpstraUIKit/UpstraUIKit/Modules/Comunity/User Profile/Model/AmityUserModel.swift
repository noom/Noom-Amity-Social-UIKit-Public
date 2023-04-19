//
//  AmityUserModel.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 29/9/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import AmitySDK

struct AmityUserModel {
    public static let localeLanguageKey = "localeLanguage"
    public static let businessTypeKey = "businessType"
    public static let partnerIdKey = "partnerId"
    
    let userId: String
    let displayName: String
    let avatarURL: String
    let about: String
    let isGlobalBan: Bool
    let metadata: [String: Any]?
    
    init(user: AmityUser) {
        userId = user.userId
        displayName = user.displayName == user.userId
            ? "Noomer"
            : user.displayName ?? AmityLocalizedStringSet.General.anonymous.localizedString
        avatarURL = user.getAvatarInfo()?.fileURL ?? ""
        about = user.userDescription
        isGlobalBan = user.isGlobalBan
        metadata = user.metadata
    }
    
    var isCurrentUser: Bool {
        return userId == AmityUIKitManagerInternal.shared.client.currentUserId
    }
    
    func matchesUserSegment(_ otherUserMetadata: [String: Any]?) -> Bool {
        let language = metadata?[AmityUserModel.localeLanguageKey] as? [String] ?? []
        let otherLanguage = otherUserMetadata?[AmityUserModel.localeLanguageKey] as? [String] ?? []
        let businessType = metadata?[AmityUserModel.businessTypeKey] as? String
        let otherBusinessType = otherUserMetadata?[AmityUserModel.businessTypeKey] as? String

        return language.contains(where: { otherLanguage.contains($0) })
            && businessType == otherBusinessType
    }
}
