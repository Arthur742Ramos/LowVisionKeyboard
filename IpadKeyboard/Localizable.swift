//
//  Localizable.swift
//  IpadKeyboard
//
//  Localized strings for the app
//

import Foundation

struct Localized {
    
    // MARK: - Current Language
    
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
            isPortuguese ? "Teclado Acessível" : "Accessible Keyboard"
        }
        
        static var subtitle: String {
            isPortuguese ? "Configurações do Teclado" : "Keyboard Settings"
        }
    }
    
    // MARK: - Settings
    
    struct Settings {
        static var keySize: String {
            isPortuguese ? "Tamanho das Teclas" : "Key Size"
        }
        
        static var fontSize: String {
            isPortuguese ? "Tamanho da Fonte" : "Font Size"
        }
        
        static var highContrast: String {
            isPortuguese ? "Alto Contraste" : "High Contrast"
        }
        
        static var highContrastDescription: String {
            isPortuguese ? "Bordas mais grossas e cores mais fortes" : "Thicker borders and stronger colors"
        }
        
        static var soundFeedback: String {
            isPortuguese ? "Som ao Digitar" : "Typing Sounds"
        }
        
        static var hapticFeedback: String {
            isPortuguese ? "Vibração ao Digitar" : "Haptic Feedback"
        }
        
        static var autocomplete: String {
            isPortuguese ? "Autocompletar" : "Autocomplete"
        }
        
        static var autocompleteDescription: String {
            isPortuguese ? "Sugestões de palavras enquanto digita" : "Word suggestions while typing"
        }
        
        static var language: String {
            isPortuguese ? "Idioma" : "Language"
        }
        
        static var preview: String {
            isPortuguese ? "Visualização" : "Preview"
        }
    }
    
    // MARK: - Instructions
    
    struct Instructions {
        static var title: String {
            isPortuguese ? "Como Ativar o Teclado" : "How to Enable Keyboard"
        }
        
        static var step1: String {
            isPortuguese ? "1. Abra Ajustes → Geral → Teclado" : "1. Open Settings → General → Keyboard"
        }
        
        static var step2: String {
            isPortuguese ? "2. Toque em Teclados → Adicionar Novo Teclado" : "2. Tap Keyboards → Add New Keyboard"
        }
        
        static var step3: String {
            isPortuguese ? "3. Selecione \"Teclado Acessível\"" : "3. Select \"Accessible Keyboard\""
        }
        
        static var step4: String {
            isPortuguese ? "4. Permita \"Acesso Total\" para recursos completos" : "4. Allow \"Full Access\" for all features"
        }
    }
    
    // MARK: - Keyboard Labels
    
    struct Keyboard {
        static var space: String {
            isPortuguese ? "espaço" : "space"
        }
        
        static var returnKey: String {
            isPortuguese ? "retorno" : "return"
        }
        
        static var delete: String {
            isPortuguese ? "apagar" : "delete"
        }
        
        static var shift: String {
            isPortuguese ? "maiúsc" : "shift"
        }
    }
}
