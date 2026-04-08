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
    
    let topView: UIView! = .init(frame: .zero)
    let topGradientView: UIView! = .init(frame: .zero)
    
    let bottomView: UIView! = .init(frame: .zero)
    let bottomGradientView: UIView! = .init(frame: .zero)
    
    let topTitle: UILabel! = .init(frame: .zero)
    let requestsCounter: UILabel! = .init(frame: .zero)
    let requestsLabel: UILabel! = .init(frame: .zero)
    let explanationScrollView: UIScrollView! = .init(frame: .zero)
    let explanationStackView: UIStackView! = .init(frame: .zero)
    
    var requestsCounterTopConstraint: NSLayoutConstraint!
    var requestsCounterConstant: CGFloat = 0
    var explanationTopConstraint: NSLayoutConstraint!
    var explanationConstant: CGFloat = 0
    let closeButton: UIButton! = .init(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundSetup()
        fadeViewSetup()
        
        titleSetup()
        requestsCounterSetup()
        requestsLabelSetup()
        explanationScrollViewSetup()
        
        topViewSetup()
        topGradientViewSetup()
        bottomViewSetup()
        bottomGradientViewSetup()
        closeButtonSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateButtonColor(button: closeButton)
        updateRequests()
        checkScreenOrientation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        borderGradientSetup()
        topGradientSetup()
        bottomGradientSetup()
        ShadowManager().applyShadow(to: closeButton, opacity: 0.2, shadowRadius: 10, viewBounds: closeButton.bounds.insetBy(dx: 0, dy: 5))
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            backgroundView.layer.borderColor = UIColor.sheetBorder.cgColor
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            self.checkScreenOrientation()
            self.view.layoutIfNeeded()
        })
    }
    
    func checkScreenOrientation() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let orientation = windowScene.interfaceOrientation
            if orientation.isPortrait {
                requestsCounterTopConstraint.constant = 50
                explanationTopConstraint.constant = 50
            } else {
                requestsCounterTopConstraint.constant = 10
                explanationTopConstraint.constant = 20
            }
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
        backgroundView.layer.borderColor = UIColor.systemGray5.cgColor
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
    
    func borderGradientSetup() {
        let gradientMask = CAGradientLayer()
        gradientMask.frame = fadeView.bounds
        
        gradientMask.colors = [
            UIColor.black.withAlphaComponent(0.0).cgColor,
            UIColor.black.withAlphaComponent(1.0).cgColor
        ]
        gradientMask.locations = [0.0, 0.8]
        fadeView.layer.mask = gradientMask
    }
    
    
    //MARK: - Gradients
    
    func topViewSetup() {
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.backgroundColor = .clear
        view.addSubview(topView)
        
        NSLayoutConstraint.activate([
            topView.heightAnchor.constraint(equalToConstant: 32),
            topView.topAnchor.constraint(equalTo: explanationScrollView.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 2),
            topView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -2)
        ])
    }
    
    func topGradientViewSetup() {
        topGradientView.translatesAutoresizingMaskIntoConstraints = false
        topGradientView.isUserInteractionEnabled = false
        topGradientView.backgroundColor = .systemBackground
        
        view.addSubview(topGradientView)
        NSLayoutConstraint.activate([
            topGradientView.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            topGradientView.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            topGradientView.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            topGradientView.heightAnchor.constraint(equalTo: topView.heightAnchor)
        ])
    }
    
    func topGradientSetup() {
        let gradientMask = CAGradientLayer()
        gradientMask.frame = topGradientView.bounds
        
        gradientMask.colors = [
            UIColor.black.withAlphaComponent(1.0).cgColor,
            UIColor.black.withAlphaComponent(0.0).cgColor
        ]
        gradientMask.locations = [0.0, 1.0]
        topGradientView.layer.mask = gradientMask
    }
    
    func bottomViewSetup() {
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.backgroundColor = .clear
        view.addSubview(bottomView)
        
        NSLayoutConstraint.activate([
            bottomView.heightAnchor.constraint(equalToConstant: 32),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            bottomView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 2),
            bottomView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -2)
        ])
    }
    
    func bottomGradientViewSetup() {
        bottomGradientView.translatesAutoresizingMaskIntoConstraints = false
        bottomGradientView.isUserInteractionEnabled = false
        bottomGradientView.backgroundColor = .systemBackground
        
        view.addSubview(bottomGradientView)
        NSLayoutConstraint.activate([
            bottomGradientView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            bottomGradientView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            bottomGradientView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor),
            bottomGradientView.heightAnchor.constraint(equalTo: bottomView.heightAnchor)
        ])
    }
    
    func bottomGradientSetup() {
        let gradientMask = CAGradientLayer()
        gradientMask.frame = bottomGradientView.bounds
        
        gradientMask.colors = [
            UIColor.black.withAlphaComponent(0.0).cgColor,
            UIColor.black.withAlphaComponent(1.0).cgColor
        ]
        gradientMask.locations = [0.0, 1.0]
        bottomGradientView.layer.mask = gradientMask
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
        requestsCounter.textColor = .label
        requestsCounter.textAlignment = .center
        requestsCounter.font = UIFont.systemFont(ofSize: 80, weight: .bold)
        
        view.addSubview(requestsCounter)
        NSLayoutConstraint.activate([
            requestsCounter.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        requestsCounterTopConstraint = requestsCounter.topAnchor.constraint(equalTo: topTitle.bottomAnchor, constant: requestsCounterConstant)
        requestsCounterTopConstraint.isActive = true
    }
    
    func requestsLabelSetup() {
        requestsLabel.translatesAutoresizingMaskIntoConstraints = false
        requestsLabel.textColor = .label
        requestsLabel.textAlignment = .center
        requestsLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        view.addSubview(requestsLabel)
        NSLayoutConstraint.activate([
            requestsLabel.topAnchor.constraint(equalTo: requestsCounter.bottomAnchor, constant: 10),
            requestsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func updateRequests() {
        let remainingRequests = RequestLimitManager.shared.remainingRequestsToday()
        requestsCounter.text = "\(remainingRequests)"
        
        if remainingRequests == 1 {
            requestsLabel.text = "request left for today"
        } else {
            requestsLabel.text = "requests left for today"
        }
    }
    
    
    //MARK: - Explanation
    
    func explanationScrollViewSetup() {
        explanationScrollView.translatesAutoresizingMaskIntoConstraints = false
        explanationScrollView.showsVerticalScrollIndicator = true
        explanationScrollView.contentInset = .init(top: 32, left: 0, bottom: 32, right: 0)
        explanationScrollView.scrollIndicatorInsets = .init(top: 22, left: 0, bottom: 22, right: 0)
        view.addSubview(explanationScrollView)
        
        explanationStackView.translatesAutoresizingMaskIntoConstraints = false
        explanationStackView.axis = .vertical
        explanationStackView.spacing = 30
        explanationStackView.alignment = .fill
        explanationScrollView.addSubview(explanationStackView)
        
        NSLayoutConstraint.activate([
            explanationScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 2),
            explanationScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -2),
            explanationScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            
            explanationStackView.topAnchor.constraint(equalTo: explanationScrollView.contentLayoutGuide.topAnchor),
            explanationStackView.leadingAnchor.constraint(equalTo: explanationScrollView.contentLayoutGuide.leadingAnchor),
            explanationStackView.trailingAnchor.constraint(equalTo: explanationScrollView.contentLayoutGuide.trailingAnchor),
            explanationStackView.bottomAnchor.constraint(equalTo: explanationScrollView.contentLayoutGuide.bottomAnchor),
            explanationStackView.widthAnchor.constraint(equalTo: explanationScrollView.frameLayoutGuide.widthAnchor)
        ])
        
        explanationTopConstraint = explanationScrollView.topAnchor.constraint(equalTo: requestsLabel.bottomAnchor, constant: explanationConstant)
        explanationTopConstraint.isActive = true
        
        let text1 = "To keep Incognito AI free, we use GitHub's free developer access, which enforces daily message limits. This limit reset every day."
        let text2 = "Advanced models have lower limits than lighter ones. If you run out of requests, simply switch to a different model."
        let text3 = "Sending messages too fast may trigger a temporary block from AI model. Just wait a few seconds before trying again."
        let texts = [text1, text2, text3]
        let symbols = ["text.bubble.fill", "sparkles", "exclamationmark.triangle.fill"]
        
        for i in 0..<3 {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 15
            rowStack.alignment = .center
            
            let imageView = UIImageView()
            let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)
            imageView.image = UIImage(systemName: symbols[i], withConfiguration: config)
            imageView.tintColor = .label
            imageView.contentMode = .center
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
            imageView.setContentHuggingPriority(.required, for: .horizontal)
            imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
            
            let label = UILabel()
            label.text = texts[i]
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            label.textColor = .label
            label.textAlignment = .left
            
            rowStack.isLayoutMarginsRelativeArrangement = true
            rowStack.layoutMargins = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 45)
            rowStack.addArrangedSubview(imageView)
            rowStack.addArrangedSubview(label)
            
            explanationStackView.addArrangedSubview(rowStack)
        }
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
