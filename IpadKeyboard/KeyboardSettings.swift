//
//  KeyboardSettings.swift
//  IpadKeyboard
//
//  Shared settings model for the Accessible Keyboard
//

import Foundation

/// Shared settings for the accessible keyboard
struct KeyboardSettings {
    
    static let appGroupIdentifier = "group.com.ipadkeyboard.accessible"
    
    // Setting keys
    static let keyHeightKey = "keyHeight"
    static let fontSizeKey = "fontSize"
    static let useHighContrastKey = "useHighContrast"
    static let enableSoundFeedbackKey = "enableSoundFeedback"
    static let enableHapticFeedbackKey = "enableHapticFeedback"
    
    // Default values
    static let defaultKeyHeight: CGFloat = 70
    static let defaultFontSize: CGFloat = 28
    static let defaultUseHighContrast = true
    static let defaultEnableSoundFeedback = true
    static let defaultEnableHapticFeedback = true
    
    /// Shared UserDefaults for app group
    static var sharedDefaults: UserDefaults? {
        return UserDefaults(suiteName: appGroupIdentifier)
    }
}
