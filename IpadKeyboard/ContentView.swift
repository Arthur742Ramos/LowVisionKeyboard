//
//  ContentView.swift
//  IpadKeyboard
//
//  Settings app for the Accessible Keyboard
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Settings State
    
    @AppStorage("keyHeight", store: UserDefaults(suiteName: "group.com.ipadkeyboard.accessible"))
    private var keyHeight: Double = 70
    
    @AppStorage("fontSize", store: UserDefaults(suiteName: "group.com.ipadkeyboard.accessible"))
    private var fontSize: Double = 28
    
    @AppStorage("useHighContrast", store: UserDefaults(suiteName: "group.com.ipadkeyboard.accessible"))
    private var useHighContrast: Bool = true
    
    @AppStorage("enableSoundFeedback", store: UserDefaults(suiteName: "group.com.ipadkeyboard.accessible"))
    private var enableSoundFeedback: Bool = true
    
    @AppStorage("enableHapticFeedback", store: UserDefaults(suiteName: "group.com.ipadkeyboard.accessible"))
    private var enableHapticFeedback: Bool = true
    
    @AppStorage("enableAutocomplete", store: UserDefaults(suiteName: "group.com.ipadkeyboard.accessible"))
    private var enableAutocomplete: Bool = true
    
    @AppStorage("selectedLanguage", store: UserDefaults(suiteName: "group.com.ipadkeyboard.accessible"))
    private var selectedLanguage: String = Localized.isPortuguese ? "pt-BR" : "en"
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // Header
                    headerSection
                    
                    // Setup Instructions
                    setupInstructionsSection
                    
                    // Language Selection
                    languageSection
                    
                    // Key Size Settings
                    keySizeSection
                    
                    // Appearance Settings
                    appearanceSection
                    
                    // Feedback Settings
                    feedbackSection
                    
                    // Smart Features Settings
                    smartFeaturesSection
                    
                    // Keyboard Preview
                    previewSection
                    
                    Spacer(minLength: 40)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(Localized.App.title)
            .navigationBarTitleDisplayMode(.large)
        }
        .navigationViewStyle(.stack)
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "keyboard")
                .font(.system(size: 60))
                .foregroundColor(.blue)
                .accessibilityHidden(true)
            
            Text(Localized.isPortuguese ? "Teclado para Baixa Visão" : "Low Vision Keyboard")
                .font(.title)
                .fontWeight(.bold)
            
            Text(Localized.isPortuguese ? 
                 "Personalize seu teclado para melhor visibilidade e acessibilidade" : 
                 "Customize your keyboard for better visibility and accessibility")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .accessibilityElement(children: .combine)
    }
    
    // MARK: - Setup Instructions
    
    private var setupInstructionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label(Localized.Instructions.title, systemImage: "gearshape.fill")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 12) {
                InstructionRow(number: 1, text: Localized.isPortuguese ? 
                    "Abra o app Ajustes no seu iPad" : "Open Settings app on your iPad")
                InstructionRow(number: 2, text: Localized.isPortuguese ? 
                    "Vá em Geral → Teclado → Teclados" : "Go to General → Keyboard → Keyboards")
                InstructionRow(number: 3, text: Localized.isPortuguese ? 
                    "Toque em \"Adicionar Novo Teclado...\"" : "Tap \"Add New Keyboard...\"")
                InstructionRow(number: 4, text: Localized.isPortuguese ? 
                    "Selecione \"Teclado Acessível\"" : "Select \"Accessible Keyboard\"")
                InstructionRow(number: 5, text: Localized.isPortuguese ? 
                    "Permita Acesso Total para todos os recursos" : "Allow Full Access for all features")
            }
            
            Button(action: openSettings) {
                HStack {
                    Image(systemName: "gear")
                    Text(Localized.isPortuguese ? "Abrir Ajustes" : "Open Settings")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .accessibilityHint(Localized.isPortuguese ? "Abre o app Ajustes" : "Opens the Settings app")
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
    
    // MARK: - Language Section
    
    private var languageSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label(Localized.Settings.language, systemImage: "globe")
                .font(.headline)
            
            Picker(Localized.Settings.language, selection: $selectedLanguage) {
                Text("English").tag("en")
                Text("Português (Brasil)").tag("pt-BR")
            }
            .pickerStyle(.segmented)
            // Language setting is saved via @AppStorage and will be read by the keyboard extension
            
            Text(Localized.isPortuguese ? 
                 "Selecione o idioma para previsão de palavras e correção ortográfica" :
                 "Select language for word prediction and spell checking")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
    
    // MARK: - Key Size Section
    
    private var keySizeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label(Localized.Settings.keySize, systemImage: "arrow.up.left.and.arrow.down.right")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(Localized.isPortuguese ? 
                     "Altura das Teclas: \(Int(keyHeight)) pontos" : 
                     "Key Height: \(Int(keyHeight)) points")
                    .font(.subheadline)
                
                Slider(value: $keyHeight, in: 50...120, step: 5) {
                    Text(Localized.isPortuguese ? "Altura das Teclas" : "Key Height")
                } minimumValueLabel: {
                    Text("50")
                        .font(.caption)
                } maximumValueLabel: {
                    Text("120")
                        .font(.caption)
                }
                .accessibilityValue("\(Int(keyHeight)) \(Localized.isPortuguese ? "pontos" : "points")")
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(Localized.isPortuguese ? 
                     "Tamanho da Fonte: \(Int(fontSize)) pontos" : 
                     "Font Size: \(Int(fontSize)) points")
                    .font(.subheadline)
                
                Slider(value: $fontSize, in: 18...48, step: 2) {
                    Text(Localized.Settings.fontSize)
                } minimumValueLabel: {
                    Text("18")
                        .font(.caption)
                } maximumValueLabel: {
                    Text("48")
                        .font(.caption)
                }
                .accessibilityValue("\(Int(fontSize)) \(Localized.isPortuguese ? "pontos" : "points")")
            }
            
            // Quick presets
            HStack(spacing: 12) {
                PresetButton(title: Localized.isPortuguese ? "Médio" : "Medium", 
                           keyHeight: 60, fontSize: 24, 
                           currentKeyHeight: $keyHeight, currentFontSize: $fontSize)
                PresetButton(title: Localized.isPortuguese ? "Grande" : "Large", 
                           keyHeight: 80, fontSize: 32, 
                           currentKeyHeight: $keyHeight, currentFontSize: $fontSize)
                PresetButton(title: Localized.isPortuguese ? "Extra Grande" : "Extra Large", 
                           keyHeight: 100, fontSize: 40, 
                           currentKeyHeight: $keyHeight, currentFontSize: $fontSize)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
    
    // MARK: - Appearance Section
    
    private var appearanceSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label(Localized.isPortuguese ? "Aparência" : "Appearance", systemImage: "eye.fill")
                .font(.headline)
            
            Toggle(isOn: $useHighContrast) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(Localized.Settings.highContrast)
                        .font(.body)
                    Text(Localized.Settings.highContrastDescription)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: .blue))
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
    
    // MARK: - Feedback Section
    
    private var feedbackSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label(Localized.isPortuguese ? "Feedback" : "Feedback", systemImage: "hand.tap.fill")
                .font(.headline)
            
            Toggle(isOn: $enableSoundFeedback) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(Localized.Settings.soundFeedback)
                        .font(.body)
                    Text(Localized.isPortuguese ? 
                         "Toca um som quando as teclas são pressionadas" : 
                         "Play a sound when keys are pressed")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: .blue))
            
            Toggle(isOn: $enableHapticFeedback) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(Localized.Settings.hapticFeedback)
                        .font(.body)
                    Text(Localized.isPortuguese ? 
                         "Vibração quando as teclas são pressionadas" : 
                         "Vibration when keys are pressed")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: .blue))
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
    
    // MARK: - Smart Features Section
    
    private var smartFeaturesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label(Localized.isPortuguese ? "Recursos Inteligentes" : "Smart Features", 
                  systemImage: "brain.head.profile")
                .font(.headline)
            
            Toggle(isOn: $enableAutocomplete) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(Localized.Settings.autocomplete)
                        .font(.body)
                    Text(Localized.Settings.autocompleteDescription)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: .blue))
            
            // Info about auto-capitalization
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.blue)
                
                Text(Localized.isPortuguese ? 
                     "A capitalização automática está sempre ativa no início das frases" :
                     "Auto-capitalization is always enabled at the start of sentences")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
    
    // MARK: - Preview Section
    
    private var previewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label(Localized.Settings.preview, systemImage: "rectangle.and.hand.point.up.left.fill")
                .font(.headline)
            
            KeyboardPreview(
                keyHeight: keyHeight,
                fontSize: fontSize,
                useHighContrast: useHighContrast
            )
            .frame(height: 200)
            .cornerRadius(12)
            .accessibilityLabel(Localized.isPortuguese ? 
                               "Visualização do teclado mostrando configurações atuais" :
                               "Keyboard preview showing current settings")
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
    
    // MARK: - Actions
    
    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Supporting Views

