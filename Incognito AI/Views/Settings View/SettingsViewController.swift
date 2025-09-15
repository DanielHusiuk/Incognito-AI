//
//  SettingsViewController.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 12.09.2025.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let navigationBar: UINavigationBar! = .init(frame: .zero)
    let closeSettingsButton: UIButton! = .init(frame: .zero)
    let resetSettingsButton: UIButton! = .init(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetup()
        closeSettingsButtonSetup()
        resetSettingsButtonSetup()
    }
    
    func navigationBarSetup() {
        view.backgroundColor = .systemBackground
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.prefersLargeTitles = false
        navigationBar.isTranslucent = true
        
        navigationItem.title = "Settings"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeSettingsButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: resetSettingsButton)
        view.addSubview(navigationBar)
    }
    
    func closeSettingsButtonSetup() {
        closeSettingsButton.translatesAutoresizingMaskIntoConstraints = false
        closeSettingsButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeSettingsButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(weight: .semibold), forImageIn: .normal)
        closeSettingsButton.tintColor = .systemGray
        closeSettingsButton.backgroundColor = .secondarySystemBackground
        closeSettingsButton.layer.cornerRadius = 15
        closeSettingsButton.addTarget(self, action: #selector(closeSettings), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            closeSettingsButton.widthAnchor.constraint(equalToConstant: 30),
            closeSettingsButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc func closeSettings() {
        dismiss(animated: true)
    }
    
    func resetSettingsButtonSetup() {
        resetSettingsButton.translatesAutoresizingMaskIntoConstraints = false
        resetSettingsButton.setImage(UIImage(systemName: "exclamationmark.arrow.trianglehead.counterclockwise.rotate.90"), for: .normal)
        resetSettingsButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(weight: .semibold), forImageIn: .normal)
        resetSettingsButton.tintColor = .systemGray
        resetSettingsButton.backgroundColor = .secondarySystemBackground
        resetSettingsButton.layer.cornerRadius = 15
        resetSettingsButton.addTarget(self, action: #selector(resetSettings), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            resetSettingsButton.widthAnchor.constraint(equalToConstant: 30),
            resetSettingsButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc func resetSettings() {
        dismiss(animated: true)
    }
    
}
