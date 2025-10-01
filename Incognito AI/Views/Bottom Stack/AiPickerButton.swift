//
//  AiPickerButton.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 29.09.2025.
//

import UIKit

class AiPickerButton: UIButton {
    
    var action: (() -> Void)?
    
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
        tintColor = .systemGray2
        backgroundColor = .clear
        layer.cornerRadius = 21
        alpha = 0.9
        self.action = model.action
        
        addTarget(self, action: #selector(buttonTouchDown), for: [.touchDown, .touchDragEnter, .touchDownRepeat])
        addTarget(self, action: #selector(buttonCancel), for: [.touchCancel, .touchDragExit, .touchUpOutside])
        addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside])
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 42),
            widthAnchor.constraint(equalTo: heightAnchor),
            imageView!.heightAnchor.constraint(equalToConstant: 12),
            imageView!.widthAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    
    
    @objc func buttonTouchDown() {
        backgroundColor = .systemGray
    }
    
    @objc func buttonCancel() {
        backgroundColor = .clear
    }
    
    @objc func buttonTouchUp() {
        backgroundColor = .clear
        action?()
        if UserDefaults.standard.bool(forKey: "HapticState") {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }
    
}
