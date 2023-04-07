//
// Created by Leke Abolade
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import Foundation
import ComposableArchitecture

public typealias NotificationId = String
struct NotificationFeature: ReducerProtocol {
    
    private let markNotificationAsRead: (NotificationId) -> EffectTask<Void>
    private let openNotification: (PostId) -> Void
    
    init(markNotificationAsRead: @escaping (NotificationId) -> EffectTask<Void>, openNotification: @escaping (PostId) -> Void) {
        self.markNotificationAsRead = markNotificationAsRead
        self.openNotification = openNotification
    }
    
    struct PostId: Hashable {
        let value: String
    }
    
    typealias State = CommunityNotification
    enum Action: Equatable { case didTap }
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .didTap:
            state.hasRead = true
            if let postId = state.postId {
                openNotification(postId)
            }
            return markNotificationAsRead(state.id).fireAndForget()
        }
    }
}
