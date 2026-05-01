//
//  SettingsManager.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 28.04.2026.
//

import UIKit

struct SettingsManager {
    
    static func resetSettingsToDefaults() {
        UserDefaults.standard.set(false, forKey: "keyboardOnLaunchSwitch")
        UserDefaults.standard.set(true, forKey: "hideKeyboardSwitch")
        
        UserDefaults.standard.set(1, forKey: "swipeGestureOption")
        UserDefaults.standard.set(1, forKey: "swipeGestureActionState")
        
        UserDefaults.standard.set(false, forKey: "confirmChatSwitch")
        
        UserDefaults.standard.set(UIUserInterfaceStyle.unspecified.rawValue, forKey: "appearanceOption")
        UserDefaults.standard.set(0, forKey: "appearanceActionState")
        
        UserDefaults.standard.set(0, forKey: "accentColorOption")
        UserDefaults.standard.set(0, forKey: "accentColorActionState")
        
        UserDefaults.standard.set(false, forKey: "landscapeModeSwitch")
        UserDefaults.standard.set(true, forKey: "backgroundAnimationSwitch")
        UserDefaults.standard.set(true, forKey: "hapticSwitch")
        
        NotificationCenter.default.post(name: Notification.Name("swipeGestureChanged"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("appearanceChanged"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("tintColorChanged"), object: nil)
    }
    
    static func checkFirstLaunch() {
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        
        if !hasLaunchedBefore {
            resetSettingsToDefaults()
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        }
    }
}
