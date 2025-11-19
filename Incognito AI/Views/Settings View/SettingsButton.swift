//
//  SettingsButton.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 16.09.2025.
//

import UIKit

class SettingsButton: UIButton {
    
    let navigateToSettings = UINavigationController(rootViewController: SettingsViewController())
    
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
        setImage(UIImage(systemName: "gear"), for: .normal)
        setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .regular), forImageIn: .normal)
        tintColor = .white
        layer.cornerRadius = 25
        
        addTarget(self, action: #selector(settingsButtonTouchDown), for: [.touchDown, .touchDragEnter, .touchDownRepeat])
        addTarget(self, action: #selector(settingsButtonCancel), for: [.touchCancel, .touchDragExit, .touchUpOutside])
        addTarget(self, action: #selector(settingsButtonTouchUp), for: [.touchUpInside])
    }
    
    @objc func settingsButtonTouchDown() {
        isHighlighted = true
    }
    
    @objc func settingsButtonCancel() {
        UIView.animate(withDuration: 0.1, animations: {
            self.isHighlighted = false
        })
    }
    
    @objc func settingsButtonTouchUp() {
        UIView.animate(withDuration: 0.1, animations: {
            self.isHighlighted = false
        })
        
        UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
            .first?.rootViewController?
            .present(navigateToSettings, animated: true)
    }

}
