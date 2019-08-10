//
//  BetterSheet.swift
//  BetterSheet
//
//  Created by Peter Verhage on 02/08/2019.
//  Copyright © 2019 Peter Verhage. All rights reserved.
//

import SwiftUI

internal struct BetterSheet: Equatable {
    let id = UUID()
    let content: () -> AnyView
    let onDismiss: (() -> Void)?
    let shouldDismiss: () -> Bool
    let resetBinding: () -> Void
    
    static func == (lhs: BetterSheet, rhs: BetterSheet) -> Bool {
        return lhs.id == rhs.id
    }
}
