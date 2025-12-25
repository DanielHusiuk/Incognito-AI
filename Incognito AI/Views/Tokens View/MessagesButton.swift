//
//  MessagesButton.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 16.09.2025.
//

import UIKit

class MessagesButton: UIButton {

    let navigateToMessages = UINavigationController(rootViewController: MessagesViewController())
    
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
        setTitle("777 messages left", for: .normal)
        setTitleColor(.lightText, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        self.titleLabel?.textAlignment = .center
        backgroundColor = .clear
        layer.cornerRadius = 9
        alpha = 0.8
        
        addTarget(self, action: #selector(messagesButtonTouchDown), for: [.touchDown, .touchDragEnter, .touchDownRepeat])
        addTarget(self, action: #selector(messagesButtonCancel), for: [.touchCancel, .touchDragExit, .touchUpOutside])
        addTarget(self, action: #selector(messagesButtonTouchUp), for: [.touchUpInside])
    }
    
    @objc func messagesButtonTouchDown() {
        backgroundColor = .messagesButton
    }
    
    @objc func messagesButtonCancel() {
        UIView.animate(withDuration: 0.1, animations: {
            self.backgroundColor = .clear
        })
    }
    
    @objc func messagesButtonTouchUp() {
        UIView.animate(withDuration: 0.1, animations: {
            self.backgroundColor = .clear
        })
        
        if UserDefaults.standard.bool(forKey: "HapticState") {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
        UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
            .first?.rootViewController?
            .present(navigateToMessages, animated: true)
    }

}
