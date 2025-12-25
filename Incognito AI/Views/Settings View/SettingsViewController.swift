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
    let backgroundGradientView: UIView! = .init(frame: .zero)
    
    let navigationView: UIView! = .init(frame: .zero)
    let navigationGradientView: UIView! = .init(frame: .zero)
    
    let settingsTitle: UILabel! = .init(frame: .zero)
    let closeSettingsButton: UIButton! = .init(frame: .zero)
    let resetSettingsButton: UIButton! = .init(frame: .zero)
    
    let settingsTableView = SettingsTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundSetup()
        backgroundGradientViewSetup()
        
        tableViewSetup()
        navigationViewSetup()
        navigationGradientViewSetup()
        
        titleSetup()
        closeSettingsButtonSetup()
        resetSettingsButtonSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradientSetup()
        navigationGradientSetup()
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
        backgroundView.backgroundColor = .systemGroupedBackground
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
    
    func backgroundGradientViewSetup() {
        backgroundGradientView.translatesAutoresizingMaskIntoConstraints = false
        backgroundGradientView.isUserInteractionEnabled = false
        backgroundGradientView.backgroundColor = .systemGroupedBackground
        backgroundGradientView.layer.cornerRadius = 30
        backgroundGradientView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        view.addSubview(backgroundGradientView)
        NSLayoutConstraint.activate([
            backgroundGradientView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            backgroundGradientView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            backgroundGradientView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundGradientView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }
    
    func backgroundGradientSetup() {
        let gradientMask = CAGradientLayer()
        gradientMask.frame = backgroundGradientView.bounds
        
        gradientMask.colors = [
            UIColor.black.withAlphaComponent(0.0).cgColor,
            UIColor.black.withAlphaComponent(1.0).cgColor
        ]
        gradientMask.locations = [0.0, 0.8]
        backgroundGradientView.layer.mask = gradientMask
    }
    
    
    //MARK: - Navigation Bar
    
    func navigationViewSetup() {
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        navigationView.backgroundColor = .clear
        navigationView.layer.cornerRadius = 28
        navigationView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        navigationView.layer.borderColor = UIColor.systemGray5.cgColor
        view.addSubview(navigationView)
        
        NSLayoutConstraint.activate([
            navigationView.heightAnchor.constraint(equalToConstant: 56),
            navigationView.topAnchor.constraint(equalTo: view.topAnchor, constant: 2),
            navigationView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 2),
            navigationView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -2)
        ])
    }
    
    func navigationGradientViewSetup() {
        navigationGradientView.translatesAutoresizingMaskIntoConstraints = false
        navigationGradientView.isUserInteractionEnabled = false
        navigationGradientView.backgroundColor = .systemGroupedBackground
        navigationGradientView.layer.cornerRadius = 28
        navigationGradientView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        view.addSubview(navigationGradientView)
        NSLayoutConstraint.activate([
            navigationGradientView.topAnchor.constraint(equalTo: navigationView.topAnchor),
            navigationGradientView.bottomAnchor.constraint(equalTo: navigationView.bottomAnchor, constant: 20),
            navigationGradientView.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor),
            navigationGradientView.trailingAnchor.constraint(equalTo: navigationView.trailingAnchor)
        ])
    }
    
    func navigationGradientSetup() {
        let gradientMask = CAGradientLayer()
        gradientMask.frame = navigationGradientView.bounds
        
        gradientMask.colors = [
            UIColor.black.withAlphaComponent(1.0).cgColor,
            UIColor.black.withAlphaComponent(0.0).cgColor
        ]
        gradientMask.locations = [0.35, 1.0]
        navigationGradientView.layer.mask = gradientMask
    }
    
    
    //MARK: - Navigation Items
    
    func titleSetup() {
        settingsTitle.translatesAutoresizingMaskIntoConstraints = false
        settingsTitle.text = "Settings"
        settingsTitle.textColor = .label
        settingsTitle.textAlignment = .center
        settingsTitle.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        view.addSubview(settingsTitle)
        
        NSLayoutConstraint.activate([
            settingsTitle.topAnchor.constraint(equalTo: navigationView.topAnchor, constant: 18),
            settingsTitle.centerXAnchor.constraint(equalTo: navigationView.centerXAnchor)
        ])
    }
    
    func closeSettingsButtonSetup() {
        closeSettingsButton.translatesAutoresizingMaskIntoConstraints = false
        closeSettingsButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeSettingsButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(weight: .semibold), forImageIn: .normal)
        closeSettingsButton.tintColor = .systemGray
        closeSettingsButton.backgroundColor = .navigationButton
        closeSettingsButton.layer.cornerRadius = 15
        
        closeSettingsButton.addTarget(self, action: #selector(closeSettingsButtonTouchDown), for: [.touchDown, .touchDragEnter, .touchDownRepeat])
        closeSettingsButton.addTarget(self, action: #selector(closeSettingsButtonCancel), for: [.touchCancel, .touchDragExit, .touchUpOutside])
        closeSettingsButton.addTarget(self, action: #selector(closeSettingsButtonTouchUp), for: [.touchUpInside])
        
        view.addSubview(closeSettingsButton)
        NSLayoutConstraint.activate([
            closeSettingsButton.topAnchor.constraint(equalTo: navigationView.topAnchor, constant: 13),
            closeSettingsButton.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor, constant: 13),
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
        resetSettingsButton.setImage(UIImage(systemName: "exclamationmark.arrow.triangle.2.circlepath"), for: .normal)
        resetSettingsButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(weight: .semibold), forImageIn: .normal)
        resetSettingsButton.tintColor = .systemGray
        resetSettingsButton.backgroundColor = .navigationButton
        resetSettingsButton.layer.cornerRadius = 15
        
        resetSettingsButton.addTarget(self, action: #selector(resetSettingsButtonTouchDown), for: [.touchDown, .touchDragEnter, .touchDownRepeat])
        resetSettingsButton.addTarget(self, action: #selector(resetSettingsButtonCancel), for: [.touchCancel, .touchDragExit, .touchUpOutside])
        resetSettingsButton.addTarget(self, action: #selector(resetSettingsTouchUp), for: .touchUpInside)
        
        view.addSubview(resetSettingsButton)
        NSLayoutConstraint.activate([
            resetSettingsButton.topAnchor.constraint(equalTo: navigationView.topAnchor, constant: 13),
            resetSettingsButton.trailingAnchor.constraint(equalTo: navigationView.trailingAnchor, constant: -13),
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
    
    
    //MARK: - Table View
    
    func tableViewSetup() {
        settingsTableView.translatesAutoresizingMaskIntoConstraints = false
        settingsTableView.backgroundColor = .clear
        settingsTableView.layer.cornerRadius = 28
        settingsTableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        settingsTableView.contentInset.top = 60
        settingsTableView.verticalScrollIndicatorInsets.top = 60
        settingsTableView.setContentOffset(CGPoint(x: 0, y: -60), animated: false)
        view.addSubview(settingsTableView)
        
        NSLayoutConstraint.activate([
            settingsTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 4),
            settingsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            settingsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 2),
            settingsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -2)
        ])
    }
    
}
