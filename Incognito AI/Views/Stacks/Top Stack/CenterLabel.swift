//
//  CenterLabel.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 16.09.2025.
//

import UIKit

class CenterLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        labelSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        labelSetup()
    }
    
    func labelSetup() {
        text = "Incognito AI"
        textColor = .white
        textAlignment = .center
        font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        translatesAutoresizingMaskIntoConstraints = false
    }

}
