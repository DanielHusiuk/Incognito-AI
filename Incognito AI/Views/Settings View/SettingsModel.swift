//
//  SettingsModel.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 20.12.2025.
//

import UIKit

struct SettingsCell {
    var id: Int
    var titleImage: UIImage
    var accessoryImage: UIImage?
    var title: String
    var header: String?
    var footer: String?
    var cells: [SettingsCell]
}

struct SettingsModel {
    var cells: [SettingsCell] = [
        
        SettingsCell(id: 0, titleImage: UIImage(systemName: "keyboard.badge.eye")!, title: "Show keyboard on launch", header: "Keyboard:", footer: "", cells:
                        [SettingsCell(id: 1, titleImage: UIImage(systemName: "keyboard.chevron.compact.down")!, title: "Enable \"Hide Keyboard\" button", header: "", footer: "", cells: [])
                        ]),
        
        SettingsCell(id: 2, titleImage: UIImage(systemName: "plus.circle")!, title: "Confirm new chat", header: "Productivity:", footer: "", cells: [
            SettingsCell(id: 3, titleImage: UIImage(systemName: "arrow.left.arrow.right")!, title: "Swipe gestures", header: "", footer: "", cells: [])
        ]),
        
        SettingsCell(id: 4, titleImage: UIImage(systemName: "circle.righthalf.filled")!, title: "Appearance", header: "Customisation:", footer: "", cells: [
            SettingsCell(id: 5, titleImage: UIImage(systemName: "arrow.triangle.2.circlepath")!, title: "Landscape Mode", header: "", footer: "", cells: []),
            SettingsCell(id: 6, titleImage: UIImage(systemName: "sparkles.rectangle.stack")!, title: "Background animation", header: "", footer: "", cells: [])
        ]),
        
        SettingsCell(id: 7, titleImage: UIImage(systemName: "hand.tap")!, title: "Haptic Feedback", header: "Preferences:", footer: "", cells: [
            SettingsCell(id: 8, titleImage: UIImage(systemName: "globe")!, title: "App Language", header: "", footer: "", cells: [])
        ]),
        
        SettingsCell(id: 9, titleImage: UIImage(systemName: "envelope")!, title: "Send Feedback", header: "Other:", footer: "", cells: [
            SettingsCell(id: 10, titleImage: UIImage(systemName: "exclamationmark.triangle.fill")!, title: "Report a Bug", header: "", footer: "", cells: [])]),
        
        SettingsCell(id: 11, titleImage: UIImage(systemName: "person.fill")!, accessoryImage: UIImage(named: "github"), title: "Author:  Daniel Husiuk", header: "", footer: "• Incognito AI App •\nversion 1.0", cells: []),
    ]
}
