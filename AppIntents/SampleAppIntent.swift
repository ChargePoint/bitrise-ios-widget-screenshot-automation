//
//  SampleAppIntent.swift
//  bitrise-screenshot-automation
//
//  Created by Rishab Sukumar on 10/20/22.
//  Copyright © 2022 ChargePoint, Inc. All rights reserved.
//

import Foundation
import AppIntents
import SwiftUI

@available(iOS 16, *)
struct SampleAppIntent: AppIntent {
    static _const let intentClassName = "SampleAppIntent"
    
    let chargingStatusIntentTitle = NSLocalizedString("Sample Shortcut", comment: "")
    static var title: LocalizedStringResource = "Sample Shortcut"
    static var description = NSLocalizedString("Sample Shortcut", comment: "")

    static var parameterSummary: some ParameterSummary {
        Summary()
    }
    
    @MainActor
    func perform() async throws -> some ProvidesDialog & ShowsSnippetView {
        return .result(dialog: IntentDialog(stringLiteral: NSLocalizedString("Test completed successfully.", comment: ""))) {
            SampleShortcutSnippet()
        }
    }
    
}
