//
//  SettingsViewController.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 12.09.2025.
//

import UIKit
import SwiftUI

class SettingsViewController: UIViewController {
    
    let backgroundView: UIView! = .init(frame: .zero)
    let settingsTitle: UILabel! = .init(frame: .zero)
    let closeSettingsButton: UIButton! = .init(frame: .zero)
    let resetSettingsButton: UIButton! = .init(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundSetup()
        titleSetup()
        closeSettingsButtonSetup()
        resetSettingsButtonSetup()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            backgroundView.layer.borderColor = UIColor.systemGray5.cgColor
        }
    }
    
    func backgroundSetup() {
        view.isOpaque = false
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.isUserInteractionEnabled = false
        backgroundView.backgroundColor = .systemBackground
        backgroundView.clipsToBounds = true
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
        settingsTitle.translatesAutoresizingMaskIntoConstraints = false
        settingsTitle.text = "Settings"
        settingsTitle.textColor = .systemBlack
        settingsTitle.textAlignment = .center
        settingsTitle.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        view.addSubview(settingsTitle)
        
        NSLayoutConstraint.activate([
            settingsTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            settingsTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func closeSettingsButtonSetup() {
        closeSettingsButton.translatesAutoresizingMaskIntoConstraints = false
        closeSettingsButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeSettingsButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(weight: .semibold), forImageIn: .normal)
        closeSettingsButton.tintColor = .systemGray
        closeSettingsButton.backgroundColor = .secondarySystemBackground
        closeSettingsButton.layer.cornerRadius = 15
        
        closeSettingsButton.addTarget(self, action: #selector(closeSettingsButtonTouchDown), for: [.touchDown, .touchDragEnter, .touchDownRepeat])
        closeSettingsButton.addTarget(self, action: #selector(closeSettingsButtonCancel), for: [.touchCancel, .touchDragExit, .touchUpOutside])
        closeSettingsButton.addTarget(self, action: #selector(closeSettingsButtonTouchUp), for: [.touchUpInside])
        
        view.addSubview(closeSettingsButton)
        NSLayoutConstraint.activate([
            closeSettingsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            closeSettingsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            closeSettingsButton.widthAnchor.constraint(equalToConstant: 30),
            closeSettingsButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc func closeSettingsButtonTouchDown() {
        closeSettingsButton.alpha = 0.5
    }
    
    @objc func closeSettingsButtonCancel() {
        UIView.animate(withDuration: 0.1, animations: {
            self.closeSettingsButton.alpha = 1
        })
    }
    
    @objc func closeSettingsButtonTouchUp() {
        UIView.animate(withDuration: 0.1, animations: {
            self.closeSettingsButton.alpha = 1
        })
        dismiss(animated: true)
    }
    
    
    func resetSettingsButtonSetup() {
        resetSettingsButton.translatesAutoresizingMaskIntoConstraints = false
        resetSettingsButton.setImage(UIImage(systemName: "exclamationmark.arrow.trianglehead.counterclockwise.rotate.90"), for: .normal)
        resetSettingsButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(weight: .semibold), forImageIn: .normal)
        resetSettingsButton.tintColor = .systemGray
        resetSettingsButton.backgroundColor = .secondarySystemBackground
        resetSettingsButton.layer.cornerRadius = 15
        
        resetSettingsButton.addTarget(self, action: #selector(resetSettingsButtonTouchDown), for: [.touchDown, .touchDragEnter, .touchDownRepeat])
        resetSettingsButton.addTarget(self, action: #selector(resetSettingsButtonCancel), for: [.touchCancel, .touchDragExit, .touchUpOutside])
        resetSettingsButton.addTarget(self, action: #selector(resetSettingsTouchUp), for: .touchUpInside)
        
        view.addSubview(resetSettingsButton)
        NSLayoutConstraint.activate([
            resetSettingsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            resetSettingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            resetSettingsButton.widthAnchor.constraint(equalToConstant: 30),
            resetSettingsButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc func resetSettingsButtonTouchDown() {
        resetSettingsButton.alpha = 0.5
    }
    
    @objc func resetSettingsButtonCancel() {
        UIView.animate(withDuration: 0.1, animations: {
            self.resetSettingsButton.alpha = 1
        })
    }
    
    @objc func resetSettingsTouchUp() {
        UIView.animate(withDuration: 0.1, animations: {
            self.resetSettingsButton.alpha = 1
        })
        dismiss(animated: true)
    }
    
}
