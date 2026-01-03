//
//  KeyView.swift
//  AccessibleKeyboard
//
//  Large, accessible key button with high contrast support and popup preview
//

import UIKit

class KeyView: UIButton {
    
    // MARK: - Properties
    
    var widthMultiplier: CGFloat = 1.0
    var isSpecialKey = false {
        didSet { updateAppearance() }
    }
    var isSpaceKey = false
    var showPopupPreview = true
    
    var fontSize: CGFloat = 24 {
        didSet {
            titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        }
    }
    
    var highContrast: Bool = true {
        didSet { updateAppearance() }
    }
    
    private var normalBackgroundColor: UIColor = .white
    private var highlightedBackgroundColor: UIColor = .systemGray4
    private var popupView: UIView?
    private var popupLabel: UILabel?
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? highlightedBackgroundColor : normalBackgroundColor
        }
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupAppearance()
    }
    
    // MARK: - Setup
    
    private func setupAppearance() {
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 2
        clipsToBounds = false
        
        // Accessibility
        isAccessibilityElement = true
        accessibilityTraits = .keyboardKey
    }
    
    func configure(
        title: String,
        fontSize: CGFloat,
        useHighContrast: Bool,
        isSpecialKey: Bool = false
    ) {
        self.isSpecialKey = isSpecialKey
        
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        
        if useHighContrast {
            configureHighContrast(isSpecialKey: isSpecialKey)
        } else {
            configureStandardContrast(isSpecialKey: isSpecialKey)
        }
        
        accessibilityLabel = title
    }
    
    private func configureHighContrast(isSpecialKey: Bool) {
        if isSpecialKey {
            normalBackgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.3, alpha: 1.0)
            highlightedBackgroundColor = UIColor(red: 0.4, green: 0.4, blue: 0.5, alpha: 1.0)
            setTitleColor(.white, for: .normal)
            layer.borderColor = UIColor.white.cgColor
            layer.borderWidth = 2
        } else {
            normalBackgroundColor = .white
            highlightedBackgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.7, alpha: 1.0)
            setTitleColor(.black, for: .normal)
            layer.borderColor = UIColor.black.cgColor
            layer.borderWidth = 2
        }
        
        backgroundColor = normalBackgroundColor
    }
    
    private func configureStandardContrast(isSpecialKey: Bool) {
        if isSpecialKey {
            normalBackgroundColor = .systemGray2
            highlightedBackgroundColor = .systemGray
            setTitleColor(.white, for: .normal)
        } else {
            normalBackgroundColor = .white
            highlightedBackgroundColor = .systemGray5
            setTitleColor(.black, for: .normal)
        }
        
        layer.borderColor = UIColor.systemGray3.cgColor
        layer.borderWidth = 1
        backgroundColor = normalBackgroundColor
    }
    
    // MARK: - Layout
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 60)
    }
    
    // MARK: - Popup Preview
    
    private func showPopup() {
        guard showPopupPreview, !isSpecialKey, let title = currentTitle, title.count == 1 else { return }
        
        // Remove existing popup
        popupView?.removeFromSuperview()
        
        // Create popup view
        let popupSize: CGFloat = bounds.width * 1.4
        let popup = UIView(frame: CGRect(
            x: (bounds.width - popupSize) / 2,
            y: -popupSize - 8,
            width: popupSize,
            height: popupSize
        ))
        popup.backgroundColor = normalBackgroundColor
        popup.layer.cornerRadius = 12
        popup.layer.borderWidth = layer.borderWidth
        popup.layer.borderColor = layer.borderColor
        popup.layer.shadowColor = UIColor.black.cgColor
        popup.layer.shadowOffset = CGSize(width: 0, height: 4)
        popup.layer.shadowOpacity = 0.4
        popup.layer.shadowRadius = 4
        
        // Create label
        let label = UILabel(frame: popup.bounds)
        label.text = title
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: (titleLabel?.font.pointSize ?? 24) * 1.5, weight: .bold)
        label.textColor = titleLabel?.textColor
        popup.addSubview(label)
        
        // Add connector to key
        let connectorHeight: CGFloat = 12
        let connector = UIView(frame: CGRect(
            x: (popupSize - bounds.width * 0.8) / 2,
            y: popupSize - 4,
            width: bounds.width * 0.8,
            height: connectorHeight
        ))
        connector.backgroundColor = normalBackgroundColor
        popup.addSubview(connector)
        
        addSubview(popup)
        popupView = popup
        popupLabel = label
        
        // Animate in
        popup.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        popup.alpha = 0
        UIView.animate(withDuration: 0.1) {
            popup.transform = .identity
            popup.alpha = 1
        }
    }
    
    private func hidePopup() {
        guard let popup = popupView else { return }
        
        UIView.animate(withDuration: 0.1, animations: {
            popup.alpha = 0
            popup.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            popup.removeFromSuperview()
        }
        popupView = nil
        popupLabel = nil
    }
    
    // MARK: - Touch Handling for Visual Feedback
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animatePress(pressed: true)
        showPopup()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animatePress(pressed: false)
        hidePopup()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animatePress(pressed: false)
        hidePopup()
    }
    
    private func animatePress(pressed: Bool) {
        UIView.animate(withDuration: 0.08) {
            self.transform = pressed ? CGAffineTransform(scaleX: 0.97, y: 0.97) : .identity
        }
    }
    
    // MARK: - Public Methods
    
    func setTitle(_ title: String) {
        setTitle(title, for: .normal)
        accessibilityLabel = title
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        updateAppearance()
    }
    
    func updateAppearance() {
        if highContrast {
            configureHighContrast(isSpecialKey: isSpecialKey)
        } else {
            configureStandardContrast(isSpecialKey: isSpecialKey)
        }
        
        if isSpaceKey {
            normalBackgroundColor = UIColor(white: 0.95, alpha: 1.0)
            backgroundColor = normalBackgroundColor
        }
    }
}
