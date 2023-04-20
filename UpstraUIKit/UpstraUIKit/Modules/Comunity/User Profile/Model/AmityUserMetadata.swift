//
// Created by Ilya Panchenko
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import Foundation

/// Strongly-type read wrapper around `AmityUser`'s `metadata` dictionary.
struct AmityUserMetadata {
    private let dict: [String: Any]?

    init(_ metadata: [String: Any]?) {
        self.dict = metadata
    }

    var languages: [String] {
        return dict?[AmityUserModel.localeLanguageKey] as? [String] ?? []
    }

    var businessType: BusinessType? {
        return (dict?[AmityUserModel.businessTypeKey] as? String).flatMap(BusinessType.init(rawValue:))
    }

    var partnerId: Int? {
        return dict?[AmityUserModel.partnerIdKey] as? Int
    }
}

// MARK: Metadata Matching

extension AmityUserMetadata {
    func matches(_ other: AmityUserMetadata) -> Bool {
        return languages.contains(where: { other.languages.contains($0) })
            && businessType == other.businessType
            // partnerId not compared on purpose
    }
}

// MARK: Convenience Extensions

import AmitySDK

extension AmityObject<AmityUser> {
    var metadata: AmityUserMetadata {
        return .init(object?.metadata)
    }
}
