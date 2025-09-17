//
//  AiButton.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 16.09.2025.
//

import UIKit

class AiButton: UIButton {

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
        setImage(UIImage(systemName: "apple.intelligence"), for: .normal)
        setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(weight: .semibold), forImageIn: .normal)
        tintColor = .systemGray2
        backgroundColor = .systemGray6
        layer.borderColor = UIColor.systemGray5.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 25
        alpha = 0.9
        
        addTarget(self, action: #selector(aiButtonTouchDown), for: [.touchDown, .touchDragEnter, .touchDownRepeat])
        addTarget(self, action: #selector(aiButtonCancel), for: [.touchCancel, .touchDragExit, .touchUpOutside])
        addTarget(self, action: #selector(aiButtonTouchUp), for: [.touchUpInside])
    }
    
    @objc func aiButtonTouchDown() {
        tintColor = .white
        backgroundColor = .systemGray3
        layer.borderColor = UIColor.systemGray2.cgColor
    }
    
    @objc func aiButtonCancel() {
        tintColor = .systemGray2
        backgroundColor = .systemGray6
        layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    @objc func aiButtonTouchUp() {
        tintColor = .systemGray2
        backgroundColor = .systemGray6
        layer.borderColor = UIColor.systemGray5.cgColor
    }

}
