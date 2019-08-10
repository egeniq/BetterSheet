//
//  BetterSheetSupport.swift
//  BetterSheet
//
//  Created by Peter Verhage on 07/08/2019.
//  Copyright © 2019 Peter Verhage. All rights reserved.
//

import SwiftUI

internal struct BetterSheetSupport<Content>: View where Content: View {
    private let coordinator: BetterSheetCoordinator
    private let content: () -> Content
    @State private var presentationMode: BetterSheetPresentationMode
    
    init(coordinator: BetterSheetCoordinator, @ViewBuilder content: @escaping () -> Content) {
        self.coordinator = coordinator
        self.content = content
        _presentationMode = State(initialValue: BetterSheetPresentationMode(coordinator: coordinator))
    }
    
    var body: some View {
        content()
            .environment(\.betterSheetPresentationMode, $presentationMode)
            .onPreferenceChange(BetterSheetPreferenceKey.self) { sheet in
                if let sheet = sheet {
                    self.coordinator.present(sheet: sheet)
                } else {
                    self.coordinator.dismissPresentedSheet()
                }
            }
            .onPreferenceChange(BetterSheetDidAttemptToDismissCallbacksPreferenceKey.self) { value in
                self.coordinator.onDidAttemptToDismiss = value
            }
            .onPreferenceChange(BetterSheetIsModalInPresentationPreferenceKey.self) { value in
                self.coordinator.viewController?.isModalInPresentation = value ?? false
            }
    }
}
