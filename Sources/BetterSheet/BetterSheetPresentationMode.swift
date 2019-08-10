//
//  BetterSheetPresentationMode.swift
//  BetterSheet
//
//  Created by Peter Verhage on 02/08/2019.
//  Copyright © 2019 Peter Verhage. All rights reserved.
//

import SwiftUI

public struct BetterSheetPresentationMode {
    internal var coordinator: BetterSheetCoordinator?
    
    public var isPresented: Bool {
        get {
            coordinator?.viewController != nil
        }
    }
    
    init(coordinator: BetterSheetCoordinator? = nil) {
        self.coordinator = coordinator
    }
    
    public func dismiss() {
        coordinator?.dismiss()
    }
}

private struct BetterSheetPresentationModeEnvironmentKey: EnvironmentKey {
    static var defaultValue: Binding<BetterSheetPresentationMode> = .constant(BetterSheetPresentationMode())
}

public extension EnvironmentValues {
    var betterSheetPresentationMode: Binding<BetterSheetPresentationMode> {
        get { self[BetterSheetPresentationModeEnvironmentKey.self] }
        set { self[BetterSheetPresentationModeEnvironmentKey.self] = newValue}
    }
}
