//
// Created by Ilya Panchenko
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import Foundation

/// Strongly-type read wrapper around `AmityCommunity`'s `metadata` dictionary.
struct AmityCommunityMetadata {
    private let dict: [String: Any]?

    init(_ metadata: [String : Any]?) {
        self.dict = metadata
    }

    var language: String? {
        return dict?[AmityUserModel.localeLanguageKey] as? String
    }

    var businessType: BusinessType? {
        return (dict?[AmityUserModel.businessTypeKey] as? String).flatMap(BusinessType.init(rawValue:))
    }

    var partnerId: Int? {
        return dict?[AmityUserModel.partnerIdKey] as? Int
    }

    var isAnonymous: Bool? {
        return dict?[AmityCommunityModel.anonymousKey] as? Bool
    }
}

// MARK: User Segment Matching

extension AmityCommunityMetadata {
    func matchesUserSegment(_ userMetadata: AmityUserMetadata?) -> Bool {
        guard let userMetadata else {
            return false
        }
        return userMetadata.languages.contains(language ?? "en")
            && businessType == userMetadata.businessType
            && (partnerId == nil || partnerId == userMetadata.partnerId)
    }
}
