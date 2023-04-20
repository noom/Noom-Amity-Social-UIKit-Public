//
// Created by Leke Abolade
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import ComposableArchitecture
import SwiftUI

struct NotificationRow: ReducerProtocol {

    let client: NotificationTrayClient
    
    struct State: Identifiable {
        var id: String { notification.id }

        var notification: CommunityNotification

        /// Initially coming from the server side, but would update when user reads the notification.
        var hasRead: Bool

        init(notification: CommunityNotification) {
            self.notification = notification
            self.hasRead = notification.hasRead
        }
    }

    enum Action {
        case rowTapped
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .rowTapped:
            state.hasRead = true
            return .merge(
                client.api.markNotificationAsRead(state.notification.id).fireAndForget(),
                state.notification.postId
                    .map { client.openNotification($0).fireAndForget() } ?? .none
            )
        }
    }
}

// MARK: - UI
extension NotificationRow {

    struct ViewState: Equatable {
        let description: String
        let lastUpdate: Date
        let hasRead: Bool

        init(_ state: State) {
            self.description = state.notification.description
            self.lastUpdate = state.notification.lastUpdate
            self.hasRead = state.hasRead
        }
    }

    struct View {
        let store: StoreOf<NotificationRow>
    }
}

extension NotificationRow.View: View {

    var body: some View {
        WithViewStore(store, observe: NotificationRow.ViewState.init) { viewStore in
            Button {
                viewStore.send(.rowTapped)
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "person.fill")
                        .frame(width: 20, height: 20)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewStore.description)
                            .multilineTextAlignment(.leading)
                        Text(DateFormatter.yyyymmdd.string(from: viewStore.lastUpdate))
                    }
                    Spacer()

                    if !viewStore.hasRead {
                        Circle()
                            .foregroundColor(.orange)
                            .frame(width: 10, height: 10)
                    }
                }
            }
            .buttonStyle(.plain)
        }
    }
}
