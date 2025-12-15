//
//  ScrollDown.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 28.11.2025.
//

import UIKit

class ScrollDownButton: UIButton {
    
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
        setImage(UIImage(systemName: "chevron.down"), for: .normal)
        setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(weight: .semibold), forImageIn: .normal)
        tintColor = .systemGray2
        backgroundColor = .systemGray6
        layer.cornerRadius = 21
    }
    
}
