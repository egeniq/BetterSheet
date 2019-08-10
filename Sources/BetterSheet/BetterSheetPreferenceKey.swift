//
//  BetterSheetPreferenceKey.swift
//  BetterSheet
//
//  Created by Peter Verhage on 09/08/2019.
//  Copyright © 2019 Peter Verhage. All rights reserved.
//

import SwiftUI

internal struct BetterSheetPreferenceKey: PreferenceKey {
    typealias Value = BetterSheet?
    
    static var defaultValue: Value = nil
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        let result = nextValue() ?? value
        value = result
    }
}
