//
//  MessagesViewController.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 12.09.2025.
//

import UIKit

class MessagesViewController: UIViewController {
    
    let backgroundView: UIView! = .init(frame: .zero)
    let messagesTitle: UILabel! = .init(frame: .zero)
    let closeButton: UIButton! = .init(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundSetup()
        titleSetup()
        closeButtonSetup()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            backgroundView.layer.borderColor = UIColor.systemGray5.cgColor
        }
    }
    
    func backgroundSetup() {
        view.backgroundColor = .clear
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = .systemGray6
        backgroundView.layer.cornerRadius = 30
        backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        backgroundView.layer.borderColor = UIColor.systemGray5.cgColor
        backgroundView.layer.borderWidth = 2
        view.addSubview(backgroundView)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 2),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func titleSetup() {        
        messagesTitle.translatesAutoresizingMaskIntoConstraints = false
        messagesTitle.text = "What is messages?"
        messagesTitle.textColor = .systemBlack
        messagesTitle.textAlignment = .center
        messagesTitle.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        view.addSubview(messagesTitle)
        
        NSLayoutConstraint.activate([
            messagesTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            messagesTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func closeButtonSetup() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle("Got it!", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        closeButton.titleLabel?.textAlignment = .center
        closeButton.backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.6274509804, blue: 0.5058823529, alpha: 1)
        closeButton.layer.borderColor = #colorLiteral(red: 0.2567243651, green: 0.5657354798, blue: 0.4573884009, alpha: 1)
        closeButton.layer.borderWidth = 2
        closeButton.layer.cornerRadius = 27.5
        closeButton.alpha = 0.9
        
        closeButton.addTarget(self, action: #selector(closeButtonTouchDown), for: [.touchDown, .touchDragEnter, .touchDownRepeat])
        closeButton.addTarget(self, action: #selector(closeButtonCancel), for: [.touchCancel, .touchDragExit, .touchUpOutside])
        closeButton.addTarget(self, action: #selector(closeButtonTouchUp), for: [.touchUpInside])
        
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            closeButton.heightAnchor.constraint(equalToConstant: 55)
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
