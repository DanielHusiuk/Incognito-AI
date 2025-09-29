//
//  AiPickerButton.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 29.09.2025.
//

import UIKit

class AiPickerButton: UIButton {
    
    let aiPickerButton = UIView()
    
    init(model: Button) {
        super.init(frame: .zero)
        buttonSetup(with: model)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError( "aiPickerButton error \n init(coder:) has not been implemented" )
    }
    
    func buttonSetup(with model: Button) {
        translatesAutoresizingMaskIntoConstraints = false
        imageView?.contentMode = .scaleAspectFit
        setImage(model.image, for: .normal)
        setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(weight: .semibold), forImageIn: .normal)
        tintColor = .systemGray2
        backgroundColor = .clear
        layer.cornerRadius = 21
        alpha = 0.9
        
        addTarget(self, action: #selector(buttonTouchDown), for: [.touchDown, .touchDragEnter, .touchDownRepeat])
        addTarget(self, action: #selector(buttonCancel), for: [.touchCancel, .touchDragExit, .touchUpOutside])
        addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside])
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    
    
    @objc func buttonTouchDown() {
        backgroundColor = .blue
    }
    
    @objc func buttonCancel() {
        backgroundColor = .clear
    }
    
    @objc func buttonTouchUp() {
        backgroundColor = .clear
        if UserDefaults.standard.bool(forKey: "HapticState") {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }
    
}
