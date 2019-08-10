//
//  UIHostingController+BetterSheet.swift
//  BetterSheet
//
//  Created by Peter Verhage on 07/08/2019.
//  Copyright © 2019 Peter Verhage. All rights reserved.
//

import SwiftUI

public extension UIHostingController {
    static func withBetterSheetSupport(rootView: Content) -> UIViewController {
        let coordinator = BetterSheetCoordinator()
        
        let betterSheetSupportingRootView =
            BetterSheetSupport(coordinator: coordinator) {
                rootView
            }

        let viewController = UIHostingController<BetterSheetSupport<Content>>(rootView: betterSheetSupportingRootView)
        coordinator.viewController = viewController
        
        return viewController
    }
}
