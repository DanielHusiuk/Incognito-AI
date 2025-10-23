//
//  AiPickerSpacer.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 29.09.2025.
//

import UIKit

class AiPickerSpacer: UIView {

    let aiPickerSpacer = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        spacerSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        spacerSetup()
    }
    
    func spacerSetup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemGray5
        layer.cornerRadius = 0.5
        isUserInteractionEnabled = false
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 1)
        ])
    }

}
