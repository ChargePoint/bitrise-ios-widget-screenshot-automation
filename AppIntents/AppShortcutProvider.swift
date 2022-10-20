//
//  AppShortcutProvider.swift
//  bitrise-screenshot-automation
//
//  Created by Rishab Sukumar on 10/20/22.
//  Copyright © 2022 ChargePoint, Inc. All rights reserved.
//

import Foundation
import AppIntents

@available(iOS 16, *)
struct AppShortcuts: AppShortcutsProvider {
    static var shortcutTileColor: ShortcutTileColor = ShortcutTileColor.grayBlue
    // Declaring sampleShortcutPhrases array of localized strings so genstrings pulls these strings to make
    // accessible to localizers.
    let sampleShortcutPhrases = [
        NSLocalizedString("Test sample with ${applicationName}", comment: ""),
        NSLocalizedString("Run sample with ${applicationName}", comment: "")
    ]
    
    @AppShortcutsBuilder static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: SampleAppIntent(),
            phrases: [
                "Test sample with \(.applicationName)",
                "Run sample with \(.applicationName)"
            ]
        )
    }
}
