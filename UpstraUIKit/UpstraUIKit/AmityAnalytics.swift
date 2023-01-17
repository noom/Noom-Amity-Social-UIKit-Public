//
// Created by Matias Crespillo
// Copyright ® 2022 Noom, Inc. All Rights Reserved
//

import Foundation

public protocol AmityAnalytics {
    func track(_ event: AmityAnalyticsEvent)
}

public enum AmityAnalyticsEvent {
    case screenViewed(screen: AmityScreenIdentifier)
    case communityCreated(communityId: String, name: String, isPrivate: Bool)
    case communityJoined(communityId: String)
    case communityLeft(communityId: String)
    case communityClosed(communityId: String)
    case onboardingFinished
    case userClosedAmity
    case userTappedCreatePost(source: CreatePostSource)
    case userCreatedPost(source: CreatePostSource)
    case postImpression(postId: String)
    case userCreatedComment(isReply: Bool, isDisabled: Bool)
}

public enum CreatePostSource: String {
    case home
    case userProfile
    case communityProfile
    case globalFeed
    case other
}

public enum AmityScreenIdentifier: String {
    case feed
    case explore
    case userCommunities
    case createCommunity
    case editCommunity
    case communitySearch
    case communityDetails
    case communityCategories
    case postDetail
    case userProfile
    case userProfileEdit
    case userSettings
    case postTargetSelect
    case postCreate
    case postEdit
    case pollCreate
}
