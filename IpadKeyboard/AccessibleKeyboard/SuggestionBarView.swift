//
//  SuggestionBarView.swift
//  AccessibleKeyboard
//
//  Autocomplete suggestions bar with large, accessible buttons
//

import UIKit

protocol SuggestionBarDelegate: AnyObject {
    func didSelectSuggestion(_ suggestion: String)
}

class SuggestionBarView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: SuggestionBarDelegate?
    var onSuggestionSelected: ((String) -> Void)?
    
    private var stackView: UIStackView!
    private var suggestionButtons: [UIButton] = []
    private var fontSize: CGFloat = 24
    private var useHighContrast = true
    private let containerPadding: CGFloat = 10
    
    // MARK: - Initialization
    
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
        layer.cornerRadius = 10
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 2)
        
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(stackView)
        
        // Create 3 suggestion buttons
        for i in 0..<3 {
            let button = createSuggestionButton()
            button.tag = i
            suggestionButtons.append(button)
            stackView.addArrangedSubview(button)
        }
    }
    
    private func createSuggestionButton() -> UIButton {
        let button = UIButton(type: .system)
    button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
    button.titleLabel?.adjustsFontSizeToFitWidth = true
    button.titleLabel?.minimumScaleFactor = 0.7
    button.titleLabel?.lineBreakMode = .byTruncatingTail
    button.layer.cornerRadius = 8
    button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 14, bottom: 12, right: 14)
        button.addTarget(self, action: #selector(suggestionTapped(_:)), for: .touchUpInside)
        
        updateButtonAppearance(button)
        
        return button
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let verticalInset = containerPadding * 0.6
        stackView.frame = bounds.insetBy(dx: containerPadding, dy: verticalInset)
    }
    
    private func updateButtonAppearance(_ button: UIButton) {
        if useHighContrast {
            button.backgroundColor = UIColor(red: 0.25, green: 0.25, blue: 0.3, alpha: 1.0)
            button.setTitleColor(.white, for: .normal)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        } else {
            button.backgroundColor = UIColor.systemGray4
            button.setTitleColor(.label, for: .normal)
            button.layer.borderWidth = 0
        }
    }
    
    // MARK: - Public Methods
    
    func configure(fontSize: CGFloat, useHighContrast: Bool) {
        self.fontSize = fontSize
        self.useHighContrast = useHighContrast
        
        for button in suggestionButtons {
            button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
            updateButtonAppearance(button)
        }
    }
    
    func updateSuggestions(_ suggestions: [String]) {
        for (index, button) in suggestionButtons.enumerated() {
            if index < suggestions.count {
                button.setTitle(suggestions[index], for: .normal)
                button.isHidden = false
                button.isEnabled = true
                button.alpha = 1.0
            } else {
                button.setTitle("", for: .normal)
                button.isHidden = false
                button.isEnabled = false
                button.alpha = 0.3
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func suggestionTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle, !title.isEmpty else { return }
        
        // Visual feedback
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                sender.transform = .identity
            }
        }
        
        delegate?.didSelectSuggestion(title)
        onSuggestionSelected?(title)
    }
}
