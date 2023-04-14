//
//  AmityCommunityCategoryModel.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 29/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

/// Amity Community Category
public struct AmityCommunityCategoryModel {
    public let name: String
    let avatarURL: String
    public let categoryId: String
    public var communityCount: Int
    let metadata: [String: Any]?
    
    init(object: AmityCommunityCategory, communityCount: Int? = 0, metadata: [String: Any]?) {
        self.name = object.name
        self.avatarURL = object.avatar?.fileURL ?? ""
        self.categoryId = object.categoryId
        self.communityCount = communityCount ?? 0
        
        // This doesn't exist on the AmityCommunityCategory object (yet?) so we're passing it in
        //  on construction, and it's currently assuming it has the same (relevant) metadata as
        //  any random community that is in it
        self.metadata = metadata
    }
    
    func matchesUserSegment(_ comparisonMetadata: [String: Any]?) -> Bool {
        let language = metadata?[AmityUserModel.localeLanguageKey] as? String
        let otherLanguage = comparisonMetadata?[AmityUserModel.localeLanguageKey] as? [String] ?? []
        let businessType = metadata?[AmityUserModel.businessTypeKey] as? String
        let otherBusinessType = comparisonMetadata?[AmityUserModel.businessTypeKey] as? String
        let partnerId = metadata?[AmityUserModel.partnerIdKey] as? Int
        let otherPartnerId = comparisonMetadata?[AmityUserModel.partnerIdKey] as? Int
        
        return (language == nil || otherLanguage.contains(language!))
            && (businessType == nil || businessType == otherBusinessType)
            && (partnerId == nil || partnerId == otherPartnerId)
    }
}
