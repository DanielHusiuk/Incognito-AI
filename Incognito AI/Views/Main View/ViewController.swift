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
    let centerLabel = CenterLabel()
    let centerDetailLabelButton = MessagesButton()
    
    let settingsButton = SettingsButton()
    let newChatButton = NewChatButton()
    
    let bottomStackView: UIStackView = .init(frame: .zero)
    var bottomStackBottomConstraint: NSLayoutConstraint!
    
    let aiButton = AiButton()
    let aiPickerContainer: UIView = .init(frame: .zero)
    let aiPickerView: UIView = .init(frame: .zero)
    let aiPickerStack: UIStackView = .init(frame: .zero)
    let aiPickerModel = AiPickerModel()
    var aiPickerButtons: [AiPickerButton] = []
    let aiPickerShadowView: UIView = .init(frame: .zero)
    
    let fieldView: UIView = .init(frame: .zero)
    let fieldText: UITextView = .init(frame: .zero)
    var fieldTextHeightConstraint: NSLayoutConstraint!
    var fieldTextStandardConstraint: [NSLayoutConstraint]!
    var fieldTextBigConstraint: [NSLayoutConstraint]!
    
    let fieldPlaceholder: UILabel = .init(frame: .zero)
    var fieldPlaceholderCenterConstraint: NSLayoutConstraint!
    var fieldPlaceholderLeadingConstraint: NSLayoutConstraint!
    
    let sendButton: UIButton = .init(frame: .zero)
    let eraseButton: UIButton = .init(frame: .zero)
    let dismissKeyboardButton: UIButton = .init(frame: .zero)
    
    let openAiApi = ApiManager()
    let requestView = UILabel()
    let responseView = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundSetup()
        
        loadUserDefaults()
        loadTopView()
        loadBottomView()
        loadNotifications()
        
        messagesSetup()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            aiButton.layer.borderColor = UIColor.systemGray5.cgColor
            fieldView.layer.borderColor = UIColor.systemGray5.cgColor
            aiPickerView.layer.borderColor = UIColor.systemGray5.cgColor
        }
        checkScreenOrientation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            self.loadShadows()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UserDefaults.standard.set(false, forKey: "isEditing")
    }
    
    
    //MARK: - Load Views
    
    func loadUserDefaults() {
        UserDefaults.standard.set(true, forKey: "HapticState")
        UserDefaults.standard.set(false, forKey: "isEditing")
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
        aiPickerViewSetup()
        aiPickerStackSetup()
        addAiPickerViewData()
        dismissKeyboardButtonSetup()
    }
    
    func loadNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleButtonTap), name: Notification.Name("pickerButtonTapped"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func loadShadows() {
        ShadowManager().applyShadow(to: settingsButton, opacity: 0.5, shadowRadius: 10, viewBounds: settingsButton.bounds.insetBy(dx: 15, dy: 15))
        ShadowManager().applyShadow(to: newChatButton, opacity: 0.5, shadowRadius: 10, viewBounds: newChatButton.bounds.insetBy(dx: 15, dy: 15))
        ShadowManager().applyShadow(to: labelStackView, opacity: 0.1, shadowRadius: 10, viewBounds: labelStackView.bounds)
        
        ShadowManager().applyShadow(to: aiButton, opacity: 0.3, shadowRadius: 10, viewBounds: aiButton.bounds.insetBy(dx: 0, dy: 5))
        ShadowManager().applyShadow(to: fieldView, opacity: 0.3, shadowRadius: 10, viewBounds: fieldView.bounds.insetBy(dx: 0, dy: 5))
        ShadowManager().applyShadow(to: sendButton, opacity: 0.3, shadowRadius: 10, viewBounds: sendButton.bounds.insetBy(dx: 0, dy: 5))
    }
    
    
    //MARK: - Preferences
    
    func checkScreenOrientation() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let orientation = windowScene.interfaceOrientation
            if orientation.isPortrait {
                resizeTextView(fieldText)
                fieldText.endEditing(true)
                guard topStackView.alpha == 0 else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.topStackView.alpha = 1
                        self.settingsButton.alpha = 1
                        self.newChatButton.alpha = 1
                        if UserDefaults.standard.bool(forKey: "isEditing") { self.fieldText.becomeFirstResponder() }
                        print(UserDefaults.standard.bool(forKey: "isEditing"))
                    })
                })
            } else {
                resizeTextView(fieldText)
                fieldText.endEditing(true)
                guard topStackView.alpha == 1 else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.topStackView.alpha = 0
                        self.settingsButton.alpha = 0
                        self.newChatButton.alpha = 0
                        if UserDefaults.standard.bool(forKey: "isEditing") { self.fieldText.becomeFirstResponder() }
                        print(UserDefaults.standard.bool(forKey: "isEditing"))
                    })
                })
            }
        }
    }
    
    
    //MARK: - Background
    
    func backgroundSetup() {
        let backgroundAnimated = AnimatedBackgroundView()
        let hostingController = UIHostingController(rootView: backgroundAnimated)
        hostingController.view?.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .background
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    //MARK: - Messages UI
    
    func messagesSetup() {
        //temporary label for requests
        requestView.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        requestView.textColor = .label
        requestView.textAlignment = .left
        requestView.backgroundColor = .systemGray5
        requestView.numberOfLines = 10
        requestView.translatesAutoresizingMaskIntoConstraints = false
        requestView.text = fieldText.text
        
        view.addSubview(requestView)
        NSLayoutConstraint.activate([
            requestView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -50),
            requestView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            requestView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            requestView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50)
        ])
        
        //temporary label for responses
        responseView.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        responseView.textColor = .label
        responseView.textAlignment = .left
        responseView.backgroundColor = .systemGray5
        responseView.numberOfLines = 10
        responseView.translatesAutoresizingMaskIntoConstraints = false
        responseView.text = openAiApi.finalResponse
        
        view.addSubview(responseView)
        NSLayoutConstraint.activate([
            responseView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 50),
            responseView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            responseView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            responseView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50)
        ])
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
        view.insertSubview(hostingController.view, belowSubview: topStackView)
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
        view.insertSubview(hostingController.view, belowSubview: bottomStackView)
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
        labelStackView.alignment = .center
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.addSubview(labelStackView)
        
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            labelStackView.centerXAnchor.constraint(equalTo: topStackView.centerXAnchor)
        ])
    }
    
    func centerLabelSetup() {
        labelStackView.addArrangedSubview(centerLabel)
        guard UserDefaults.standard.value(forKey: "buttonTitle") != nil else { return }
        centerLabel.text = UserDefaults.standard.string(forKey: "buttonTitle")
    }
    
    
    //MARK: - Messages Button
    
    func centerDetailLabelButtonSetup() {
        labelStackView.addArrangedSubview(centerDetailLabelButton)
        NSLayoutConstraint.activate([
            centerDetailLabelButton.widthAnchor.constraint(equalTo: centerDetailLabelButton.titleLabel!.widthAnchor, constant: 12),
            centerDetailLabelButton.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    
    //MARK: - Settings Button
    
    func settingsButtonSetup() {
        topStackView.addSubview(settingsButton)
        NSLayoutConstraint.activate([
            settingsButton.leadingAnchor.constraint(equalTo: topStackView.leadingAnchor, constant: 10),
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            settingsButton.heightAnchor.constraint(equalToConstant: 50),
            settingsButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    //MARK: - New Chat Button
    
    func newChatButtonSetup() {
        topStackView.addSubview(newChatButton)
        NSLayoutConstraint.activate([
            newChatButton.trailingAnchor.constraint(equalTo: topStackView.trailingAnchor, constant: -10),
            newChatButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            newChatButton.heightAnchor.constraint(equalToConstant: 50),
            newChatButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    //MARK: - Bottom Stack View
    
    func bottomStackViewSetup() {
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.axis = .horizontal
        bottomStackView.distribution = .fill
        bottomStackView.alignment = .bottom
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
            fieldView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
    }
    
    
    //MARK: - Text Field View
    
    func textFieldTextSetup() {
        fieldText.delegate = self
        fieldText.text = ""
        fieldText.font = .systemFont(ofSize: 16, weight: .medium)
        fieldText.translatesAutoresizingMaskIntoConstraints = false
        fieldText.autocapitalizationType = .sentences
        fieldText.autocorrectionType = .yes
        fieldText.backgroundColor = .clear
        fieldText.textColor = .label
        fieldText.alpha = 0.9
        fieldText.isScrollEnabled = false
        fieldText.clipsToBounds = true
        fieldText.textContainerInset = .init(top: 13, left: 0, bottom: 13, right: 3.5)
        fieldTextHeightConstraint = fieldText.heightAnchor.constraint(equalToConstant: 46)
        fieldTextHeightConstraint.isActive = true
        
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
        UserDefaults.standard.set(true, forKey: "isEditing")
        checkFieldPlaceholder()
        checkDismissButton()
        checkEraseButton()
        resizeTextView(fieldText)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        NSLayoutConstraint.deactivate(fieldTextBigConstraint)
        NSLayoutConstraint.activate(fieldTextStandardConstraint)
        UserDefaults.standard.set(true, forKey: "isEditing")
        
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
    
    func resizeTextView(_ textView: UITextView) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let orientation = windowScene.interfaceOrientation
            
            if orientation.isLandscape {
                fieldTextHeightConstraint.constant = 46
                textView.isScrollEnabled = true
            } else if orientation.isPortrait {
                textView.isScrollEnabled = false
                let newSize = textView.sizeThatFits(CGSize(width: textView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
                let maxHeight: CGFloat = 110
                fieldTextHeightConstraint.constant = min(newSize.height, maxHeight)
                textView.isScrollEnabled = newSize.height >= maxHeight
            }
        }
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            self.loadShadows()
        })
    }
    
    
    //MARK: - Field Placeholder
    
    func fieldPlaceholderSetup() {
        fieldPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        fieldPlaceholder.text = "Ask AI anything..."
        fieldPlaceholder.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        fieldPlaceholder.textColor = UIColor.systemGray2
        fieldPlaceholder.textAlignment = .center
        fieldPlaceholder.clipsToBounds = true
        
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
        
        eraseButton.addTarget(self, action: #selector(eraseTextDown), for: [.touchDown, .touchDragEnter, .touchDownRepeat])
        eraseButton.addTarget(self, action: #selector(eraseTextCancel), for: [.touchCancel, .touchDragExit, .touchUpOutside])
        eraseButton.addTarget(self, action: #selector(eraseTextUp), for: [.touchUpInside])
        
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
    
    @objc func eraseTextDown() {
        eraseButton.tintColor = .systemGray
    }
    
    @objc func eraseTextCancel() {
        UIView.animate(withDuration: 0.1, animations: {
            self.eraseButton.tintColor = .systemGray2
        })
    }
    
    @objc func eraseTextUp() {
        UIView.animate(withDuration: 0.1, animations: {
            self.eraseButton.tintColor = .systemGray2
        })
        
        fieldText.text.append("\n")
        AnimationManager().animateTextWithBottomSlide(label: fieldText, newText: "", duration: 0.15)
        
        if !fieldText.isEditing {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: { [self] in
                NSLayoutConstraint.deactivate(fieldTextStandardConstraint)
                NSLayoutConstraint.activate(fieldTextBigConstraint)
            })
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.fieldTextHeightConstraint.constant = 46
            self.eraseButton.alpha = 0
            self.view.layoutIfNeeded()
            self.loadShadows()
        })
        AnimationManager().animateLabelWithBottomSlide(view: fieldPlaceholder, duration: 0.15)
        
        if UserDefaults.standard.bool(forKey: "HapticState") {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }
    
    
    //MARK: - AI Button
    
    func aiButtonSetup() {
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
        UIView.animate(withDuration: 0.1, animations: {
            self.aiButton.tintColor = .systemGray2
            self.aiButton.backgroundColor = .systemGray6
            self.aiButton.layer.borderColor = UIColor.systemGray5.cgColor
        })
    }
    
    @objc func aiButtonTouchUp() {
        UIView.animate(withDuration: 0.1, animations: {
            self.aiButton.tintColor = .systemGray2
            self.aiButton.backgroundColor = .systemGray6
            self.aiButton.layer.borderColor = UIColor.systemGray5.cgColor
        })
        
        if aiPickerView.isHidden {
            //show
            aiPickerView.alpha = 0.9
            aiPickerView.isHidden = false
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.aiButton.transform = CGAffineTransform(rotationAngle: -.pi)
                self.aiPickerView.transform = CGAffineTransform(translationX: 0, y: 0)
            })
            
            UIView.animate(withDuration: 0.2,  delay: 0.2, options: .curveLinear, animations: {
                ShadowManager().applyShadow(to: self.aiPickerShadowView, opacity: 0.2, shadowRadius: 10, viewBounds: self.aiPickerShadowView.bounds.insetBy(dx: 0, dy: 5))
            })
        } else {
            //hide
            UIView.animate(withDuration: 0.2, animations: {
                ShadowManager().applyShadow(to: self.aiPickerShadowView, opacity: 0, shadowRadius: 0, viewBounds: self.aiPickerShadowView.bounds.insetBy(dx: 0, dy: 0))
            })
            
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                self.aiButton.transform = CGAffineTransform(rotationAngle: .pi * 2)
                self.aiPickerView.transform = CGAffineTransform(translationX: 0, y: 262)
            })
            
            UIView.animate(withDuration: 0.2, delay: 0.3, options: .curveLinear, animations: {
                self.aiPickerView.alpha = 0
            }) { _ in
                self.aiPickerView.isHidden = true
            }
            
        }
        
    }
    
    
    //MARK: - AI Picker View
    
    func aiPickerViewSetup() {
        aiPickerContainer.translatesAutoresizingMaskIntoConstraints = false
        aiPickerContainer.layer.cornerRadius = 25
        aiPickerContainer.clipsToBounds = true
        view.insertSubview(aiPickerContainer, belowSubview: bottomStackView)
        
        aiPickerShadowView.translatesAutoresizingMaskIntoConstraints = false
        aiPickerShadowView.layer.cornerRadius = 25
        aiPickerShadowView.clipsToBounds = true
        view.insertSubview(aiPickerShadowView, belowSubview: aiPickerContainer)
        
        NSLayoutConstraint.activate([
            aiPickerContainer.bottomAnchor.constraint(equalTo: aiButton.bottomAnchor),
            aiPickerContainer.centerXAnchor.constraint(equalTo: aiButton.centerXAnchor),
            aiPickerContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
            aiPickerContainer.widthAnchor.constraint(equalTo: aiButton.widthAnchor),
            
            aiPickerShadowView.bottomAnchor.constraint(equalTo: aiPickerContainer.bottomAnchor),
            aiPickerShadowView.centerXAnchor.constraint(equalTo: aiPickerContainer.centerXAnchor),
            aiPickerShadowView.heightAnchor.constraint(equalTo: aiPickerContainer.heightAnchor),
            aiPickerShadowView.widthAnchor.constraint(equalTo: aiPickerContainer.widthAnchor)
        ])
        
        aiPickerView.translatesAutoresizingMaskIntoConstraints = false
        aiPickerView.backgroundColor = .systemGray6
        aiPickerView.layer.borderWidth = 2
        aiPickerView.layer.borderColor = UIColor.systemGray5.cgColor
        aiPickerView.layer.cornerRadius = 25
        aiPickerView.alpha = 0
        aiPickerView.isHidden = true
        aiPickerView.clipsToBounds = true
        aiPickerView.transform = CGAffineTransform(translationX: 0, y: 262)
        aiPickerContainer.addSubview(aiPickerView)
        
        NSLayoutConstraint.activate([
            aiPickerView.bottomAnchor.constraint(equalTo: aiPickerContainer.bottomAnchor),
            aiPickerView.heightAnchor.constraint(equalTo: aiPickerContainer.heightAnchor),
            aiPickerView.widthAnchor.constraint(equalTo: aiPickerContainer.widthAnchor)
        ])
    }
    
    func aiPickerStackSetup() {
        aiPickerStack.translatesAutoresizingMaskIntoConstraints = false
        aiPickerStack.axis = .vertical
        aiPickerStack.distribution = .fill
        aiPickerStack.alignment = .top
        aiPickerStack.spacing = 4
        
        aiPickerView.insertSubview(aiPickerStack, aboveSubview: aiPickerContainer)
        NSLayoutConstraint.activate([
            aiPickerStack.leadingAnchor.constraint(equalTo: aiPickerView.leadingAnchor, constant: 6),
            aiPickerStack.trailingAnchor.constraint(equalTo: aiPickerView.trailingAnchor, constant: -6),
            aiPickerStack.topAnchor.constraint(equalTo: aiPickerView.topAnchor, constant: 6),
            aiPickerStack.bottomAnchor.constraint(equalTo: aiPickerView.bottomAnchor, constant: -56)
        ])
    }
    
    func addAiPickerViewData() {
        for (index, buttonModel) in aiPickerModel.buttons.enumerated() {
            let button = AiPickerButton(model: buttonModel)
            aiPickerButtons.append(button)
            aiPickerStack.addArrangedSubview(button)
            button.addTarget(self, action: #selector(pickerButtonTap(_:)), for: .touchUpInside)
            
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: aiPickerStack.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: aiPickerStack.trailingAnchor)
            ])
            
            if index < aiPickerModel.buttons.count - 1 {
                let aiPickerSpacer = AiPickerSpacer()
                aiPickerStack.addArrangedSubview(aiPickerSpacer)
                
                NSLayoutConstraint.activate([
                    aiPickerSpacer.centerXAnchor.constraint(equalTo: aiPickerStack.centerXAnchor),
                    aiPickerSpacer.leadingAnchor.constraint(equalTo: aiPickerStack.leadingAnchor, constant: 4),
                    aiPickerSpacer.trailingAnchor.constraint(equalTo: aiPickerStack.trailingAnchor, constant: -4)
                ])
            }
        }
        
        if let savedButton = UserDefaults.standard.object(forKey: "buttonId") as? Int {
            aiPickerButtons[savedButton].setSelected(true)
        }
    }
    

    
    @objc func pickerButtonTap(_ sender: AiPickerButton) {
        for button in aiPickerButtons {
            let isSelected = (button.model?.id == sender.model?.id)
            button.setSelected(isSelected)
        }
    }
    
    @objc func handleButtonTap(_ notification: Notification) {
        guard let button = notification.object as? PickerButton else { return }
        
        //center label
        AnimationManager().animateLabelWithBottomSlide(view: self.centerLabel, duration: 0.15)
        AnimationManager().animateLabelWithBottomSlide(view: self.centerDetailLabelButton, duration: 0.15)
        UIView.animate(withDuration: 0.1, delay: 0.05, options: .curveLinear, animations: {
            ShadowManager().applyShadow(to: self.labelStackView, opacity: 0, shadowRadius: 10, viewBounds: self.labelStackView.bounds)
        }, completion: { _ in
            self.centerLabel.text = button.title
            //self.centerDetailLabelButton.titleLabel?.text = messages count
            UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
                ShadowManager().applyShadow(to: self.labelStackView, opacity: 0.1, shadowRadius: 10, viewBounds: self.labelStackView.bounds)
            })
        })
        
        //picker
        UIView.animate(withDuration: 0.2, animations: {
            ShadowManager().applyShadow(to: self.aiPickerShadowView, opacity: 0, shadowRadius: 0, viewBounds: self.aiPickerShadowView.bounds.insetBy(dx: 0, dy: 0))
        })
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
            self.aiButton.transform = CGAffineTransform(rotationAngle: .pi * 2)
            self.aiPickerView.transform = CGAffineTransform(translationX: 0, y: 262)
        })
        UIView.animate(withDuration: 0.2, delay: 0.3, options: .curveLinear, animations: {
            self.aiPickerView.alpha = 0
        }) { _ in
            self.aiPickerView.isHidden = true
        }
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
        UIView.animate(withDuration: 0.1, animations: {
            self.sendButton.backgroundColor = #colorLiteral(red: 0.02999999933, green: 0.02999999933, blue: 0.02999999933, alpha: 1)
            self.sendButton.layer.borderColor = #colorLiteral(red: 0.1999999881, green: 0.1999999881, blue: 0.1999999881, alpha: 1)
        })
    }
    
    @objc func sendButtonTouchUp() {
        UIView.animate(withDuration: 0.1, animations: {
            self.sendButton.backgroundColor = #colorLiteral(red: 0.02999999933, green: 0.02999999933, blue: 0.02999999933, alpha: 1)
            self.sendButton.layer.borderColor = #colorLiteral(red: 0.1999999881, green: 0.1999999881, blue: 0.1999999881, alpha: 1)
        })
        
        guard let text = fieldText.text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        requestView.text = fieldText.text
        openAiApi.userMessage = fieldText.text
        
        openAiApi.loadData()
        print(openAiApi.finalResponse)
        
        AnimationManager().animateTextWithTopSlide(label: fieldText, newText: "", duration: 0.15)
        fieldText.endEditing(true)
        UserDefaults.standard.set(false, forKey: "isEditing")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { [self] in
            NSLayoutConstraint.deactivate(fieldTextStandardConstraint)
            NSLayoutConstraint.activate(fieldTextBigConstraint)
        })
        
        if eraseButton.alpha != 0 {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.fieldTextHeightConstraint.constant = 46
                self.eraseButton.alpha = 0
                self.view.layoutIfNeeded()
                self.loadShadows()
            })
        }
        
        AnimationManager().animateLabelWithTopSlide(view: fieldPlaceholder, duration: 0.15)
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
        dismissKeyboardButton.alpha = 0
        
        dismissKeyboardButton.addTarget(self, action: #selector(dismissKeyboardDown), for: [.touchDown, .touchDragEnter, .touchDownRepeat])
        dismissKeyboardButton.addTarget(self, action: #selector(dismissKeyboardCancel), for: [.touchCancel, .touchDragExit, .touchUpOutside])
        dismissKeyboardButton.addTarget(self, action: #selector(dismissKeyboardUp), for: [.touchUpInside])
        
        view.addSubview(dismissKeyboardButton)
        NSLayoutConstraint.activate([
            dismissKeyboardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dismissKeyboardButton.topAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -40),
            dismissKeyboardButton.heightAnchor.constraint(equalToConstant: 35),
            dismissKeyboardButton.widthAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    @objc func dismissKeyboardDown(_ sender: UIButton) {
        dismissKeyboardButton.tintColor = .systemGray
    }
    
    @objc func dismissKeyboardCancel(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            self.dismissKeyboardButton.tintColor = .systemGray3
        })
    }
    
    @objc func dismissKeyboardUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            self.dismissKeyboardButton.tintColor = .systemGray
        })
        
        UserDefaults.standard.set(false, forKey: "isEditing")
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
