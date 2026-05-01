//
//  ControlCenterWidgetControl.swift
//  ControlCenterWidget
//
//  Created by Daniel Husiuk on 30.04.2026.
//

import AppIntents
import SwiftUI
import WidgetKit

@available(iOS 18, *)
struct ControlCenterWidgetControl: ControlWidget {
    let kind: String = "com.danielhusiuk.Incognito-AI.ControlCenterWidget"

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: kind) {
            ControlWidgetButton(action: ControlWidgetIntent()) {
                Label(NSLocalizedString("Open Incognito AI", comment: ""), systemImage: "sparkle")
            }
        }
        .displayName("Incognito AI")
    }
}
