//
// Created by Ilya Panchenko
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import Foundation
import AmitySDK

/// Shared between multiple models' metadata dictionaries
struct MetadataKey {
    static let localeLanguage = "localeLanguage"
    static let businessType = "businessType"
    static let partnerId = "partnerId"
}

struct AmityUserMetadata {
    var languages: [String] = []
    var businessType: BusinessType?
    var partnerId: String?

    init(from dict: [String: Any]?) {
        self.languages = dict?[MetadataKey.localeLanguage] as? [String] ?? []
        self.businessType = (dict?[MetadataKey.businessType] as? String).flatMap(BusinessType.init(rawValue:))
        self.partnerId = dict?[MetadataKey.partnerId] as? String
    }
}

// MARK: BusinessType

enum BusinessType: String {
    case b2b = "B2B"
    case b2c = "B2C"
    case test = "TEST"
}
