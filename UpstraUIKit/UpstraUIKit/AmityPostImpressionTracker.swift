//
//  PostImpressionTracker.swift
//  AmityUIKit
//
//  Created by Matias Crespillo on 7/13/22.
//  Copyright © 2022 Amity. All rights reserved.
//

import Foundation

/// Extremelly simple impression tracker, needs to be enhanced to increase accuracy and handle different situations.
class AmityPostImpressionTracker {
    private static let impressionTime: TimeInterval = 5.0
    var timer: Timer?
    fileprivate var visiblePosts: Set<VisiblePost> = []


    func postsVisible(_ posts: [AmityPostModel]) {
        stopTracking()
        print("adding \(posts.map{ $0.postId  })")
        self.visiblePosts = Set(posts.map { VisiblePost(time: Date(), postId: $0.postId) })
    }

    func stopTracking() {
        visiblePosts
            .filter { Date().timeIntervalSince($0.time) >= AmityPostImpressionTracker.impressionTime }
            .forEach { post in
                let event = AnalyticsEvent.postImpression(postId: post.postId)
                AmityUIKitManager.track(event: event)
                print("sending for post \(post.postId)")
            }
        visiblePosts.removeAll()
    }
}

private struct VisiblePost: Hashable {
    let time: Date
    let postId: String
}
    
