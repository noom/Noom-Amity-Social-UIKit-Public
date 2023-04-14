//
//  AmityCommunityCategoryController.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 2/24/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityCommunityCategoryControllerProtocol {
    func retrieve(_ completion: ((Result<[AmityCommunityCategoryModel], AmityError>) -> Void)?)
}

final class AmityCommunityCategoryController: AmityCommunityCategoryControllerProtocol {
    
    private let repository = AmityCommunityRepository(client: AmityUIKitManagerInternal.shared.client)
    private var collection: AmityCollection<AmityCommunityCategory>?
    private var token: AmityNotificationToken?
    private let maxCategories: UInt = 8
    
    func retrieve(_ completion: ((Result<[AmityCommunityCategoryModel], AmityError>) -> Void)?) {
        collection = repository.getCategories(sortBy: .displayName, includeDeleted: false)
        token = collection?.observe { [weak self] (collection, change, error) in
            DispatchQueue.main.async {
                if collection.dataStatus == .fresh {
                    guard let strongSelf = self else { return }
                    if let error = AmityError(error: error) {
                        completion?(.failure(error))
                    } else {
                        completion?(.success(strongSelf.prepareDataSource()))
                    }
                } else {
                    completion?(.failure(AmityError(error: error) ?? .unknown))
                }
            }
        }
    }
    
    // MIKE_REF
    private func prepareDataSource() -> [AmityCommunityCategoryModel] {
        guard let collection = collection else { return [] }
        var category: [AmityCommunityCategoryModel] = []
        for index in 0..<min(collection.count(), maxCategories) {
            guard let object = collection.object(at: index) else { continue }
            let communities = self.repository
                .getCommunities(
                    displayName: nil,
                    filter: .all,
                    sortBy: .displayName,
                    categoryId: object.categoryId,
                    includeDeleted: false
                )
            let communityCount = communities.count()
            
            // We can only determine if a category can be shown or not if we have metadata for it, and we
            //  can only approximate metadata for it if we have at least one community, so let's just not
            //  show any categories without communities (at least on iOS).
            if (communityCount > 0) {
                let model = AmityCommunityCategoryModel(
                    object: object,
                    communityCount: Int(communityCount),
                    // The metadata parameter doesn't exist on the AmityCommunityCategory object (yet?) so
                    //  we're passing it in on construction, and we're just going to assume it has the same
                    //  (relevant) metadata as any random community that is in it
                    metadata: communities.object(at: 0)!.metadata
                )
                category.append(model)
            }
        }
        return category
    }

}
