//
// Created by Leke Abolade
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import SwiftUI

struct NotificaitonsTrayList: View {
    var dismiss: (() -> Void)?
    
    var body: some View {
        NavigationView {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                dismiss?()
                            }
                        }
                }
                .navigationTitle("Notifications")
        }
    }
}

struct NotificationsTrayList_Previews: PreviewProvider {
    static var previews: some View {
        NotificaitonsTrayList()
    }
}
