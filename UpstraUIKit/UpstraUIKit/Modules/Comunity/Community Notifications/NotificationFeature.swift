//
// Created by Leke Abolade
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import Foundation
import ComposableArchitecture

public struct NotificationFeature: ReducerProtocol {
    
    private let markNotificationAsRead: (String) -> EffectTask<Action>
    private let openNotification: (String) -> Void
    
    init(markNotificationAsRead: @escaping (String) -> EffectTask<Action>, openNotification: @escaping (String) -> Void) {
        self.markNotificationAsRead = markNotificationAsRead
        self.openNotification = openNotification
    }
    
    public typealias State = CommunityNotification
    public enum Action: Equatable { case didTap }
    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .didTap:
            state.hasRead = true
            if let rangeOfPostSubstring = state.path.range(of: "/post/") {
                let substring = String(state.path[rangeOfPostSubstring.upperBound...])
                let postId: String
                if let index = substring.firstIndex(of: "/") {
                    postId = String(substring[substring.startIndex..<index])
                } else {
                    postId = substring
                }
                openNotification(postId)
            }
            return markNotificationAsRead(state.id)
        }
    }
}
