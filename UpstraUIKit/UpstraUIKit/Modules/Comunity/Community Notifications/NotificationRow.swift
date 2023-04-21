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
        let imageUrl: URL?
        let lastUpdate: Date
        let hasRead: Bool
        let actors: [CommunityNotification.Actor]

        init(_ state: State) {
            self.description = state.notification.description
            self.imageUrl = state.notification.imageUrl
            self.lastUpdate = state.notification.lastUpdate
            self.hasRead = state.hasRead
            self.actors = state.notification.actors
        }
    }

    struct View {
        let store: StoreOf<NotificationRow>
    }
}

extension NotificationRow.ViewState {
    var attributedText: NSAttributedString {
        let attributedString = NSMutableAttributedString(string: description, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        actors.forEach {
            guard let range = description.range(of: $0.name) else { return }
            let convertedRange = NSRange(range, in: description)
            attributedString.addAttribute(NSAttributedString.Key.font,
                                          value: UIFont.systemFont(ofSize: 14, weight: .bold),
                                      range: convertedRange)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                          value: UIColor(red: 0.984, green: 0.318, blue: 0.231, alpha: 1),
                                      range: convertedRange)
        }
        return attributedString
    }
}

extension NotificationRow.View: View {

    var body: some View {
        WithViewStore(store, observe: NotificationRow.ViewState.init) { viewStore in
            Button {
                viewStore.send(.rowTapped)
            } label: {
                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: ".fill")
                            .data(url: viewStore.imageUrl)
                            .frame(width: 28, height: 28)
                            .background(Color.gray)
                            .clipShape(Circle())
                        VStack(alignment: .leading, spacing: 4) {
                            AttrText(viewStore.attributedText)
                            Text(viewStore.lastUpdate.timeAgo())
                                .font(Font(uiFont: UIFont(name: "UntitledSans-Regular", size: 12) ?? .systemFont(ofSize: 12)))
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        }
                        Spacer()

                        if !viewStore.hasRead {
                            Circle()
                                .foregroundColor(Color(red: 0.904, green: 0.318, blue: 0.231))
                                .frame(width: 12, height: 12)
                        }
                    }
                    Divider()
                }
            }
            .buttonStyle(.plain)
        }
    }
}

struct AttrText: UIViewRepresentable {

    var attributedText: NSAttributedString?

    init(_ attributedText: NSAttributedString?) {
        self.attributedText = attributedText
    }

    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }

    func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.attributedText = attributedText
    }
}
