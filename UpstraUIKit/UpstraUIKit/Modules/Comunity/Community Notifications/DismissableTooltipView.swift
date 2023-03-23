//
// Created by Leke Abolade
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import SwiftUI
import ComposableArchitecture

struct DismissableTooltipView: View {
    
    var title: String = ""
    var closeAction: () -> Void
    
    private static let closeIconSize: CGSize = CGSize(width: 10, height: 10)
    private static let closeIconTopPadding: CGFloat =  7
    private static let closeButtonSize: CGSize = CGSize(width: 44, height: 44)
    private static let horizontalContentPadding: CGFloat = 16
    private static let verticalContentPadding: CGFloat = 8
    private static let textSpacing: CGFloat = 8
    
    let store: InternalNotificationTray.Store

    var body: some View {
        WithViewStore(store) { viewstore in
            HStack(alignment: .top, spacing: 0) {

                VStack(alignment: .leading, spacing: DismissableTooltipView.textSpacing) {
                    if !title.isEmpty {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                    
                    ForEachStore(
                        self.store.scope(
                            state: \.notifications,
                            action: InternalNotificationTray.Action.notification(id:action:)
                        ),
                        content: NotificationContentView.init(store:)
                    )
                }.onAppear {
                    viewstore.send(.notificationsListAppeared)
                }

                Button(action: closeAction) {
                    ZStack(alignment: .top) {
                        Color.clear
                            .frame(
                                width: DismissableTooltipView.closeButtonSize.width,
                                height: DismissableTooltipView.closeButtonSize.height
                            )
                        
                        Image(systemName: "xmark")
                            .renderingMode(.template)
                            .resizable()
                            .foregroundColor(.black)
                            .frame(
                                width: DismissableTooltipView.closeIconSize.width,
                                height: DismissableTooltipView.closeIconSize.height
                            )
                            .padding(.top, DismissableTooltipView.closeIconTopPadding)
                    }
                }
            }
            .padding(.leading, DismissableTooltipView.horizontalContentPadding)
            .padding([.top, .bottom], DismissableTooltipView.verticalContentPadding)
        }
    }
}
