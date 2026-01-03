//
//  KeyboardViewController.swift
//  AccessibleKeyboard
//
//  Simplified keyboard controller with frame-based layout.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    private var keyboardView: AccessibleKeyboardView!
    private var suggestionBar: SuggestionBarView!
    private var currentWord: String = ""

    // User preferences
    private var keySize: CGFloat = 76 // larger default for low vision
    private var fontSize: CGFloat = 30 // larger default for low vision
    private var highContrast: Bool = true
    private var soundEnabled: Bool = true
    private var hapticEnabled: Bool = true
    private var currentLanguage: WordPredictionEngine.Language = .english

    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide the system copy/paste/undo toolbar that overlaps the suggestion bar on iPad
        let assistant = inputAssistantItem
        assistant.leadingBarButtonGroups = []
        assistant.trailingBarButtonGroups = []
        if #available(iOS 15.0, *) {
            assistant.allowsHidingShortcuts = true
        }
        loadUserPreferences()
        setupKeyboard()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserPreferences()
        updateKeyboardAppearance()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutKeyboard()
    }

    private func loadUserPreferences() {
        let defaults = UserDefaults(suiteName: "group.com.ipadkeyboard.accessible") ?? UserDefaults.standard

        keySize = CGFloat(defaults.float(forKey: "keySize"))
        if keySize == 0 { keySize = 76 }

        fontSize = CGFloat(defaults.float(forKey: "fontSize"))
        if fontSize == 0 { fontSize = 30 }

        highContrast = defaults.object(forKey: "highContrast") as? Bool ?? true
        soundEnabled = defaults.object(forKey: "soundEnabled") as? Bool ?? true
        hapticEnabled = defaults.object(forKey: "hapticEnabled") as? Bool ?? true

        // Auto-detect: if preferred language is Portuguese, use pt-BR, otherwise English.
        let preferred = Locale.preferredLanguages.first?.lowercased() ?? ""
        if preferred.hasPrefix("pt") {
            currentLanguage = .portugueseBrazil
        } else {
            currentLanguage = .english
        }

        WordPredictionEngine.shared.setLanguage(currentLanguage)
    }

    private func setupKeyboard() {
        suggestionBar = SuggestionBarView()
        suggestionBar.onSuggestionSelected = { [weak self] suggestion in
            self?.insertSuggestion(suggestion)
        }
        suggestionBar.configure(fontSize: fontSize, useHighContrast: highContrast)
        view.addSubview(suggestionBar)

        keyboardView = AccessibleKeyboardView()
        keyboardView.keySize = keySize
        keyboardView.fontSize = fontSize
        keyboardView.highContrast = highContrast
        keyboardView.soundEnabled = soundEnabled
        keyboardView.hapticEnabled = hapticEnabled

        keyboardView.onKeyTap = { [weak self] key in
            self?.handleKeyTap(key)
        }
        keyboardView.onBackspace = { [weak self] in
            self?.handleBackspace()
        }
        keyboardView.onReturn = { [weak self] in
            self?.handleReturn()
        }
        keyboardView.onSpace = { [weak self] in
            self?.handleSpace()
        }
        keyboardView.onGlobePress = { [weak self] in
            self?.advanceToNextInputMode()
        }

        view.addSubview(keyboardView)
    }

    private func layoutKeyboard() {
        let bounds = view.bounds
        guard bounds.width > 0 && bounds.height > 0 else { return }

        let insets = view.safeAreaInsets
        let availableHeight = bounds.height - insets.top - insets.bottom

        // Suggestion bar adapts: roomy by default, but capped in compact layouts
        let baseSuggestionHeight = max(68, fontSize * 2.2)
        let suggestionHeight = min(baseSuggestionHeight, availableHeight * 0.25)
        let verticalSpacing: CGFloat = min(12, max(6, availableHeight * 0.02))

        let suggestionY = insets.top
        suggestionBar.frame = CGRect(x: 0, y: suggestionY, width: bounds.width, height: suggestionHeight)

        let keyboardY = suggestionY + suggestionHeight + verticalSpacing
        let keyboardHeight = bounds.height - keyboardY - insets.bottom
        keyboardView.frame = CGRect(x: 0, y: keyboardY, width: bounds.width, height: max(0, keyboardHeight))
        keyboardView.layoutIfNeeded()
    }

    private func updateKeyboardAppearance() {
        keyboardView?.keySize = keySize
        keyboardView?.fontSize = fontSize
        keyboardView?.highContrast = highContrast
        keyboardView?.soundEnabled = soundEnabled
        keyboardView?.hapticEnabled = hapticEnabled
        keyboardView?.updateAppearance()
        suggestionBar?.configure(fontSize: fontSize, useHighContrast: highContrast)
    }

    // MARK: - Key Handling
    private func handleKeyTap(_ key: String) {
        textDocumentProxy.insertText(key)
        currentWord += key
        updateSuggestions()
    }

    private func handleBackspace() {
        textDocumentProxy.deleteBackward()
        if !currentWord.isEmpty { currentWord.removeLast() }
        updateSuggestions()
    }

    private func handleReturn() {
        textDocumentProxy.insertText("\n")
        learnCurrentWord()
        currentWord = ""
        updateSuggestions()
    }

    private func handleSpace() {
        textDocumentProxy.insertText(" ")
        learnCurrentWord()
        currentWord = ""
        updateSuggestions()
    }

    private func insertSuggestion(_ suggestion: String) {
        for _ in 0..<currentWord.count { textDocumentProxy.deleteBackward() }
        textDocumentProxy.insertText(suggestion + " ")
        WordPredictionEngine.shared.learnWord(suggestion)
        currentWord = ""
        updateSuggestions()
    }

    private func updateSuggestions() {
        if currentWord.isEmpty {
            let context = textDocumentProxy.documentContextBeforeInput ?? ""
            let words = context.components(separatedBy: .whitespaces)
            let lastWord = words.dropLast().last ?? ""
            if !lastWord.isEmpty {
                let predictions = WordPredictionEngine.shared.getNextWordPredictions(after: lastWord)
                suggestionBar.updateSuggestions(predictions)
            } else {
                suggestionBar.updateSuggestions([])
            }
        } else {
            let predictions = WordPredictionEngine.shared.getPredictions(for: currentWord)
            suggestionBar.updateSuggestions(predictions)
        }
    }

    private func learnCurrentWord() {
        if currentWord.count >= 2 {
            WordPredictionEngine.shared.learnWord(currentWord)
        }
    }

    override func textDidChange(_ textInput: UITextInput?) {
        super.textDidChange(textInput)
        if let context = textDocumentProxy.documentContextBeforeInput {
            let words = context.components(separatedBy: .whitespaces)
            currentWord = words.last ?? ""
        } else {
            currentWord = ""
        }
        updateSuggestions()
    }
}
