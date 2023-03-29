//
// Created by Leke Abolade
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import Foundation
import ComposableArchitecture

public struct NotificationFeature: ReducerProtocol {
    
    private let markNotificationAsRead: (String) -> EffectTask<Action>
    
    init(markNotificationAsRead: @escaping (String) -> EffectTask<Action>) {
        self.markNotificationAsRead = markNotificationAsRead
    }
    
    public typealias State = CommunityNotification
    public enum Action: Equatable { case didTap }
    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .didTap:
            state.hasRead = true
            return markNotificationAsRead(state.id)
        }
    }
}
