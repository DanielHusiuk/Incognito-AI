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
    }

}
