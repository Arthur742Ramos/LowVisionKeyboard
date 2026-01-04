//
//  AccessibleKeyboardView.swift
//  AccessibleKeyboard
//
//  Container view for the accessible keyboard layout
//

import UIKit
import AudioToolbox

class AccessibleKeyboardView: UIView {
    // MARK: - Public Properties
    var keySize: CGFloat = 60 { didSet { setNeedsLayout() } }
    var fontSize: CGFloat = 24 { didSet { updateAppearance() } }
    var highContrast: Bool = true { didSet { updateAppearance() } }
    var soundEnabled: Bool = true
    var hapticEnabled: Bool = true
    
    // Language setting - determines which layout to use
    var isPortuguese: Bool = false { didSet { if oldValue != isPortuguese { createKeys(); setNeedsLayout() } } }

    // MARK: - Callbacks
    var onKeyTap: ((String) -> Void)?
    var onBackspace: (() -> Void)?
    var onReturn: (() -> Void)?
    var onSpace: (() -> Void)?
    var onGlobePress: (() -> Void)?

    // MARK: - Private Properties
    private var isShifted: Bool = false
    private var isCapsLock: Bool = false
    private var isNumberMode: Bool = false
    private var isAccentMode: Bool = false
    private var keyViews: [KeyView] = []

    // English QWERTY layout
    private let englishLetterLayout: [[String]] = [
        ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
        ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
        ["⇧", "Z", "X", "C", "V", "B", "N", "M", "⌫"],
        ["🌐", "123", " ", ".", "↩"]
    ]
    
    // Portuguese QWERTY layout - includes Ç key
    private let portugueseLetterLayout: [[String]] = [
        ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
        ["A", "S", "D", "F", "G", "H", "J", "K", "L", "Ç"],
        ["⇧", "Z", "X", "C", "V", "B", "N", "M", "⌫"],
        ["🌐", "123", "ÁÀ", " ", ".", "↩"]
    ]
    
    // Accent layout for Portuguese - easy access to all accented characters
    private let accentLayout: [[String]] = [
        ["Á", "À", "Â", "Ã", "É", "Ê", "Í", "Ó", "Ô", "Õ"],
        ["Ú", "Ç", "1", "2", "3", "4", "5", "6", "7", "8"],
        ["ABC", "9", "0", "!", "?", ",", ".", "⌫"],
        ["🌐", "ABC", " ", ".", "↩"]
    ]

    private let numberLayout: [[String]] = [
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
        ["-", "/", ";", ":", "(", ")", "$", "&", "@", "\""],
        ["ABC", ".", ",", "?", "!", "'", "⌫"],
        ["🌐", "ABC", " ", ".", "↩"]
    ]
    
    private var letterLayout: [[String]] {
        isPortuguese ? portugueseLetterLayout : englishLetterLayout
    }

    private var activeLayout: [[String]] {
        if isAccentMode { return accentLayout }
        return isNumberMode ? numberLayout : letterLayout
    }

    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Setup
    private func setupView() {
        backgroundColor = UIColor(red: 0.12, green: 0.12, blue: 0.15, alpha: 1.0)
        feedbackGenerator.prepare()
        createKeys()
    }

