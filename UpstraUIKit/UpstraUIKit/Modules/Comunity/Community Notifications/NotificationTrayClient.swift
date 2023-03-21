//
// Created by Leke Abolade
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import Foundation
import ComposableArchitecture
import RxSwift

public struct NotificationTrayClient {
    
    public init(getNotifications: @escaping () -> Single<Void>) {
        self.getNotifications = getNotifications
    }
    
  public var getNotifications: () -> Single<Void>
}

public struct InternalNotificationTray: ReducerProtocol {
    public struct Client {
        public init(getNotifications: @escaping () -> Effect<Action, Never> ) {
            self.getNotifications = getNotifications
        }
        
        public var getNotifications: () -> Effect<Action, Never         >
    }
    
    public struct State: Equatable {
        
    }
    
    public enum Action {
        case screenAppeared
        case hello(Result<Void, Error>)
    }
    
    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .screenAppeared:
            return client.getNotifications()
        case .hello:
            return .none
        }
    }
    
    let client: Client

    public init(client: Client) {
        self.client = client
    }
    
    public typealias Store = ComposableArchitecture.Store<State, Action>
    public typealias ViewStore = ComposableArchitecture.ViewStore<State, Action>
}
