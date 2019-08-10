//
//  OnBetterSheetDidAttemptToDismiss.swift
//  BetterSheet
//
//  Created by Peter Verhage on 02/08/2019.
//  Copyright © 2019 Peter Verhage. All rights reserved.
//

import SwiftUI

internal class BetterSheetDidAttemptToDismissCallback: Equatable {
    let action: () -> Void
    
    init(_ action: @escaping () -> Void) {
        self.action = action
    }
    
    static func == (lhs: BetterSheetDidAttemptToDismissCallback, rhs: BetterSheetDidAttemptToDismissCallback) -> Bool {
        return lhs === rhs
    }
}

internal struct BetterSheetDidAttemptToDismissCallbacksPreferenceKey: PreferenceKey {
    typealias Value = [BetterSheetDidAttemptToDismissCallback]
    
    static var defaultValue: Value = []
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.append(contentsOf: nextValue())
    }
}

public extension View {
    func onBetterSheetDidAttemptToDismiss(perform action: @escaping () -> Void) -> some View {
        return preference(key: BetterSheetDidAttemptToDismissCallbacksPreferenceKey.self, value: [BetterSheetDidAttemptToDismissCallback(action)])
    }
}
