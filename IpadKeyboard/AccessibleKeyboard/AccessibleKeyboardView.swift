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

    // MARK: - Callbacks
    var onKeyTap: ((String) -> Void)?
    var onBackspace: (() -> Void)?
    var onReturn: (() -> Void)?
    var onSpace: (() -> Void)?
    var onGlobePress: (() -> Void)?

    // MARK: - Private Properties
    private var isShifted: Bool = false
    private var isCapsLock: Bool = false
    private var keyViews: [KeyView] = []

    private let keyboardLayout: [[String]] = [
        ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
        ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
        ["⇧", "Z", "X", "C", "V", "B", "N", "M", "⌫"],
        ["🌐", "123", " ", ".", "↩"]
    ]

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

        for row in keyboardLayout {
            for keyChar in row {
                let keyView = KeyView()
                keyView.setTitle(keyChar)
                keyView.fontSize = fontSize
                keyView.highContrast = highContrast
                keyView.addTarget(self, action: #selector(keyTapped(_:)), for: .touchUpInside)

                if ["⇧", "⌫", "↩", "123", "🌐"].contains(keyChar) {
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

        let horizontalPadding: CGFloat = 4
        let verticalPadding: CGFloat = 6
        let keySpacing: CGFloat = 5
        let rowCount = keyboardLayout.count

        let availableHeight = bounds.height - (verticalPadding * 2) - (keySpacing * CGFloat(rowCount - 1))
        let rowHeight = availableHeight / CGFloat(rowCount)

        var keyIndex = 0
        for (rowIndex, row) in keyboardLayout.enumerated() {
            let availableWidth = bounds.width - (horizontalPadding * 2) - (keySpacing * CGFloat(row.count - 1))

            var keyWidths: [CGFloat] = []
            var totalMultiplier: CGFloat = 0
            for keyChar in row {
                let multiplier: CGFloat
                switch keyChar {
                case " ": multiplier = 4.0
                case "⇧", "⌫", "↩", "123": multiplier = 1.5
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
                    keyView.fontSize = min(fontSize, rowHeight * 0.5)
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
            handleShift()
        case "⌫":
            onBackspace?()
        case "↩":
            onReturn?()
        case " ":
            onSpace?()
        case "🌐":
            onGlobePress?()
        case "123":
            break // TODO: number/symbol mode
        default:
            let keyToInsert = (isShifted || isCapsLock) ? title.uppercased() : title.lowercased()
            onKeyTap?(keyToInsert)
            if isShifted && !isCapsLock {
                isShifted = false
                updateShiftState()
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
