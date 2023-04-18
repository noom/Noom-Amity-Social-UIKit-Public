//
// Created by Calvin Ng
// Copyright ® 2023 Noom, Inc. All Rights Reserved
//

import SwiftUI

private struct OnFirstAppear: ViewModifier {
    let perform: () -> Void

    @State private var firstTime = true

    func body(content: Content) -> some View {
        content.onAppear {
            if firstTime {
                firstTime = false
                perform()
            }
        }
    }
}

extension View {
    /// **[Noom]** Use this modifier to execute code only for whenever a view appears for the very first time.
    /// This is a lifecycle event analogous to `viewDidLoad`.
    ///
    /// - Parameter perform: The code to be executed when the view appears.
    func onFirstAppear(perform: @escaping () -> Void) -> some View {
        modifier(OnFirstAppear(perform: perform))
    }
}
