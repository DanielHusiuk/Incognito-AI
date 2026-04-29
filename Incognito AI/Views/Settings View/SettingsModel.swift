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
        
        SettingsCell(id: 0, titleImage: UIImage(systemName: "keyboard.badge.eye")!, title: NSLocalizedString("Show keyboard on launch", comment: ""), header: NSLocalizedString("Keyboard:", comment: ""), footer: "", cells: [
            SettingsCell(id: 1, titleImage: UIImage(systemName: "keyboard.chevron.compact.down")!, title: NSLocalizedString("\"Hide Keyboard\" button", comment: ""), header: "", footer: "", cells: [])
        ]),
        
        SettingsCell(id: 2, titleImage: UIImage(systemName: "arrow.left.arrow.right")!, title: NSLocalizedString("Swipe gestures", comment: ""), header: NSLocalizedString("Productivity:", comment: ""), footer: "", cells: [
            SettingsCell(id: 3, titleImage: UIImage(systemName: "plus.circle")!, title: NSLocalizedString("Confirm new chat", comment: ""), header: "", footer: "", cells: [])
        ]),
        
        SettingsCell(id: 4, titleImage: UIImage(systemName: "circle.righthalf.filled")!, title: NSLocalizedString("Appearance", comment: ""), header: NSLocalizedString("Customisation:", comment: ""), footer: "", cells: [
            SettingsCell(id: 5, titleImage: UIImage(systemName: "paintpalette")!, title: NSLocalizedString("Accent color", comment: ""), header: "", footer: "", cells: []),
            SettingsCell(id: 6, titleImage: UIImage(systemName: "arrow.triangle.2.circlepath")!, title: NSLocalizedString("Landscape mode", comment: ""), header: "", footer: "", cells: []),
            SettingsCell(id: 7, titleImage: UIImage(systemName: "sparkles.rectangle.stack")!, title: NSLocalizedString("Background animation", comment: ""), header: "", footer: "", cells: [])
        ]),
        
        SettingsCell(id: 8, titleImage: UIImage(systemName: "hand.tap")!, title: NSLocalizedString("Haptic feedback", comment: ""), header: NSLocalizedString("Preferences:", comment: ""), footer: "", cells: [
            SettingsCell(id: 9, titleImage: UIImage(systemName: "globe")!, title: NSLocalizedString("App language", comment: ""), header: "", footer: "", cells: [])
        ]),
        
        SettingsCell(id: 10, titleImage: UIImage(systemName: "envelope")!, title: NSLocalizedString("Send feedback", comment: ""), header: NSLocalizedString("Other:", comment: ""), footer: "", cells: [
            SettingsCell(id: 11, titleImage: UIImage(systemName: "exclamationmark.triangle.fill")!, title: NSLocalizedString("Report a bug", comment: ""), header: "", footer: "", cells: [])]),
        
        SettingsCell(id: 12, titleImage: UIImage(systemName: "person.fill")!, accessoryImage: UIImage(named: "github"), title: NSLocalizedString("Author:  Daniel Husiuk", comment: ""), header: "", footer: "• Incognito AI App •\nVersion \(String(describing: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "?"))", cells: []),
    ]
}
