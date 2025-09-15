//
//  MessagesViewController.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 12.09.2025.
//

import UIKit

class MessagesViewController: UIViewController {
    
    let navigationBar: UINavigationBar! = .init(frame: .zero)
    let closeButton: UIButton! = .init(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetup()
        closeButtonSetup()
    }
    
    func navigationBarSetup() {
        view.backgroundColor = .systemBackground
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.prefersLargeTitles = false
        navigationBar.isTranslucent = true
        navigationItem.title = "What is messages?"
        view.addSubview(navigationBar)
    }
    
    func closeButtonSetup() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle("Got it!", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        closeButton.titleLabel?.textAlignment = .center
        closeButton.backgroundColor = .lightGray
        closeButton.layer.borderColor = UIColor.systemGray3.cgColor
        closeButton.layer.borderWidth = 2
        closeButton.layer.cornerRadius = 30
        
        closeButton.addTarget(self, action: #selector(closeButtonTouchDown), for: [.touchDown, .touchDragEnter, .touchDownRepeat])
        closeButton.addTarget(self, action: #selector(closeButtonCancel), for: [.touchCancel, .touchDragExit, .touchUpOutside])
        closeButton.addTarget(self, action: #selector(closeButtonTouchUp), for: [.touchUpInside])
        
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            closeButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc func closeButtonTouchDown() {
        closeButton.alpha = 0.5
    }
    
    @objc func closeButtonCancel() {
        closeButton.alpha = 1
    }
    
    @objc func closeButtonTouchUp() {
        closeButton.alpha = 1
        dismiss(animated: true)
    }

}