struct InstructionRow: View {
    let number: Int
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.caption)
                .fontWeight(.bold)
                .frame(width: 24, height: 24)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Step \(number): \(text)")
    }
}

struct PresetButton: View {
    let title: String
    let keyHeight: Double
    let fontSize: Double
    @Binding var currentKeyHeight: Double
    @Binding var currentFontSize: Double
    
    private var isSelected: Bool {
        currentKeyHeight == keyHeight && currentFontSize == fontSize
    }
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                currentKeyHeight = keyHeight
                currentFontSize = fontSize
            }
        }) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color(.systemGray5))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(8)
        }
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

struct KeyboardPreview: View {
    let keyHeight: Double
    let fontSize: Double
    let useHighContrast: Bool
    
    private let previewKeys = ["Q", "W", "E", "R", "T", "Y"]
    
    var body: some View {
        VStack(spacing: 4) {
            // Sample row of keys
            HStack(spacing: 4) {
                ForEach(previewKeys, id: \.self) { key in
                    PreviewKey(
                        title: key,
                        fontSize: min(fontSize, 28), // Cap preview font size
                        useHighContrast: useHighContrast
                    )
                }
            }
            
            // Space bar preview
            HStack(spacing: 4) {
                PreviewKey(title: "🌐", fontSize: 20, useHighContrast: useHighContrast, isSpecial: true)
                    .frame(width: 50)
                
                PreviewKey(title: "space", fontSize: 16, useHighContrast: useHighContrast, isSpecial: false)
                
                PreviewKey(title: "return", fontSize: 14, useHighContrast: useHighContrast, isSpecial: true)
                    .frame(width: 80)
            }
        }
        .padding(8)
        .background(Color(red: 0.15, green: 0.15, blue: 0.2))
    }
}

struct PreviewKey: View {
    let title: String
    let fontSize: Double
    let useHighContrast: Bool
    var isSpecial: Bool = false
    
    var body: some View {
        Text(title)
            .font(.system(size: fontSize, weight: .bold))
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(keyBackground)
            .foregroundColor(keyForeground)
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(borderColor, lineWidth: useHighContrast ? 2 : 1)
            )
    }
    
    private var keyBackground: Color {
        if useHighContrast {
            return isSpecial ? Color(red: 0.2, green: 0.2, blue: 0.3) : .white
        } else {
            return isSpecial ? Color(.systemGray2) : .white
        }
    }
    
    private var keyForeground: Color {
        if useHighContrast {
            return isSpecial ? .white : .black
        } else {
            return isSpecial ? .white : .black
        }
    }
    
    private var borderColor: Color {
        useHighContrast ? (isSpecial ? .white : .black) : Color(.systemGray3)
    }
}

#Preview {
    ContentView()
}
