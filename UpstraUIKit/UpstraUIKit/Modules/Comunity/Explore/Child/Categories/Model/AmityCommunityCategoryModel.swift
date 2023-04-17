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
        let language = metadata?[AmityUserModel.localeLanguageKey] as? String ?? "en"
        let otherLanguage = comparisonMetadata?[AmityUserModel.localeLanguageKey] as? [String] ?? []
        let businessType = metadata?[AmityUserModel.businessTypeKey] as? String
        let otherBusinessType = comparisonMetadata?[AmityUserModel.businessTypeKey] as? String
        let partnerId = metadata?[AmityUserModel.partnerIdKey] as? Int
        let otherPartnerId = comparisonMetadata?[AmityUserModel.partnerIdKey] as? Int
        
        return otherLanguage.contains(language)
            && businessType == otherBusinessType
            && (partnerId == nil || partnerId == otherPartnerId)
    }
    
    static func from(category: AmityCommunityCategory, communityList: AmityCollection<AmityCommunity>) -> AmityCommunityCategoryModel? {
        let communityCount = communityList.count()

        // We can only determine if a category can be shown or not if we have metadata for it, and we
        //  can only approximate metadata for it if we have at least one community, so let's just not
        //  show any categories without communities (at least on iOS).
        if communityCount > 0, let firstCommunity = communityList.object(at: 0) {
            return AmityCommunityCategoryModel(
                object: category,
                communityCount: Int(communityCount),
                // The metadata parameter doesn't exist on the AmityCommunityCategory object (yet?) so
                //  we're passing it in on construction, and we're just going to assume it has the same
                //  (relevant) metadata as any random community that is in it
                metadata: firstCommunity.metadata
            )
        } else {
            return nil
        }
    }
}
