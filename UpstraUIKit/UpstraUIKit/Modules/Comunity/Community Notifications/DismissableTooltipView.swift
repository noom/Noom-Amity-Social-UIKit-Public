//
// Created by Leke Abolade
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import SwiftUI
import ComposableArchitecture

struct DismissableTooltipView: View {
    
    var title: String = ""
    var closeAction: () -> Void
    
    private let closeIconSize: CGSize = CGSize(width: 10, height: 10)
    private let closeIconTopPadding: CGFloat =  7
    private let closeButtonSize: CGSize = CGSize(width: 44, height: 44)
    private let horizontalContentPadding: CGFloat = 16
    private let verticalContentPadding: CGFloat = 8
    private let textSpacing: CGFloat = 8
    
    let store: InternalNotificationTray.Store

    var body: some View {
        WithViewStore(store) { viewstore in
            HStack(alignment: .top, spacing: 0) {

                VStack(alignment: .leading, spacing: textSpacing) {
                    if !title.isEmpty {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                    
            
                    ForEach(CommunityNotification.mockData) { item in
                        NotificationonContentView(viewModel: .init(notification: item))
                    }
                }.onAppear {
                    viewstore.send(.screenAppeared)
                }

                Button(action: closeAction) {
                    ZStack(alignment: .top) {
                        Color.clear
                            .frame(width: closeButtonSize.width, height: closeButtonSize.height)

                        Image(systemName: "xmark")
                            .renderingMode(.template)
                            .resizable()
                            .foregroundColor(.black)
                            .frame(width: closeIconSize.width, height: closeIconSize.height)
                            .padding(.top, closeIconTopPadding)
                    }
                }
            }
            .padding(.leading, horizontalContentPadding)
            .padding([.top, .bottom], verticalContentPadding)
        }
    }
}
