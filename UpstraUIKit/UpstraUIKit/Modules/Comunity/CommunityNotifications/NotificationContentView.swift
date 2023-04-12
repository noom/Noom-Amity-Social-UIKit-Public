//
// Created by Leke Abolade
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import SwiftUI
import ComposableArchitecture

struct NotificationContentView: View {
        
    let store: ComposableArchitecture.StoreOf<NotificationFeature>

    var body: some View {
        WithViewStore(store) { viewStore in
            Button {
                viewStore.send(.didTap)
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
                    Circle()
                        .foregroundColor(.orange)
                        .opacity(viewStore.hasRead ? 0 : 1)
                        .frame(width: 10, height: 10)
                }
            }.buttonStyle(.plain)
        }
    }
}

//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        NotificationContentView(store: .init(initialState: .mock(), reducer: ReducerProtocol))
//    }
//}
