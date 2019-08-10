//
//  BetterSheetCoordinator.swift
//  BetterSheet
//
//  Created by Peter Verhage on 02/08/2019.
//  Copyright © 2019 Peter Verhage. All rights reserved.
//

import SwiftUI

internal class BetterSheetCoordinator: NSObject, UIAdaptivePresentationControllerDelegate {
    private var sheet: BetterSheet?
    private weak var presentingCoordinator: BetterSheetCoordinator?
    
    internal var onDidAttemptToDismiss: [BetterSheetDidAttemptToDismissCallback] = []

    internal weak var viewController: UIViewController? {
        didSet {
            viewController?.presentationController?.delegate = self
        }
    }
    
    var presentedCoordinator: BetterSheetCoordinator?
    
    init(sheet: BetterSheet? = nil, presentingCoordinator: BetterSheetCoordinator? = nil) {
        self.sheet = sheet
        self.presentingCoordinator = presentingCoordinator
    }
    
    func present(sheet: BetterSheet) {
        if let presentedSheet = presentedCoordinator?.sheet {
            if presentedSheet.shouldDismiss() {
                presentedCoordinator?.dismiss()
            } else {
                return
            }
        }
        
        let coordinator = BetterSheetCoordinator(sheet: sheet, presentingCoordinator: self)
        
        let rootView =
            BetterSheetSupport(coordinator: coordinator) {
                sheet.content()
            }
        
        let viewController = UIHostingController(rootView: rootView)
        coordinator.viewController = viewController
        presentedCoordinator = coordinator
        self.viewController?.present(viewController, animated: true)
    }
    
    func dismissPresentedSheet() {
        guard let presentedCoordinator = presentedCoordinator, let sheet = presentedCoordinator.sheet else { return }

        if let viewController = presentedCoordinator.viewController {
            presentedCoordinator.viewController = nil
            viewController.dismiss(animated: true)
        }
        
        self.presentedCoordinator = nil
        
        if !sheet.shouldDismiss() {
            sheet.resetBinding()
        }
        
        sheet.onDismiss?()
    }

    func dismiss() {
        guard let presentingCoordinator = presentingCoordinator, presentingCoordinator.presentedCoordinator === self else { return }
        presentingCoordinator.dismissPresentedSheet()
    }
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        for callback in onDidAttemptToDismiss {
            callback.action()
        }
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        viewController = nil
        dismiss()
    }
}
