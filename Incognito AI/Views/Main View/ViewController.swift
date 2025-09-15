//
//  ViewController.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 11.09.2025.
//

import UIKit
import SwiftUI

class ViewController: UIViewController, UITextViewDelegate {
    
    let topStackView: UIStackView = .init(frame: .zero)
    let spacer = UIView()
    
    let labelStackView: UIStackView = .init(frame: .zero)
    let centerLabel: UILabel = .init(frame: .zero)
    let centerDetailLabelButton: UIButton = .init(frame: .zero)
    
    let settingsButton: UIButton = .init(frame: .zero)
    let newChatButton: UIButton = .init(frame: .zero)
    
    let bottomStackView: UIStackView = .init(frame: .zero)
    var bottomStackBottomConstraint: NSLayoutConstraint!
    let aiButton: UIButton = .init(frame: .zero)
    let sendButton: UIButton = .init(frame: .zero)
    
    let fieldView: UIView = .init(frame: .zero)
    let fieldText: UITextView = .init(frame: .zero)
    var fieldTextStandardConstraint: [NSLayoutConstraint]!
    var fieldTextBigConstraint: [NSLayoutConstraint]!
    
    let fieldPlaceholder: UILabel = .init(frame: .zero)
    var fieldPlaceholderCenterConstraint: NSLayoutConstraint!
    var fieldPlaceholderLeadingConstraint: NSLayoutConstraint!
    
    let eraseButton: UIButton = .init(frame: .zero)
    let dismissKeyboardButton: UIButton = .init(frame: .zero)
    
