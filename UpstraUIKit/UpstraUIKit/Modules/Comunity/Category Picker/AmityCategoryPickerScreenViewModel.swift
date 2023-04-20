//
//  AmitySelectCategoryListScreenViewModel.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 2/11/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import AmitySDK

class AmityCategoryPickerScreenViewModel: AmityCategoryPickerScreenViewModelType {
    
    weak var delegate: AmityCategoryPickerScreenViewModelDelegate?
    
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
        guard categoryList.indices.contains(indexPath.row) else { return nil }
        return categoryList[indexPath.row]
    }
    
    private func prepareData(categoryCollection: AmityCollection<AmityCommunityCategory>) {
        guard let currentUserMetadata =
                AmityUIKitManagerInternal.shared.client.currentUser?.metadata else { return }
        var categories: [AmityCommunityCategoryModel] = []
        
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
            
            if let model = AmityCommunityCategoryModel.from(category: object, communityList: communities),
               model.metadata.matchesUserSegment(currentUserMetadata) {
                categories.append(model)
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
