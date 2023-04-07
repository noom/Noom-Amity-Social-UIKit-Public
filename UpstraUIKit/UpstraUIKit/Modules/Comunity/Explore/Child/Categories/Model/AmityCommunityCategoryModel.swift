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
    
    init(object: AmityCommunityCategory, communityCount: Int? = 0) {
        self.name = object.name
        self.avatarURL = object.avatar?.fileURL ?? ""
        self.categoryId = object.categoryId
        self.communityCount = communityCount ?? 0
        
        self.metadata = [:]
    }
    
    func matchesUserSegment(_ comparisonMetadata: [String: Any]?) -> Bool {
        let language = metadata?["localeLanguage"] as? String
        let otherLanguage = comparisonMetadata?["localeLanguage"] as? [String] ?? []
        let businessType = metadata?["businessType"] as? String
        let otherBusinessType = comparisonMetadata?["businessType"] as? String
        let partnerId = metadata?["partnerId"] as? Int
        let otherPartnerId = comparisonMetadata?["partnerId"] as? Int
        
        return (language == nil || otherLanguage.contains(language!))
            && (businessType == nil || businessType == otherBusinessType)
            && (partnerId == nil || partnerId == otherPartnerId)
    }
}