    let navigateToSettings = UINavigationController(rootViewController: SettingsViewController())
    let navigateToMessages = UINavigationController(rootViewController: MessagesViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundSetup()
        
        loadUserDefaults()
        loadTopView()
        loadBottomView()
        loadShadows()
        loadNotifications()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        aiButton.layer.borderColor = UIColor.systemGray5.cgColor
        fieldView.layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            self.loadShadows()
        }
    }
    
    
    //MARK: - Load Views
    
    func loadUserDefaults() {
        UserDefaults.standard.set(true, forKey: "HapticState")
    }
    
    func loadTopView() {
        topStackViewSetup()
        topBlurEffectSetup()
        
        labelStackViewSetup()
        centerLabelSetup()
        centerDetailLabelButtonSetup()
        
        settingsButtonSetup()
        newChatButtonSetup()
        topStackSpacerSetup()
    }
    
    func loadBottomView() {
        bottomStackViewSetup()
        bottomBlurEffectSetup()
        
        aiButtonSetup()
        textFieldViewSetup()
        eraseButtonSetup()
        textFieldTextSetup()
        fieldPlaceholderSetup()
        
        sendButtonSetup()
        dismissKeyboardButtonSetup()
    }
    
    func loadNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func loadShadows() {
        ShadowManager().applyShadow(to: settingsButton, opacity: 1, shadowRadius: 10, viewBounds: settingsButton.bounds.insetBy(dx: 15, dy: 15))
        ShadowManager().applyShadow(to: newChatButton, opacity: 1, shadowRadius: 10, viewBounds: newChatButton.bounds.insetBy(dx: 15, dy: 15))
        ShadowManager().applyShadow(to: labelStackView, opacity: 0.2, shadowRadius: 10, viewBounds: labelStackView.bounds)
        
        ShadowManager().applyShadow(to: aiButton, opacity: 0.5, shadowRadius: 10, viewBounds: aiButton.bounds.insetBy(dx: 0, dy: 5))
        ShadowManager().applyShadow(to: fieldView, opacity: 0.3, shadowRadius: 10, viewBounds: fieldView.bounds.insetBy(dx: 0, dy: 5))
        ShadowManager().applyShadow(to: sendButton, opacity: 0.5, shadowRadius: 10, viewBounds: sendButton.bounds.insetBy(dx: 0, dy: 5))
    }
    
    
    //MARK: - Background
    
    func backgroundSetup() {
        //temporary
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.bounces = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        
        let imageView = UIImageView(image: UIImage(named: "background"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2)
            ])
        
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = true
    }
    
    //MARK: - Top/Bottom Blur
    
    func topBlurEffectSetup() {
        let blurEffect = BlurView()
            .blur(radius: 15)
            .padding(.horizontal, -100)
            .padding(.top, -70)
            .colorScheme(.light)
        
        let hostingController = UIHostingController(rootView: blurEffect)
        hostingController.view?.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .clear
        
        addChild(hostingController)
        topStackView.addSubview(hostingController.view)
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: topStackView.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: topStackView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: topStackView.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: topStackView.bottomAnchor)
        ])
    }
    
    func bottomBlurEffectSetup() {
        let blurEffect = BlurView()
            .blur(radius: 15)
            .padding(.horizontal, -100)
            .padding(.bottom, -70)
            .colorScheme(.light)
        
        let hostingController = UIHostingController(rootView: blurEffect)
        hostingController.view?.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .clear
        
        addChild(hostingController)
        bottomStackView.addSubview(hostingController.view)
        NSLayoutConstraint.activate([
            hostingController.view.bottomAnchor.constraint(equalTo: bottomStackView.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: bottomStackView.trailingAnchor),
            hostingController.view.heightAnchor.constraint(equalTo: bottomStackView.heightAnchor, constant: 15)
        ])
    }
    
    
    //MARK: - Top Stack View
    
    func topStackViewSetup() {
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.axis = .horizontal
        topStackView.distribution = .equalSpacing
        
        view.addSubview(topStackView)
        NSLayoutConstraint.activate([
            topStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            topStackView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
    
    func topStackSpacerSetup() {
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.backgroundColor = .clear
        spacer.isUserInteractionEnabled = false
        topStackView.addArrangedSubview(spacer)
        
        NSLayoutConstraint.activate([
            spacer.leadingAnchor.constraint(equalTo: topStackView.leadingAnchor),
            spacer.trailingAnchor.constraint(equalTo: topStackView.trailingAnchor),
            spacer.topAnchor.constraint(equalTo: topStackView.topAnchor),
            spacer.bottomAnchor.constraint(equalTo: settingsButton.bottomAnchor)
        ])
    }
    
    //MARK: - Center Label
    
    func labelStackViewSetup() {
        labelStackView.axis = .vertical
        labelStackView.distribution = .equalSpacing
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.addSubview(labelStackView)
        
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            labelStackView.centerXAnchor.constraint(equalTo: topStackView.centerXAnchor)
        ])
    }
    
    func centerLabelSetup() {
        centerLabel.text = "Incognito AI"
        centerLabel.textColor = .white
        centerLabel.textAlignment = .center
        centerLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        centerLabel.translatesAutoresizingMaskIntoConstraints = false
        centerLabel.alpha = 0.9
        labelStackView.addArrangedSubview(centerLabel)
    }
    
    //MARK: - Messages Button
    
    func centerDetailLabelButtonSetup() {
        centerDetailLabelButton.translatesAutoresizingMaskIntoConstraints = false
        centerDetailLabelButton.setTitle("10 messages left", for: .normal)
        centerDetailLabelButton.setTitleColor(.systemGray, for: .normal)
        centerDetailLabelButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        centerDetailLabelButton.titleLabel?.textAlignment = .center
        centerDetailLabelButton.backgroundColor = .clear
        centerDetailLabelButton.layer.cornerRadius = 9
        centerDetailLabelButton.alpha = 0.9
        
        centerDetailLabelButton.addTarget(self, action: #selector(centerDetailLabelButtonTouchDown), for: [.touchDown, .touchDragEnter, .touchDownRepeat])
        centerDetailLabelButton.addTarget(self, action: #selector(centerDetailLabelButtonCancel), for: [.touchCancel, .touchDragExit, .touchUpOutside])
        centerDetailLabelButton.addTarget(self, action: #selector(centerDetailLabelButtonTouchUp), for: [.touchUpInside])
        
        labelStackView.addArrangedSubview(centerDetailLabelButton)
        NSLayoutConstraint.activate([
            centerDetailLabelButton.widthAnchor.constraint(equalTo: centerDetailLabelButton.titleLabel!.widthAnchor, constant: 10),
            centerDetailLabelButton.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    @objc func centerDetailLabelButtonTouchDown() {
        centerDetailLabelButton.backgroundColor = .darkGray
    }
    
    @objc func centerDetailLabelButtonCancel() {
        centerDetailLabelButton.backgroundColor = .clear
    }
    
    @objc func centerDetailLabelButtonTouchUp() {
        centerDetailLabelButton.backgroundColor = .clear
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        present(navigateToMessages, animated: true)
    }
    
    
    //MARK: - Settings Button
    
    func settingsButtonSetup() {
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.imageView?.contentMode = .scaleAspectFit
        settingsButton.setImage(UIImage(systemName: "gear"), for: .normal)
        settingsButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .regular), forImageIn: .normal)
        settingsButton.tintColor = .white
        settingsButton.layer.cornerRadius = 25
        settingsButton.alpha = 0.9
        
        settingsButton.addTarget(self, action: #selector(settingsButtonTouchDown), for: [.touchDown, .touchDragEnter, .touchDownRepeat])
        settingsButton.addTarget(self, action: #selector(settingsButtonCancel), for: [.touchCancel, .touchDragExit, .touchUpOutside])
        settingsButton.addTarget(self, action: #selector(settingsButtonTouchUp), for: [.touchUpInside])
        
        topStackView.addSubview(settingsButton)
        NSLayoutConstraint.activate([
            settingsButton.leadingAnchor.constraint(equalTo: topStackView.leadingAnchor, constant: 10),
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            settingsButton.heightAnchor.constraint(equalToConstant: 50),
            settingsButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func settingsButtonTouchDown() {
        settingsButton.isHighlighted = true
    }
    
    @objc func settingsButtonCancel() {
        settingsButton.isHighlighted = false
    }
    
    @objc func settingsButtonTouchUp() {
        settingsButton.isHighlighted = false
        present(navigateToSettings, animated: true)
    }
    
    //MARK: - New Chat Button
    
    func newChatButtonSetup() {
        newChatButton.translatesAutoresizingMaskIntoConstraints = false
        newChatButton.imageView?.contentMode = .scaleAspectFit
        newChatButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        newChatButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 22, weight: .regular), forImageIn: .normal)
        newChatButton.tintColor = .white
        newChatButton.layer.cornerRadius = 25
        newChatButton.alpha = 0.9
        
        newChatButton.addTarget(self, action: #selector(newChatButtonTouchDown), for: [.touchDown, .touchDragEnter, .touchDownRepeat])
        newChatButton.addTarget(self, action: #selector(newChatButtonCancel), for: [.touchCancel, .touchDragExit, .touchUpOutside])
        newChatButton.addTarget(self, action: #selector(newChatButtonTouchUp), for: [.touchUpInside])
        
        topStackView.addSubview(newChatButton)
        NSLayoutConstraint.activate([
            newChatButton.trailingAnchor.constraint(equalTo: topStackView.trailingAnchor, constant: -10),
            newChatButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            newChatButton.heightAnchor.constraint(equalToConstant: 50),
            newChatButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func newChatButtonTouchDown() {
        newChatButton.isHighlighted = true
    }
    
    @objc func newChatButtonCancel() {
        newChatButton.isHighlighted = false
    }
    
    @objc func newChatButtonTouchUp() {
        newChatButton.isHighlighted = false
        if UserDefaults.standard.bool(forKey: "HapticState") {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }
    
    
    //MARK: - Text View
    
    func bottomStackViewSetup() {
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.axis = .horizontal
        bottomStackView.distribution = .fill
        bottomStackView.alignment = .top
        bottomStackView.spacing = 10
        bottomStackBottomConstraint = bottomStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        
        view.addSubview(bottomStackView)
        NSLayoutConstraint.activate([
            bottomStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            bottomStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            bottomStackBottomConstraint!
        ])
    }
    
    func textFieldViewSetup() {
        fieldView.translatesAutoresizingMaskIntoConstraints = false
        fieldView.backgroundColor = .systemGray6
        fieldView.layer.borderWidth = 2
        fieldView.layer.borderColor = UIColor.systemGray5.cgColor
        fieldView.layer.cornerRadius = 25
        fieldView.alpha = 0.9
        
        bottomStackView.addArrangedSubview(fieldView)
        NSLayoutConstraint.activate([
            fieldView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    //MARK: - Text Field
    
    func textFieldTextSetup() {
        fieldText.delegate = self
        fieldText.text = ""
        fieldText.translatesAutoresizingMaskIntoConstraints = false
        fieldText.autocapitalizationType = .sentences
        fieldText.autocorrectionType = .yes
        fieldText.backgroundColor = .clear
        fieldText.textColor = .label
        fieldText.alpha = 0.9
        fieldText.isScrollEnabled = true
        fieldText.font = .systemFont(ofSize: 16, weight: .medium)
        fieldText.textContainerInset = .init(top: 13, left: 0, bottom: 13, right: 3.5)
        
        fieldTextStandardConstraint = [
            fieldText.topAnchor.constraint(equalTo: fieldView.topAnchor, constant: 2),
            fieldText.bottomAnchor.constraint(equalTo: fieldView.bottomAnchor, constant: -2),
            fieldText.leadingAnchor.constraint(equalTo: fieldView.leadingAnchor, constant: 20),
            fieldText.trailingAnchor.constraint(equalTo: eraseButton.leadingAnchor)
        ]
        
        fieldTextBigConstraint = [
            fieldText.topAnchor.constraint(equalTo: fieldView.topAnchor, constant: 2),
            fieldText.bottomAnchor.constraint(equalTo: fieldView.bottomAnchor, constant: -2),
            fieldText.leadingAnchor.constraint(equalTo: fieldView.leadingAnchor, constant: 2),
            fieldText.trailingAnchor.constraint(equalTo: fieldView.trailingAnchor, constant: -2)
        ]
        
        fieldView.addSubview(fieldText)
        NSLayoutConstraint.activate(fieldTextBigConstraint)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        checkFieldPlaceholder()
        checkDismissButton()
        checkEraseButton()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        NSLayoutConstraint.deactivate(fieldTextBigConstraint)
        NSLayoutConstraint.activate(fieldTextStandardConstraint)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.fieldPlaceholderCenterConstraint.isActive = false
            self.fieldPlaceholderLeadingConstraint.isActive = true
            self.view.layoutIfNeeded()
        })
        
        checkFieldPlaceholder()
        checkDismissButton()
        checkEraseButton()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if fieldText.text!.isEmpty {
            NSLayoutConstraint.deactivate(fieldTextStandardConstraint)
            NSLayoutConstraint.activate(fieldTextBigConstraint)
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.fieldPlaceholderLeadingConstraint.isActive = false
            self.fieldPlaceholderCenterConstraint.isActive = true
            self.view.layoutIfNeeded()
        })
        checkFieldPlaceholder()
        checkDismissButton()
        checkEraseButton()
    }
    
    //MARK: - Field Placeholder
    
    func fieldPlaceholderSetup() {
        fieldPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        fieldPlaceholder.text = "Ask AI anything..."
        fieldPlaceholder.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        fieldPlaceholder.textColor = UIColor.systemGray2
        fieldPlaceholder.textAlignment = .center
        
        fieldPlaceholderCenterConstraint = fieldPlaceholder.centerXAnchor.constraint(equalTo: fieldView.centerXAnchor)
        fieldPlaceholderLeadingConstraint = fieldPlaceholder.leadingAnchor.constraint(equalTo: fieldText.leadingAnchor, constant: 5)
        
        fieldView.addSubview(fieldPlaceholder)
        NSLayoutConstraint.activate([
            fieldPlaceholderCenterConstraint,
            fieldPlaceholder.centerYAnchor.constraint(equalTo: fieldView.centerYAnchor)
        ])
    }
    
    func checkFieldPlaceholder() {
        if fieldText.text.isEmpty {
            fieldPlaceholder.alpha = 1
        } else {
            fieldPlaceholder.alpha = 0
        }
    }
    
    //MARK: - Erase Button
    
    func eraseButtonSetup() {
        eraseButton.translatesAutoresizingMaskIntoConstraints = false
        eraseButton.imageView?.contentMode = .scaleAspectFit
        eraseButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        eraseButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(weight: .semibold), forImageIn: .normal)
        eraseButton.tintColor = .systemGray2
        eraseButton.layer.cornerRadius = 22.5
        eraseButton.alpha = 0
        eraseButton.addTarget(self, action: #selector(eraseText), for: .touchUpInside)
        
        bottomStackView.addSubview(eraseButton)
        NSLayoutConstraint.activate([
            eraseButton.trailingAnchor.constraint(equalTo: fieldView.trailingAnchor, constant: -2),
            eraseButton.centerYAnchor.constraint(equalTo: fieldView.centerYAnchor),
            eraseButton.heightAnchor.constraint(equalTo: fieldView.heightAnchor, constant: -4),
            eraseButton.widthAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    @objc func checkEraseButton() {
        if fieldText.text!.isEmpty {
            UIView.animate(withDuration: 0.15, animations: {
                self.eraseButton.alpha = 0
            })
        } else {
            UIView.animate(withDuration: 0.15, animations: {
                self.eraseButton.alpha = 1
            })
        }
    }
    
    @objc func eraseText() {
        AnimationManager().animateTextWithBottomSlide(label: fieldText, newText: "", duration: 0.15)
        AnimationManager().animateLabelWithBottomSlide(label: fieldPlaceholder, duration: 0.15)
        
        if !fieldText.isEditing {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: { [self] in
                NSLayoutConstraint.deactivate(fieldTextStandardConstraint)
                NSLayoutConstraint.activate(fieldTextBigConstraint)
            })
        }
        UIView.animate(withDuration: 0.15, animations: {
            self.eraseButton.alpha = 0
            self.view.layoutIfNeeded()
        })
        if UserDefaults.standard.bool(forKey: "HapticState") {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }
    
    
    //MARK: - AI Button
    
    func aiButtonSetup() {
        aiButton.translatesAutoresizingMaskIntoConstraints = false
        aiButton.imageView?.contentMode = .scaleAspectFit
        aiButton.setImage(UIImage(systemName: "apple.intelligence"), for: .normal)
        aiButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(weight: .semibold), forImageIn: .normal)
        aiButton.tintColor = .systemGray2
        aiButton.backgroundColor = .systemGray6
        aiButton.layer.borderColor = UIColor.systemGray5.cgColor
        aiButton.layer.borderWidth = 2
        aiButton.layer.cornerRadius = 25
        aiButton.alpha = 0.9
        
        aiButton.addTarget(self, action: #selector(aiButtonTouchDown), for: [.touchDown, .touchDragEnter, .touchDownRepeat])
        aiButton.addTarget(self, action: #selector(aiButtonCancel), for: [.touchCancel, .touchDragExit, .touchUpOutside])
        aiButton.addTarget(self, action: #selector(aiButtonTouchUp), for: [.touchUpInside])
        
        bottomStackView.addArrangedSubview(aiButton)
        NSLayoutConstraint.activate([
            aiButton.heightAnchor.constraint(equalToConstant: 50),
            aiButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func aiButtonTouchDown() {
        aiButton.tintColor = .white
        aiButton.backgroundColor = .systemGray3
        aiButton.layer.borderColor = UIColor.systemGray2.cgColor
    }
    
    @objc func aiButtonCancel() {
        aiButton.tintColor = .systemGray2
        aiButton.backgroundColor = .systemGray6
        aiButton.layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    @objc func aiButtonTouchUp() {
        aiButton.tintColor = .systemGray2
        aiButton.backgroundColor = .systemGray6
        aiButton.layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    //MARK: - Send Button
    
    func sendButtonSetup() {
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.imageView?.contentMode = .scaleAspectFit
        sendButton.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        sendButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(weight: .semibold), forImageIn: .normal)
        sendButton.tintColor = .white
        sendButton.backgroundColor = #colorLiteral(red: 0.02999999933, green: 0.02999999933, blue: 0.02999999933, alpha: 1)
        sendButton.layer.borderColor = #colorLiteral(red: 0.1999999881, green: 0.1999999881, blue: 0.1999999881, alpha: 1)
        sendButton.layer.borderWidth = 2
        sendButton.layer.cornerRadius = 25
        sendButton.alpha = 0.9
        
        sendButton.addTarget(self, action: #selector(sendButtonTouchDown), for: [.touchDown, .touchDragEnter, .touchDownRepeat])
        sendButton.addTarget(self, action: #selector(sendButtonCancel), for: [.touchCancel, .touchDragExit, .touchUpOutside])
        sendButton.addTarget(self, action: #selector(sendButtonTouchUp), for: [.touchUpInside])
        
        bottomStackView.addArrangedSubview(sendButton)
        NSLayoutConstraint.activate([
            sendButton.heightAnchor.constraint(equalToConstant: 50),
            sendButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func sendButtonTouchDown() {
        sendButton.backgroundColor = #colorLiteral(red: 0.1999999881, green: 0.1999999881, blue: 0.1999999881, alpha: 1)
        sendButton.layer.borderColor = #colorLiteral(red: 0.3000000119, green: 0.3000000119, blue: 0.3000000119, alpha: 1)
    }
    
    @objc func sendButtonCancel() {
        sendButton.backgroundColor = #colorLiteral(red: 0.02999999933, green: 0.02999999933, blue: 0.02999999933, alpha: 1)
        sendButton.layer.borderColor = #colorLiteral(red: 0.1999999881, green: 0.1999999881, blue: 0.1999999881, alpha: 1)
    }
    
    @objc func sendButtonTouchUp() {
        sendButton.backgroundColor = #colorLiteral(red: 0.02999999933, green: 0.02999999933, blue: 0.02999999933, alpha: 1)
        sendButton.layer.borderColor = #colorLiteral(red: 0.1999999881, green: 0.1999999881, blue: 0.1999999881, alpha: 1)
        
        guard fieldText.text?.isEmpty != true else { return }
        print(fieldText.text!)
        AnimationManager().animateTextWithTopSlide(label: fieldText, newText: "", duration: 0.2)
        AnimationManager().animateLabelWithTopSlide(label: fieldPlaceholder, duration: 0.15)
        fieldText.endEditing(true)
        
        NSLayoutConstraint.deactivate(fieldTextStandardConstraint)
        NSLayoutConstraint.activate(fieldTextBigConstraint)
        
        if eraseButton.alpha != 0 {
            UIView.animate(withDuration: 0.15, animations: {
                self.eraseButton.alpha = 0
                self.view.layoutIfNeeded()
            })
        }
        if UserDefaults.standard.bool(forKey: "HapticState") {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }
    
    
    //MARK: - Keyboard Handling
    
    func dismissKeyboardButtonSetup() {
        dismissKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        dismissKeyboardButton.imageView?.contentMode = .scaleAspectFit
        dismissKeyboardButton.setImage(UIImage(systemName: "keyboard.chevron.compact.down"), for: .normal)
        dismissKeyboardButton.tintColor = .systemGray3
        dismissKeyboardButton.backgroundColor = .systemGray6
        dismissKeyboardButton.layer.cornerRadius = 17.5
        dismissKeyboardButton.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
        dismissKeyboardButton.alpha = 0
        
        view.addSubview(dismissKeyboardButton)
        NSLayoutConstraint.activate([
            dismissKeyboardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dismissKeyboardButton.topAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -40),
            dismissKeyboardButton.heightAnchor.constraint(equalToConstant: 35),
            dismissKeyboardButton.widthAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    @objc func dismissKeyboard(_ sender: UIButton) {
        fieldText.endEditing(true)
    }
    
    @objc func checkDismissButton() {
        if fieldText.isEditing {
            UIView.animate(withDuration: 0.4, animations: {
                self.dismissKeyboardButton.alpha = 0.8
                self.dismissKeyboardButton.isUserInteractionEnabled = true
            })
        } else {
            UIView.animate(withDuration: 0.35, animations: {
                self.dismissKeyboardButton.alpha = 0
                self.dismissKeyboardButton.isUserInteractionEnabled = false
            })
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if fieldText.isEditing {
            moveViewWithKeyboard(notification: notification, viewBottomConstraint: self.bottomStackBottomConstraint, keyboardWillSHow: true)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        moveViewWithKeyboard(notification: notification, viewBottomConstraint: self.bottomStackBottomConstraint, keyboardWillSHow: false)
    }
    
    func moveViewWithKeyboard(notification: Notification, viewBottomConstraint: NSLayoutConstraint, keyboardWillSHow: Bool) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardHeight = keyboardSize.height
        
        guard let keyboardDuration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        let keyboardCurve = UIView.AnimationCurve(rawValue: notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! Int)!
        let safeAreaBottom = self.view?.window?.safeAreaInsets.bottom ?? 0
        
        if keyboardWillSHow {
            viewBottomConstraint.constant = -(keyboardHeight - safeAreaBottom + 10)
        } else {
            viewBottomConstraint.constant = -10
        }
        
        let animator = UIViewPropertyAnimator(duration: keyboardDuration, curve: keyboardCurve) {
            self.view.layoutIfNeeded()
        }
        
        animator.startAnimation()
    }
    
}

//MARK: - Extensions

extension UITextView {
    var isEditing: Bool {
        isFirstResponder
    }
}

