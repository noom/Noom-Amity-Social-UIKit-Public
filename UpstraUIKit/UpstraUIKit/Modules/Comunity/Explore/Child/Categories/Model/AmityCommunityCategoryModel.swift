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
    let metadata: AmityCommunityMetadata
    
    init(object: AmityCommunityCategory, communityCount: Int? = 0, metadata: [String: Any]?) {
        self.name = object.name
        self.avatarURL = object.avatar?.fileURL ?? ""
        self.categoryId = object.categoryId
        self.communityCount = communityCount ?? 0
        
        // This doesn't exist on the AmityCommunityCategory object (yet?) so we're passing it in
        //  on construction, and it's currently assuming it has the same (relevant) metadata as
        //  any random community that is in it
        self.metadata = .init(metadata)
    }
    
    func matchesUserSegment(_ userMetadata: AmityUserMetadata?) -> Bool {
        guard let userMetadata else { return false }
        let partnerId = metadata.partnerId
        return userMetadata.languages.contains(metadata.language ?? "en")
            && metadata.businessType == userMetadata.businessType
            && (partnerId == nil || partnerId == userMetadata.partnerId)
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
