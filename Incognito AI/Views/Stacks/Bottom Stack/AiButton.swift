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
        transform = CGAffineTransform(rotationAngle: .pi * 2)
    }

}
