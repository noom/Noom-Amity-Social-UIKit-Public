//
// Created by Leke Abolade
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import Foundation
import ComposableArchitecture

public struct NotificationFeature: ReducerProtocol {
    
    private let markNotificationAsRead: (String) -> EffectTask<Action>
    private let openNotification: (PostId) -> Void
    
    init(markNotificationAsRead: @escaping (String) -> EffectTask<Action>, openNotification: @escaping (PostId) -> Void) {
        self.markNotificationAsRead = markNotificationAsRead
        self.openNotification = openNotification
    }
    
    public struct PostId: Hashable {
        let value: String
    }
    
    public typealias State = CommunityNotification
    public enum Action: Equatable { case didTap }
    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .didTap:
            state.hasRead = true
            if let postId = state.postId {
                openNotification(postId)
            }
            return markNotificationAsRead(state.id)
        }
    }
}
