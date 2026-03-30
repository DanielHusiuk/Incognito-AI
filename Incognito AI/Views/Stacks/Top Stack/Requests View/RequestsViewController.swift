//
//  RequestsViewController.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 12.09.2025.
//

import UIKit

class RequestsViewController: UIViewController {
    
    let backgroundView: UIView! = .init(frame: .zero)
    let fadeView: UIView! = .init(frame: .zero)
    let closeButton: UIButton! = .init(frame: .zero)
    
    let topTitle: UILabel! = .init(frame: .zero)
    let requestsCounter: UILabel! = .init(frame: .zero)
    let requestsLabel: UILabel! = .init(frame: .zero)
    let explanationLabel: UILabel! = .init(frame: .zero)
    
    let remainingRequests = RequestLimitManager.shared.remainingRequestsToday()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundSetup()
        fadeViewSetup()
        closeButtonSetup()
        
        titleSetup()
        requestsCounterSetup()
        requestsLabelSetup()
        explanationLabelSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateButtonColor(button: closeButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientSetup()
        ShadowManager().applyShadow(to: closeButton, opacity: 0.2, shadowRadius: 10, viewBounds: closeButton.bounds.insetBy(dx: 0, dy: 5))
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
        backgroundView.layer.borderColor = UIColor.systemGray4.cgColor
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
    
    
    //MARK: - Labels
    
    func titleSetup() {
        topTitle.translatesAutoresizingMaskIntoConstraints = false
        topTitle.text = "What is request limit?"
        topTitle.textColor = .label
        topTitle.textAlignment = .center
        topTitle.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        view.addSubview(topTitle)
        
        NSLayoutConstraint.activate([
            topTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 18),
            topTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func requestsCounterSetup() {
        requestsCounter.translatesAutoresizingMaskIntoConstraints = false
        requestsCounter.text = "\(remainingRequests)"
        requestsCounter.textColor = .label
        requestsCounter.textAlignment = .center
        requestsCounter.font = UIFont.systemFont(ofSize: 80, weight: .bold)
        view.addSubview(requestsCounter)
        
        NSLayoutConstraint.activate([
            requestsCounter.topAnchor.constraint(equalTo: topTitle.bottomAnchor, constant: 50),
            requestsCounter.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func requestsLabelSetup() {
        requestsLabel.translatesAutoresizingMaskIntoConstraints = false
        requestsLabel.textColor = .label
        requestsLabel.textAlignment = .center
        requestsLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        if remainingRequests == 1 {
            requestsLabel.text = "request left for today"
        } else {
            requestsLabel.text = "requests left for today"
        }
        
        view.addSubview(requestsLabel)
        NSLayoutConstraint.activate([
            requestsLabel.topAnchor.constraint(equalTo: requestsCounter.bottomAnchor, constant: 10),
            requestsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func explanationLabelSetup() {
        explanationLabel.translatesAutoresizingMaskIntoConstraints = false
        explanationLabel.numberOfLines = 0
        explanationLabel.textAlignment = .justified
        explanationLabel.text = """
            To keep Incognito AI free, we use GitHub's free developer access, which enforces daily message limits. Request limit reset every day!

            
            Advanced models use more power and have lower limits than lighter ones. If you run out of requests, simply switch to a different model.

            
            Sending messages too fast may trigger a temporary block from Ai model. If you get a "too fast" error, just wait a few seconds before trying again.
            """
        explanationLabel.textColor = .label
        explanationLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        view.addSubview(explanationLabel)
        
        NSLayoutConstraint.activate([
            explanationLabel.topAnchor.constraint(equalTo: requestsLabel.bottomAnchor, constant: 60),
            explanationLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            explanationLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40)
        ])
    }
    
    //MARK: - Close Button
    
    func closeButtonSetup() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle("Got it!", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        closeButton.titleLabel?.textAlignment = .center
        closeButton.layer.borderWidth = 2
        closeButton.layer.cornerRadius = 27.5
        updateButtonColor(button: closeButton)
        
        closeButton.addTarget(self, action: #selector(closeButtonTouchDown), for: [.touchDown, .touchDragEnter, .touchDownRepeat])
        closeButton.addTarget(self, action: #selector(closeButtonCancel), for: [.touchCancel, .touchDragExit, .touchUpOutside])
        closeButton.addTarget(self, action: #selector(closeButtonTouchUp), for: [.touchUpInside])
        
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            closeButton.heightAnchor.constraint(equalToConstant: 55),
            closeButton.widthAnchor.constraint(equalToConstant: 255)
        ])
    }
    
    func updateButtonColor(button: UIButton) {
        if let selectedTintColor = UserDefaults.standard.color(forKey: "buttonTintColor") {
            button.backgroundColor = selectedTintColor
            
            var borderRedColor: CGFloat = 0,
                borderGreenColor: CGFloat = 0,
                borderBlueColor: CGFloat = 0,
                borderAlpha: CGFloat = 0
            
            selectedTintColor.getRed(
                &borderRedColor,
                green: &borderGreenColor,
                blue: &borderBlueColor,
                alpha: &borderAlpha
            )
            
            button.layer.borderColor = UIColor(
                red: borderRedColor * 0.8,
                green: borderGreenColor * 0.8,
                blue: borderBlueColor * 0.8,
                alpha: borderAlpha * 0.6
            ).cgColor
        }
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
    
}
