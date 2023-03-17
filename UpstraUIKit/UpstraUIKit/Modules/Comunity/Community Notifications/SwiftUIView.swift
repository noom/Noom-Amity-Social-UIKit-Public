//
// Created by Leke Abolade
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import SwiftUI

struct NotificationContentViewModel {
    
    private let notification: CommunityNotification
    let hasRead: Bool
    
    init(notification: CommunityNotification) {
        self.notification = notification
        self.hasRead = notification.hasRead
    }
    
    var dateDesription: String {
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "YY/MM/dd"

        // Convert Date to String
        return dateFormatter.string(from: notification.lastUpdate)
    }
    
    var summary: String {
        guard !notification.actors.isEmpty else { return "" }
        let actors: String
        switch notification.actors.count {
        case 1: actors = notification.actors[0].name
        case 2: actors = "\(notification.actors[0].name) and \(notification.actors[1].name)"
        case 3: actors = "\(notification.actors[0].name), \(notification.actors[1].name) and \(notification.actors[2].name)"
        default: actors = "\(notification.actors[0].name), \(notification.actors[1].name) and \(notification.actors.count - 2) others"
        }
        return actors + " \(notification.verb.action)" + " your post"
    }
}

extension NotificationContentViewModel {
    static func mock() -> NotificationContentViewModel {
        return .init(notification: .mock())
    }
}

struct NotificationonContentView: View {
    
    let viewModel: NotificationContentViewModel
        
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "person.fill")
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.summary)
                Text(viewModel.dateDesription)
            }
            Spacer()
            Circle()
                .opacity(viewModel.hasRead ? 0 : 1)
                .frame(width: 10, height: 10)
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationonContentView(viewModel: .init(notification: .mock()))
    }
}
