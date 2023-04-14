//
//  AmityCategoryListScreenViewModel.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 24/9/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import AmitySDK

class AmityCategoryListScreenViewModel: AmityCategoryListScreenViewModelType {
    
    weak var delegate: AmityCategoryListScreenViewModelDelegate?
    
    private let categoryRepository = AmityCommunityRepository(client: AmityUIKitManagerInternal.shared.client)
    private var categoryCollection: AmityCollection<AmityCommunityCategory>?
    private var categoryList: [AmityCommunityCategoryModel] = []
    private var categoryToken: AmityNotificationToken?
    
    init() {
        setupCollection()
    }
    
    private func setupCollection() {
        categoryCollection = categoryRepository.getCategories(sortBy: .displayName, includeDeleted: false)
        
        categoryToken = categoryCollection?.observe { [weak self] collection, _, error in
            guard let strongSelf = self else { return }
            strongSelf.prepareData(categoryCollection: collection)
        }
    }
    
    // MARK: - Data Source
    
    func numberOfItems() -> Int {
        return categoryList.count
    }
    
    func item(at indexPath: IndexPath) -> AmityCommunityCategoryModel? {
        guard !categoryList.isEmpty else { return nil }
        return categoryList[indexPath.row]
    }
    
    private func prepareData(categoryCollection: AmityCollection<AmityCommunityCategory>) {
        guard let currentUserMetadata =
                AmityUIKitManagerInternal.shared.client.currentUser?.object?.metadata else { return }
        var categories: [AmityCommunityCategoryModel] = []
        let catCount = categoryCollection.count()
        
        for index in 0..<categoryCollection.count() {
            guard let object = categoryCollection.object(at: index) else { continue }
            let communities = self.categoryRepository
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
                
                if (model.matchesUserSegment(currentUserMetadata)) {
                    categories.append(model)
                }
            }
        }
        
        self.categoryList = categories

        delegate?.screenViewModelDidUpdateData(self)
    }
    
    func loadNext() {
        guard let collection = categoryCollection else { return }
        switch collection.loadingStatus {
        case .loaded:
            collection.nextPage()
        default:
            break
        }
    }
    
}
