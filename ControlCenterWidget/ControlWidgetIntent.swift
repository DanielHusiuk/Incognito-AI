//
//  ControlWidgetIntent.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 30.04.2026.
//

import WidgetKit
import AppIntents

@available(iOS 18, *)
struct ControlWidgetIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Incognito AI"
    static var isDiscoverable: Bool = false
    static var openAppWhenRun: Bool = true
    
    @MainActor
    func perform() async throws -> some IntentResult {
        return .result()
    }
}
