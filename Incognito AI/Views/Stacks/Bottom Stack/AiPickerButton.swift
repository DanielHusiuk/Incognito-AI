//
//  AiPickerButton.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 29.09.2025.
//

import UIKit

class AiPickerButton: UIButton {
    
    var action: ((PickerButton) -> Void)?
    var model: PickerButton?
    
    init(model: PickerButton) {
        super.init(frame: .zero)
        buttonSetup(with: model)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("aiPickerButton error \n init(coder:) has not been implemented")
    }
    
    func buttonSetup(with model: PickerButton) {
        translatesAutoresizingMaskIntoConstraints = false
        imageView?.contentMode = .scaleAspectFit
        setImage(model.image, for: .normal)
        tintColor = .systemGray2
        backgroundColor = .clear
        layer.cornerRadius = 19
        self.model = model
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
        tintColor = .white
        backgroundColor = .systemGray4
    }
    
    @objc func buttonCancel() {
        UIView.animate(withDuration: 0.1, animations: {
            self.tintColor = .systemGray2
            self.backgroundColor = .clear
        })
    }
    
    @objc func buttonTouchUp() {
        UIView.animate(withDuration: 0.1, animations: {
            self.tintColor = .systemGray2
            self.backgroundColor = .clear
        })
        
        if let model = model {
            action?(model)
        }

        if UserDefaults.standard.bool(forKey: "HapticState") {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }
    
    func setSelected(_ selected: Bool) {
        if selected {
            tintColor = .pickedButtonGray
            backgroundColor = .systemGray4
            isEnabled = false
        } else {
            UIView.animate(withDuration: 0.1, animations: {
                self.tintColor = .systemGray2
                self.backgroundColor = .clear
                self.isEnabled = true
            })
        }
    }
    
}
