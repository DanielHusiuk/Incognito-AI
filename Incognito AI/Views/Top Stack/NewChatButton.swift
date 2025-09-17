//
//  NewChatButton.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 16.09.2025.
//

import UIKit

class NewChatButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buttonSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        buttonSetup()
    }

    func buttonSetup() {
        translatesAutoresizingMaskIntoConstraints = false
        imageView?.contentMode = .scaleAspectFit
        setImage(UIImage(systemName: "plus.circle"), for: .normal)
        setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 22, weight: .regular), forImageIn: .normal)
        tintColor = .white
        layer.cornerRadius = 25
        alpha = 0.9
        
        addTarget(self, action: #selector(newChatButtonTouchDown), for: [.touchDown, .touchDragEnter, .touchDownRepeat])
        addTarget(self, action: #selector(newChatButtonCancel), for: [.touchCancel, .touchDragExit, .touchUpOutside])
        addTarget(self, action: #selector(newChatButtonTouchUp), for: [.touchUpInside])
    }
    
    @objc func newChatButtonTouchDown() {
        isHighlighted = true
    }
    
    @objc func newChatButtonCancel() {
        isHighlighted = false
    }
    
    @objc func newChatButtonTouchUp() {
        isHighlighted = false
        if UserDefaults.standard.bool(forKey: "HapticState") {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }

}
