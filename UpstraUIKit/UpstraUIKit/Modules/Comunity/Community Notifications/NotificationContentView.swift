//
// Created by Leke Abolade
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import SwiftUI
import ComposableArchitecture

struct NotificationContentView: View {
        
    let store: ComposableArchitecture.Store<CommunityNotification, NotificationAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            HStack(spacing: 4) {
                Image(systemName: "person.fill")
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewStore.description)
                    Text(dateDesription(date:viewStore.lastUpdate))
                }
                Spacer()
                Circle()
                    .foregroundColor(.orange)
                    .opacity(viewStore.hasRead ? 0 : 1)
                    .frame(width: 10, height: 10)
            }
        }
    }
    
    private func dateDesription(date: Date) -> String {
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "YY/MM/dd"

        // Convert Date to String
        return dateFormatter.string(from: date)
    }
}

//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        NotificationonContentView(viewModel: .init(notification: .mock()))
//    }
//}

public enum NotificationAction: Equatable {
    case didTap
}
