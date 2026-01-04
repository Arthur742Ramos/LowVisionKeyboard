//
//  Localizable.swift
//  IpadKeyboard
//
//  Localized strings for the app - uses NSLocalizedString for proper iOS localization
//

import Foundation

struct Localized {
    
    // MARK: - Current Language Detection
    
    static var currentLanguage: String {
        let preferredLanguages = Locale.preferredLanguages
        for lang in preferredLanguages {
            if lang.hasPrefix("pt") {
                return "pt-BR"
            }
        }
        return "en"
    }
    
    static var isPortuguese: Bool {
        return currentLanguage == "pt-BR"
    }
    
    // MARK: - App Strings
    
    struct App {
        static var title: String {
            NSLocalizedString("app.title", comment: "App title")
        }
        
        static var subtitle: String {
            NSLocalizedString("app.subtitle", comment: "App subtitle")
        }
    }
    
    // MARK: - Settings
    
    struct Settings {
        static var keySize: String {
            NSLocalizedString("settings.keySize", comment: "Key size setting label")
        }
        
        static var keyHeight: String {
            NSLocalizedString("settings.keyHeight", comment: "Key height setting label")
        }
        
        static func keyHeightFormat(_ value: Int) -> String {
            String(format: NSLocalizedString("settings.keyHeightFormat", comment: "Key height with value"), value)
        }
        
        static var fontSize: String {
            NSLocalizedString("settings.fontSize", comment: "Font size setting label")
        }
        
        static func fontSizeFormat(_ value: Int) -> String {
            String(format: NSLocalizedString("settings.fontSizeFormat", comment: "Font size with value"), value)
        }
        
        static var points: String {
            NSLocalizedString("settings.points", comment: "Points unit")
        }
        
        static var highContrast: String {
            NSLocalizedString("settings.highContrast", comment: "High contrast toggle label")
        }
        
        static var highContrastDescription: String {
            NSLocalizedString("settings.highContrastDescription", comment: "High contrast description")
        }
        
        static var soundFeedback: String {
            NSLocalizedString("settings.soundFeedback", comment: "Sound feedback toggle label")
        }
        
        static var soundFeedbackDescription: String {
            NSLocalizedString("settings.soundFeedbackDescription", comment: "Sound feedback description")
        }
        
        static var hapticFeedback: String {
            NSLocalizedString("settings.hapticFeedback", comment: "Haptic feedback toggle label")
        }
        
        static var hapticFeedbackDescription: String {
            NSLocalizedString("settings.hapticFeedbackDescription", comment: "Haptic feedback description")
        }
        
        static var autocomplete: String {
            NSLocalizedString("settings.autocomplete", comment: "Autocomplete toggle label")
        }
        
        static var autocompleteDescription: String {
            NSLocalizedString("settings.autocompleteDescription", comment: "Autocomplete description")
        }
        
        static var language: String {
            NSLocalizedString("settings.language", comment: "Language setting label")
        }
        
        static var preview: String {
            NSLocalizedString("settings.preview", comment: "Preview section label")
        }
    }
    
    // MARK: - Presets
    
    struct Presets {
        static var medium: String {
            NSLocalizedString("preset.medium", comment: "Medium preset button")
        }
        
        static var large: String {
            NSLocalizedString("preset.large", comment: "Large preset button")
        }
        
        static var extraLarge: String {
            NSLocalizedString("preset.extraLarge", comment: "Extra large preset button")
        }
    }
    
    // MARK: - Instructions
    
    struct Instructions {
        static var title: String {
            NSLocalizedString("instructions.title", comment: "Instructions title")
        }
        
        static var step1: String {
            NSLocalizedString("instructions.step1", comment: "Instruction step 1")
        }
        
        static var step2: String {
            NSLocalizedString("instructions.step2", comment: "Instruction step 2")
        }
        
        static var step3: String {
            NSLocalizedString("instructions.step3", comment: "Instruction step 3")
        }
        
        static var step4: String {
            NSLocalizedString("instructions.step4", comment: "Instruction step 4")
        }
        
        static var step5: String {
            NSLocalizedString("instructions.step5", comment: "Instruction step 5")
        }
        
        static var openSettings: String {
            NSLocalizedString("instructions.openSettings", comment: "Open settings button")
        }
    }
    
    // MARK: - Sections
    
    struct Sections {
        static var header: String {
            NSLocalizedString("section.header", comment: "Section header")
        }
        
        static var headerDescription: String {
            NSLocalizedString("section.headerDescription", comment: "Section header description")
        }
        
        static var appearance: String {
            NSLocalizedString("section.appearance", comment: "Appearance section")
        }
        
        static var feedback: String {
            NSLocalizedString("section.feedback", comment: "Feedback section")
        }
        
        static var smartFeatures: String {
            NSLocalizedString("section.smartFeatures", comment: "Smart features section")
        }
        
        static var autoCapInfo: String {
            NSLocalizedString("section.autoCapInfo", comment: "Auto-capitalization info")
        }
    }
    
    // MARK: - Preview
    
    struct Preview {
        static var keyboardLabel: String {
            NSLocalizedString("preview.keyboardLabel", comment: "Keyboard preview accessibility label")
        }
    }
    
    // MARK: - Keyboard Labels
    
    struct Keyboard {
        static var space: String {
            NSLocalizedString("keyboard.space", comment: "Space key label")
        }
        
        static var returnKey: String {
            NSLocalizedString("keyboard.return", comment: "Return key label")
        }
        
        static var delete: String {
            NSLocalizedString("keyboard.delete", comment: "Delete key label")
        }
        
        static var shift: String {
            NSLocalizedString("keyboard.shift", comment: "Shift key label")
        }
    }
}
