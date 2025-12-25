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
    let fadeView: UIView! = .init(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundSetup()
        fadeViewSetup()
        
        titleSetup()
        closeButtonSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientSetup()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            backgroundView.layer.borderColor = UIColor.sheetBorder.cgColor
        }
    }
    
    
    //MARK: - Background
    
    func backgroundSetup() {
        view.isOpaque = false
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.isUserInteractionEnabled = false
        backgroundView.backgroundColor = .systemBackground
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 30
        backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        backgroundView.layer.borderColor = UIColor.sheetBorder.cgColor
        backgroundView.layer.borderWidth = 2
        view.addSubview(backgroundView)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 2),
            backgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func fadeViewSetup() {
        fadeView.translatesAutoresizingMaskIntoConstraints = false
        fadeView.isUserInteractionEnabled = false
        fadeView.backgroundColor = .systemBackground
        fadeView.layer.cornerRadius = 30
        fadeView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        view.addSubview(fadeView)
        NSLayoutConstraint.activate([
            fadeView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            fadeView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            fadeView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            fadeView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }
    
    func gradientSetup() {
        let gradientMask = CAGradientLayer()
        gradientMask.frame = fadeView.bounds
        
        gradientMask.colors = [
            UIColor.black.withAlphaComponent(0.0).cgColor,
            UIColor.black.withAlphaComponent(1.0).cgColor
        ]
        gradientMask.locations = [0.0, 0.8]
        fadeView.layer.mask = gradientMask
    }
    
    
    //MARK: - Navigation Bar
    
    func titleSetup() {        
        messagesTitle.translatesAutoresizingMaskIntoConstraints = false
        messagesTitle.text = "What is messages?"
        messagesTitle.textColor = .label
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
        
        closeButton.addTarget(self, action: #selector(closeButtonTouchDown), for: [.touchDown, .touchDragEnter, .touchDownRepeat])
        closeButton.addTarget(self, action: #selector(closeButtonCancel), for: [.touchCancel, .touchDragExit, .touchUpOutside])
        closeButton.addTarget(self, action: #selector(closeButtonTouchUp), for: [.touchUpInside])
        
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            closeButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    @objc func closeButtonTouchDown() {
        closeButton.alpha = 0.5
    }
    
    @objc func closeButtonCancel() {
        UIView.animate(withDuration: 0.1, animations: {
            self.closeButton.alpha = 1
        })
    }
    
    @objc func closeButtonTouchUp() {
        UIView.animate(withDuration: 0.1, animations: {
            self.closeButton.alpha = 1
        })
        dismiss(animated: true)
    }
    
    
    //MARK: - Table View

}