    private func createKeys() {
        keyViews.forEach { $0.removeFromSuperview() }
        keyViews.removeAll()

        for row in activeLayout {
            for keyChar in row {
                let keyView = KeyView()
                keyView.setTitle(keyChar)
                keyView.fontSize = fontSize
                keyView.highContrast = highContrast
                keyView.addTarget(self, action: #selector(keyTapped(_:)), for: .touchUpInside)

                if ["⇧", "⌫", "↩", "123", "ABC", "🌐", "ÁÀ"].contains(keyChar) {
                    keyView.isSpecialKey = true
                }
                if keyChar == " " { keyView.isSpaceKey = true }

                addSubview(keyView)
                keyViews.append(keyView)
            }
        }
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()

        let bounds = self.bounds
        guard bounds.width > 0 && bounds.height > 0 else { return }

    let horizontalPadding: CGFloat = 8
    let verticalPadding: CGFloat = 10
    let keySpacing: CGFloat = 8
    let rowCount = activeLayout.count

    let availableHeight = bounds.height - (verticalPadding * 2) - (keySpacing * CGFloat(rowCount - 1))
    let rowHeight = max(10, availableHeight / CGFloat(rowCount))

        var keyIndex = 0
    for (rowIndex, row) in activeLayout.enumerated() {
            let availableWidth = bounds.width - (horizontalPadding * 2) - (keySpacing * CGFloat(row.count - 1))

            var keyWidths: [CGFloat] = []
            var totalMultiplier: CGFloat = 0
            for keyChar in row {
                let multiplier: CGFloat
                switch keyChar {
                case " ": multiplier = 4.0
                case "⇧", "⌫", "↩", "123", "ABC", "ÁÀ": multiplier = 1.5
                default: multiplier = 1.0
                }
                keyWidths.append(multiplier)
                totalMultiplier += multiplier
            }

            let unitWidth = availableWidth / totalMultiplier
            var xOffset = horizontalPadding
            let yOffset = verticalPadding + (CGFloat(rowIndex) * (rowHeight + keySpacing))

            for i in 0..<row.count {
                let width = unitWidth * keyWidths[i]
                if keyIndex < keyViews.count {
                    let keyView = keyViews[keyIndex]
                    keyView.frame = CGRect(x: xOffset, y: yOffset, width: width, height: rowHeight)
                    keyView.fontSize = min(fontSize, rowHeight * 0.65)
                    keyIndex += 1
                }
                xOffset += width + keySpacing
            }
        }
    }

    // MARK: - Actions
    @objc private func keyTapped(_ sender: KeyView) {
        guard let title = sender.titleLabel?.text else { return }

        if soundEnabled { AudioServicesPlaySystemSound(1104) }
        if hapticEnabled { feedbackGenerator.impactOccurred() }

        switch title {
        case "⇧":
            if !isNumberMode && !isAccentMode { handleShift() }
        case "⌫":
            onBackspace?()
        case "↩":
            onReturn?()
        case " ":
            onSpace?()
        case "🌐":
            onGlobePress?()
        case "123":
            toggleNumberMode()
        case "ABC":
            // Return to letter mode from either number or accent mode
            isNumberMode = false
            isAccentMode = false
            isShifted = false
            isCapsLock = false
            createKeys()
            setNeedsLayout()
        case "ÁÀ":
            toggleAccentMode()
        default:
            let keyToInsert = (isShifted || isCapsLock) ? title.uppercased() : title.lowercased()
            onKeyTap?(keyToInsert)
            if !isNumberMode && !isAccentMode {
                if isShifted && !isCapsLock {
                    isShifted = false
                    updateShiftState()
                }
            }
        }
    }

    private func handleShift() {
        if isShifted && !isCapsLock {
            isCapsLock = true
        } else if isCapsLock {
            isShifted = false
            isCapsLock = false
        } else {
            isShifted = true
        }
        updateShiftState()
    }

    private func toggleNumberMode() {
        isNumberMode = true
        isAccentMode = false
        isShifted = false
        isCapsLock = false
        createKeys()
        setNeedsLayout()
    }
    
    private func toggleAccentMode() {
        isAccentMode.toggle()
        isNumberMode = false
        isShifted = false
        isCapsLock = false
        createKeys()
        setNeedsLayout()
    }

    private func updateShiftState() {
        for keyView in keyViews {
            guard let title = keyView.titleLabel?.text else { continue }
            if title == "⇧" {
                if isCapsLock {
                    keyView.backgroundColor = .systemBlue
                } else if isShifted {
                    keyView.backgroundColor = .white
                    keyView.setTitleColor(.black, for: .normal)
                } else {
                    keyView.backgroundColor = UIColor(white: 0.35, alpha: 1.0)
                    keyView.setTitleColor(.white, for: .normal)
                }
            } else if title.count == 1 && title.rangeOfCharacter(from: .letters) != nil {
                let displayText = (isShifted || isCapsLock) ? title.uppercased() : title.lowercased()
                keyView.setTitle(displayText, for: .normal)
            }
        }
    }

    // MARK: - Public
    func updateAppearance() {
        for keyView in keyViews {
            keyView.fontSize = fontSize
            keyView.highContrast = highContrast
            keyView.updateAppearance()
        }
    }
}
