//
//  ViewController.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 11.09.2025.
//

import UIKit
import SwiftUI
import Combine

class ViewController: UIViewController, UITextViewDelegate, UICollectionViewDelegate {
    
    let topStackView: UIStackView = .init(frame: .zero)
    let spacer = UIView()
    let labelStackView: UIStackView = .init(frame: .zero)
    let centerLabel = CenterLabel()
    let centerDetailLabelButton = RequestsButton()
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
    var aiPickerShadowView: UIView = .init(frame: .zero)
    
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
    let scrollDownButton = ScrollDownButton()
    
    let apiManager = ApiManager()
    let messagesCollectionView = MessagesCollectionView()
    private var topBlurHostingController: UIViewController?
    
    private let networkManager = NetworkManager()
    private var cancellables = Set<AnyCancellable>()
    private var previousNetworkState: Bool?
    
    private var typingTimer: Timer?
    var loadingIndicator: UIActivityIndicatorView = .init(style: .medium)
    
    private var isUserAtBottom: Bool {
        return messagesCollectionView.isRoughlyAtBottom(tolerance: fieldTextHeightConstraint.constant + 5)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundSetup()
        collectionViewSetup()
        
        loadUserDefaults()
        loadTopView()
        loadBottomView()
        
        loadNotifications()
        setupNetworkObservation()
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
            self.keyboardSwipeDownAnimation()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.window?.windowScene?.screenshotService?.delegate = self
        collectionViewLayout()
        
        DispatchQueue.main.async {
            self.messagesCollectionView.layoutIfNeeded()
            self.updateScrollDownButton()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UserDefaults.standard.set(false, forKey: "isEditing")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.messagesCollectionView.collectionViewLayout.invalidateLayout()
            self.topBlurHostingController?.view.layoutIfNeeded()
            self.messagesCollectionView.layoutSubviews()
        })
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
        loadingIndicatorSetup()
        
        aiPickerViewSetup()
        aiPickerStackSetup()
        addAiPickerViewData()
        
        dismissKeyboardButtonSetup()
        scrollDownButtonSetup()
    }
    
    func loadNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleButtonTap), name: Notification.Name("pickerButtonTapped"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func loadShadows() {
        ShadowManager().applyShadow(to: settingsButton, opacity: 0.2, shadowRadius: 10, viewBounds: settingsButton.bounds.insetBy(dx: 10, dy: 10))
        ShadowManager().applyShadow(to: newChatButton, opacity: 0.2, shadowRadius: 10, viewBounds: newChatButton.bounds.insetBy(dx: 10, dy: 10))
        ShadowManager().applyShadow(to: labelStackView, opacity: 0.1, shadowRadius: 10, viewBounds: labelStackView.bounds)
        
        ShadowManager().applyShadow(to: aiButton, opacity: 0.3, shadowRadius: 10, viewBounds: aiButton.bounds.insetBy(dx: 0, dy: 5))
        ShadowManager().applyShadow(to: fieldView, opacity: 0.3, shadowRadius: 10, viewBounds: fieldView.bounds.insetBy(dx: 0, dy: 5))
        ShadowManager().applyShadow(to: sendButton, opacity: 0.3, shadowRadius: 10, viewBounds: sendButton.bounds.insetBy(dx: 0, dy: 5))
        
        ShadowManager().applyShadow(to: dismissKeyboardButton, opacity: 0.1, shadowRadius: 10, viewBounds: sendButton.bounds.insetBy(dx: 0, dy: 5))
        ShadowManager().applyShadow(to: scrollDownButton, opacity: 0.1, shadowRadius: 10, viewBounds: sendButton.bounds.insetBy(dx: 0, dy: 5))
    }
    
    func collectionViewLayout() {
        let topInset = newChatButton.frame.height + 25
        messagesCollectionView.contentInset.top = topInset
        messagesCollectionView.verticalScrollIndicatorInsets.top = topInset
        messagesCollectionViewInsets()
    }
    
    
    //MARK: - Screen Orientation
    
    func checkScreenOrientation() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let orientation = windowScene.interfaceOrientation
            if orientation.isPortrait {
                resizeTextView(fieldText)
                guard topStackView.alpha == 0 else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.topStackView.alpha = 1
                        self.settingsButton.alpha = 1
                        self.newChatButton.alpha = 1
                        self.topBlurHostingController?.view.alpha = 1
                        self.collectionViewLayout()
                        self.messagesCollectionView.layoutIfNeeded()
                    })
                })
            } else {
                resizeTextView(fieldText)
                guard topStackView.alpha == 1 else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.topStackView.alpha = 0
                        self.settingsButton.alpha = 0
                        self.newChatButton.alpha = 0
                        self.topBlurHostingController?.view.alpha = 0
                        self.messagesCollectionView.contentInset.top = 0
                        self.messagesCollectionView.verticalScrollIndicatorInsets.top = 0
                        self.messagesCollectionView.layoutIfNeeded()
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
    
    
    //MARK: - Network Handling
    
    private func setupNetworkObservation() {
        networkManager.$hasNetworkConnection
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                self?.updateUINetworkStatus(isConnected)
            }
            .store(in: &cancellables)
    }
    
    private func updateUINetworkStatus(_ isAvailable: Bool) {
        fieldText.isUserInteractionEnabled = isAvailable
        fieldPlaceholder.text = isAvailable ? "Ask AI anything..." : "Internet connection is lost."
        
        sendButton.setImage(UIImage(systemName: isAvailable ? "arrow.up" : "wifi.slash"), for: .normal)
        sendButton.isUserInteractionEnabled = isAvailable
        
        if previousNetworkState != nil && previousNetworkState == true && isAvailable == false {
            let networkAlert = UIAlertController(title: "No internet connection", message: "Please check your internet connection.", preferredStyle: .alert)
            networkAlert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(networkAlert, animated: true, completion: nil)
        }
        
        previousNetworkState = isAvailable
    }
    
    private func userNotification(title: String, message: String) {
        let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(errorAlert, animated: true, completion: nil)
    }
    
    
    //MARK: - Messages UI
    
    func collectionViewSetup() {
        messagesCollectionView.externalScrollDelegate = self
        messagesCollectionView.delegate = self
        messagesCollectionView.keyboardDismissMode = .interactive
        
        view.addSubview(messagesCollectionView)
        NSLayoutConstraint.activate([
            messagesCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            messagesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            messagesCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            messagesCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateScrollDownButton()
        self.view.layoutIfNeeded()
    }
    
    private func updateScrollDownButton() {
        let isVisuallyBottom = messagesCollectionView.isVisuallyAtBottom(tolerance: 30)
        let shouldShow = !isVisuallyBottom
        
        UIView.animate(withDuration: 0.2) {
            self.scrollDownButton.alpha = shouldShow ? 1 : 0
            self.scrollDownButton.transform = shouldShow ? .identity: CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.scrollDownButton.isUserInteractionEnabled = shouldShow
        }
    }
    
    func messagesCollectionViewInsets() {
        view.layoutIfNeeded()
        let fullObstructionHeight = view.bounds.height - bottomStackView.frame.minY
        let hasBottomSafeArea = view.safeAreaInsets.bottom > 0
        
        let visualCorrection: CGFloat = hasBottomSafeArea ? 20 : -10
        let finalInset = fullObstructionHeight - visualCorrection
        
        messagesCollectionView.contentInset.bottom = finalInset
        messagesCollectionView.verticalScrollIndicatorInsets.bottom = finalInset
    }
    
    
    //MARK: - Typing Animation
    
    func animateTypingWords(_ fullText: String, to index: Int) {
        typingTimer?.invalidate()
        
        let words = fullText.split(separator: " ")
        var currentIndex = 0
        var currentText = ""
        
        typingTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            if currentIndex >= words.count {
                timer.invalidate()
                return
            }
            
            let prefix = currentText.isEmpty ? "" : " "
            currentText += prefix + words[currentIndex]
            currentIndex += 1
            
            self.messagesCollectionView.messages[index].content = currentText
            
            let indexPath = IndexPath(item: 0, section: index)
            if let cell = self.messagesCollectionView.cellForItem(at: indexPath) as? MessageCollectionViewCell {
                cell.configure(with: currentText, role: "assistant")
                
                UIView.performWithoutAnimation {
                    self.messagesCollectionView.performBatchUpdates(nil, completion: nil)
                }
                
                if self.isUserAtBottom {
                    let contentHeight = self.messagesCollectionView.contentSize.height
                    let boundsHeight = self.messagesCollectionView.bounds.height
                    let insets = self.messagesCollectionView.adjustedContentInset
                    
                    let rawOffsetY = contentHeight + insets.bottom - boundsHeight
                    let finalOffsetY = max(rawOffsetY, -insets.top)
                    self.messagesCollectionView.setContentOffset(CGPoint(x: 0, y: finalOffsetY), animated: false)
                }
            }
        }
    }
    
    
    //MARK: - Loading Indicator
    
    func loadingIndicatorSetup() {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.backgroundColor = .clear
        loadingIndicator.color = .white
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.isHidden = true
        
        sendButton.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: sendButton.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor),
            loadingIndicator.heightAnchor.constraint(equalTo: sendButton.heightAnchor),
            loadingIndicator.widthAnchor.constraint(equalTo: sendButton.widthAnchor)
        ])
    }
    
    
    //MARK: - Top/Bottom Blur
    
    func topBlurEffectSetup() {
        let blurEffect = BlurView()
            .blur(radius: 20)
            .padding(.horizontal, -100)
            .padding(.top, -100)
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
            hostingController.view.bottomAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 20)
        ])
        self.topBlurHostingController = hostingController
    }
    
    func bottomBlurEffectSetup() {
        let blurEffect = BlurView()
            .blur(radius: 20)
            .padding(.horizontal, -100)
            .padding(.bottom, -150)
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
            hostingController.view.heightAnchor.constraint(equalTo: bottomStackView.heightAnchor)
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
        UIView.animate(withDuration: 0.1, animations: {
            self.newChatButton.isHighlighted = false
        })
    }
    
    @objc func newChatButtonTouchUp() {
        UIView.animate(withDuration: 0.1, animations: {
            self.newChatButton.isHighlighted = false
        })
        
        messagesCollectionView.performBatchUpdates({
            let sections = IndexSet(integersIn: 0..<self.messagesCollectionView.messages.count)
            messagesCollectionView.messages.removeAll()
            messagesCollectionView.deleteSections(sections)
        })
        
        if UserDefaults.standard.bool(forKey: "HapticState") {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }
    
    
    //MARK: - Bottom Stack View
    
    func bottomStackViewSetup() {
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.axis = .horizontal
        bottomStackView.distribution = .fill
        bottomStackView.alignment = .bottom
        bottomStackView.spacing = 10
        bottomStackBottomConstraint = bottomStackView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -10)
        
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
        
        bottomStackView.addArrangedSubview(fieldView)
        NSLayoutConstraint.activate([
            fieldView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
    }
    
    
    //MARK: - Text Field View
    
    func textFieldTextSetup() {
        fieldText.delegate = self
        fieldText.text = ""
        fieldText.font = .systemFont(ofSize: 16, weight: .regular)
        fieldText.translatesAutoresizingMaskIntoConstraints = false
        fieldText.autocapitalizationType = .sentences
        fieldText.autocorrectionType = .yes
        fieldText.backgroundColor = .clear
        fieldText.textColor = .label
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
            self.fieldPlaceholder.transform = .identity
            self.fieldPlaceholderLeadingConstraint.isActive = false
            self.fieldPlaceholderCenterConstraint.isActive = true
            self.view.layoutIfNeeded()
        })
        
        checkFieldPlaceholder()
        checkDismissButton()
        checkEraseButton()
    }
    
    func resizeTextView(_ textView: UITextView) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let orientation = windowScene.interfaceOrientation
        
        if orientation.isLandscape {
            fieldTextHeightConstraint.constant = 46
            textView.isScrollEnabled = true
        } else {
            textView.isScrollEnabled = false
            let targetSize = CGSize(width: textView.bounds.width, height: .greatestFiniteMagnitude)
            let fittingHeight = textView.sizeThatFits(targetSize).height
            let maxHeight: CGFloat = 110
            
            fieldTextHeightConstraint.constant = min(fittingHeight, maxHeight)
            textView.isScrollEnabled = fittingHeight > maxHeight
        }
        let wasAtBottom = self.isUserAtBottom
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            self.messagesCollectionViewInsets()
            self.loadShadows()
            
            if wasAtBottom {
                DispatchQueue.main.async {
                    self.messagesCollectionView.layoutIfNeeded()
                    let contentHeight = self.messagesCollectionView.contentSize.height
                    let boundsHeight = self.messagesCollectionView.bounds.height
                    let insets = self.messagesCollectionView.adjustedContentInset
                    
                    let rawOffsetY = contentHeight + insets.bottom - boundsHeight
                    let minOffsetY = -insets.top
                    let finalOffsetY = max(rawOffsetY, minOffsetY)
                    
                    CATransaction.begin()
                    CATransaction.setCompletionBlock {
                        self.updateScrollDownButton()
                    }
                    UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
                        self.messagesCollectionView.setContentOffset(CGPoint(x: 0, y: finalOffsetY), animated: false)
                    })
                    CATransaction.commit()
                }
            }
        })
    }
    
    
    //MARK: - Field Placeholder
    
    func fieldPlaceholderSetup() {
        fieldPlaceholder.translatesAutoresizingMaskIntoConstraints = false
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
            self.collectionViewLayout()
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
            aiPickerView.alpha = 1
            aiPickerView.isHidden = false
            aiPickerContainer.isUserInteractionEnabled = true
            aiPickerShadowView.isUserInteractionEnabled = true
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.aiButton.transform = CGAffineTransform(rotationAngle: -.pi)
                self.aiPickerView.transform = CGAffineTransform(translationX: 0, y: 0)
            })
            
            UIView.animate(withDuration: 0.2,  delay: 0.2, options: .curveLinear, animations: {
                ShadowManager().applyShadow(to: self.aiPickerShadowView, opacity: 0.2, shadowRadius: 10, viewBounds: self.aiPickerShadowView.bounds.insetBy(dx: 0, dy: 5))
            })
        } else {
            //hide
            aiPickerContainer.isUserInteractionEnabled = false
            aiPickerShadowView.isUserInteractionEnabled = false
            
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
        aiPickerContainer.isUserInteractionEnabled = false
        view.insertSubview(aiPickerContainer, belowSubview: bottomStackView)
        
        aiPickerShadowView.translatesAutoresizingMaskIntoConstraints = false
        aiPickerShadowView.layer.cornerRadius = 25
        aiPickerShadowView.clipsToBounds = true
        aiPickerShadowView.isUserInteractionEnabled = false
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
        aiPickerContainer.isUserInteractionEnabled = false
        aiPickerShadowView.isUserInteractionEnabled = false
        
        messagesCollectionView.performBatchUpdates({
            let sections = IndexSet(integersIn: 0..<self.messagesCollectionView.messages.count)
            messagesCollectionView.messages.removeAll()
            messagesCollectionView.deleteSections(sections)
        })
        
        //center label
        AnimationManager().animateLabelWithBottomSlide(view: self.centerLabel, duration: 0.15)
        AnimationManager().animateLabelWithBottomSlide(view: self.centerDetailLabelButton, duration: 0.15)
        UIView.animate(withDuration: 0.1, delay: 0.05, options: .curveLinear, animations: {
            ShadowManager().applyShadow(to: self.labelStackView, opacity: 0, shadowRadius: 10, viewBounds: self.labelStackView.bounds)
        }, completion: { _ in
            self.centerLabel.text = button.title
            self.centerDetailLabelButton.refresh()
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
        sendButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(weight: .semibold), forImageIn: .normal)
        sendButton.tintColor = .white
        sendButton.backgroundColor = #colorLiteral(red: 0.02999999933, green: 0.02999999933, blue: 0.02999999933, alpha: 1)
        sendButton.layer.borderColor = #colorLiteral(red: 0.1999999881, green: 0.1999999881, blue: 0.1999999881, alpha: 1)
        sendButton.layer.borderWidth = 2
        sendButton.layer.cornerRadius = 25
        
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
        
        if RequestLimitManager.shared.canSendRequest() {
            let userIndex = messagesCollectionView.messages.count
            messagesCollectionView.messages.append(ChatMessage(role: "user", content: text))
            
            self.messagesCollectionView.performBatchUpdates({
                self.messagesCollectionView.insertSections([userIndex])
            })
            
            apiManager.userMessage = text
            apiManager.sendData()
            
            AnimationManager().animateTextWithTopSlide(label: fieldText, newText: "", duration: 0.15)
            fieldText.endEditing(true)
            UserDefaults.standard.set(false, forKey: "isEditing")
            
            apiManager.loadData { [weak self] successMessage, errorMessage in
                guard let self = self else { return }
               
                if let error = errorMessage {
                    self.userNotification(title: "Error", message: error)
                    self.loadingIndicator.stopAnimating()
                    self.sendButton.isUserInteractionEnabled = true
                    self.sendButton.setImage(UIImage(systemName: "arrow.up"), for: .normal)
                    return
                }
                
                guard let reply = successMessage else { return }
                RequestLimitManager.shared.registerRequest()
                AnimationManager().animateLabelWithBottomSlide(view: centerDetailLabelButton, duration: 0.15)
                UIView.animate(withDuration: 0, delay: 0.1, animations: {
                    self.centerDetailLabelButton.refresh()
                })
                
                let systemIndex = self.messagesCollectionView.messages.count
                self.messagesCollectionView.messages.append(ChatMessage(role: "assistant", content: " "))
                
                self.messagesCollectionView.performBatchUpdates({
                    self.messagesCollectionView.insertSections([systemIndex])
                }, completion: { _ in
                    self.animateTypingWords(reply, to: systemIndex)
                })
            }
            
            loadingIndicator.startAnimating()
            sendButton.isUserInteractionEnabled = false
            sendButton.setImage(UIImage(systemName: ""), for: .normal)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                self.loadingIndicator.stopAnimating()
                self.sendButton.isUserInteractionEnabled = true
                self.sendButton.setImage(UIImage(systemName: "arrow.up"), for: .normal)
                self.sendButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(weight: .semibold), forImageIn: .normal)
            })
            
        } else {
            AnimationManager().animateTextWithTopSlide(label: fieldText, newText: "", duration: 0.15)
            fieldText.endEditing(true)
            UserDefaults.standard.set(false, forKey: "isEditing")
            
            let limitAlert = UIAlertController(title: "Daily Limit", message: "You have exceeded your daily limit of requests.\n\nChange model or come back tomorrow!", preferredStyle: .alert)
            limitAlert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(limitAlert, animated: true, completion: nil)
        }
        
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
                self.collectionViewLayout()
            }, completion: { _ in
                self.messagesCollectionView.layoutIfNeeded()
                let contentHeight = self.messagesCollectionView.contentSize.height
                let boundsHeight = self.messagesCollectionView.bounds.height
                let insets = self.messagesCollectionView.adjustedContentInset
                
                let rawOffsetY = contentHeight + insets.bottom - boundsHeight
                let minOffsetY = -insets.top
                let finalOffsetY = max(rawOffsetY, minOffsetY)
                
                CATransaction.begin()
                CATransaction.setCompletionBlock {
                    self.updateScrollDownButton()
                }
                self.messagesCollectionView.setContentOffset(CGPoint(x: 0, y: finalOffsetY), animated: true)
                CATransaction.commit()
            })
        }
        
        AnimationManager().animateLabelWithTopSlide(view: fieldPlaceholder, duration: 0.15)
        if UserDefaults.standard.bool(forKey: "HapticState") {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }
    
    
    //MARK: - Scroll Down Button
    
    func scrollDownButtonSetup() {
        scrollDownButton.alpha = 0
        scrollDownButton.isUserInteractionEnabled = false
        view.addSubview(scrollDownButton)
        
        NSLayoutConstraint.activate([
            scrollDownButton.centerXAnchor.constraint(equalTo: sendButton.centerXAnchor),
            scrollDownButton.bottomAnchor.constraint(equalTo: sendButton.topAnchor, constant: -20),
            scrollDownButton.heightAnchor.constraint(equalToConstant: 42),
            scrollDownButton.widthAnchor.constraint(equalToConstant: 42)
        ])
        
        scrollDownButton.addTarget(self, action: #selector(scrollDownButtonTouchDown), for: [.touchDown, .touchDragEnter, .touchDownRepeat])
        scrollDownButton.addTarget(self, action: #selector(scrollDownButtonCancel), for: [.touchCancel, .touchDragExit, .touchUpOutside])
        scrollDownButton.addTarget(self, action: #selector(scrollDownButtonTouchUp), for: [.touchUpInside])
    }
    
    @objc func scrollDownButtonTouchDown() {
        scrollDownButton.tintColor = .pickedButtonGray
        scrollDownButton.backgroundColor = .systemGray3
    }
    
    @objc func scrollDownButtonCancel() {
        UIView.animate(withDuration: 0.1, animations: {
            self.scrollDownButton.tintColor = .systemGray2
            self.scrollDownButton.backgroundColor = .systemGray6
        })
    }
    
    @objc func scrollDownButtonTouchUp() {
        UIView.animate(withDuration: 0.1, animations: {
            self.scrollDownButton.tintColor = .systemGray2
            self.scrollDownButton.backgroundColor = .systemGray6
        })
        
        DispatchQueue.main.async {
            self.messagesCollectionView.layoutIfNeeded()
            let contentHeight = self.messagesCollectionView.contentSize.height
            let boundsHeight = self.messagesCollectionView.bounds.height
            let insets = self.messagesCollectionView.adjustedContentInset
            
            let rawOffsetY = contentHeight + insets.bottom - boundsHeight
            let minOffsetY = -insets.top
            let finalOffsetY = max(rawOffsetY, minOffsetY)
            
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                self.updateScrollDownButton()
            }
            self.messagesCollectionView.setContentOffset(CGPoint(x: 0, y: finalOffsetY), animated: true)
            CATransaction.commit()
        }
    }
    
    @objc func scrollDownButtonKeyboardAnimation(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let curveRaw = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let curve = UIView.AnimationOptions(rawValue: curveRaw << 16)
        
        self.messagesCollectionView.layoutIfNeeded()
        let contentHeight = self.messagesCollectionView.contentSize.height
        let boundsHeight = self.messagesCollectionView.bounds.height
        let insets = self.messagesCollectionView.adjustedContentInset
        
        let rawOffsetY = contentHeight + insets.bottom - boundsHeight
        let minOffsetY = -insets.top
        let finalOffsetY = max(rawOffsetY, minOffsetY)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.updateScrollDownButton()
        }
        UIView.animate(withDuration: duration, delay: 0, options: [curve], animations: {
            self.messagesCollectionView.setContentOffset(CGPoint(x: 0, y: finalOffsetY), animated: false)
        })
        CATransaction.commit()
    }
    
    
    //MARK: - Keyboard Handling
    
    func dismissKeyboardButtonSetup() {
        dismissKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        dismissKeyboardButton.imageView?.contentMode = .scaleAspectFit
        dismissKeyboardButton.setImage(UIImage(systemName: "keyboard.chevron.compact.down"), for: .normal)
        dismissKeyboardButton.tintColor = .systemGray2
        dismissKeyboardButton.backgroundColor = .systemGray6
        dismissKeyboardButton.layer.cornerRadius = 17.5
        dismissKeyboardButton.alpha = 0
        dismissKeyboardButton.transform = .init(scaleX: 0.1, y: 0.1)
        
        dismissKeyboardButton.addTarget(self, action: #selector(dismissKeyboardDown), for: [.touchDown, .touchDragEnter, .touchDownRepeat])
        dismissKeyboardButton.addTarget(self, action: #selector(dismissKeyboardCancel), for: [.touchCancel, .touchDragExit, .touchUpOutside])
        dismissKeyboardButton.addTarget(self, action: #selector(dismissKeyboardUp), for: [.touchUpInside])
        
        view.addSubview(dismissKeyboardButton)
        NSLayoutConstraint.activate([
            dismissKeyboardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dismissKeyboardButton.bottomAnchor.constraint(equalTo: fieldView.topAnchor, constant: -5),
            dismissKeyboardButton.heightAnchor.constraint(equalToConstant: 35),
            dismissKeyboardButton.widthAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    @objc func dismissKeyboardDown(_ sender: UIButton) {
        dismissKeyboardButton.tintColor = .pickedButtonGray
        dismissKeyboardButton.backgroundColor = .systemGray3
    }
    
    @objc func dismissKeyboardCancel(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            self.dismissKeyboardButton.tintColor = .systemGray2
            self.dismissKeyboardButton.backgroundColor = .systemGray6
        })
    }
    
    @objc func dismissKeyboardUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            self.dismissKeyboardButton.tintColor = .systemGray2
            self.dismissKeyboardButton.backgroundColor = .systemGray6
        })
        
        UserDefaults.standard.set(false, forKey: "isEditing")
        fieldText.endEditing(true)
    }
    
    @objc func checkDismissButton() {
        if fieldText.isEditing {
            UIView.animate(withDuration: 0.4, animations: {
                self.dismissKeyboardButton.transform = .init(scaleX: 1, y: 1)
                self.dismissKeyboardButton.alpha = 1
                self.dismissKeyboardButton.isUserInteractionEnabled = true
            })
        } else {
            UIView.animate(withDuration: 0.35, animations: {
                self.dismissKeyboardButton.transform = .init(scaleX: 0.1, y: 0.1)
                self.dismissKeyboardButton.alpha = 0
                self.dismissKeyboardButton.isUserInteractionEnabled = false
            })
        }
    }
    
    @objc func keyboardWillChangeFrame(_ notification: Notification) {
        messagesCollectionViewInsets()
        
        if isUserAtBottom {
            scrollDownButtonKeyboardAnimation(notification: notification)
        }
    }
    
    func keyboardSwipeDownAnimation() {
        guard fieldText.isEditing else { return }
        messagesCollectionViewInsets()
        
        var heightValue: CGFloat = 250
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let orientation = windowScene.interfaceOrientation
            if orientation.isPortrait {
                heightValue = 250
            } else {
                heightValue = 150
            }
        }
        
        let safeAreaBottom = view.safeAreaInsets.bottom
        let keyboardHeight = view.keyboardLayoutGuide.layoutFrame.height
        let activeHeight = max(0, keyboardHeight - safeAreaBottom)
        let progress = min(1, activeHeight / heightValue)
        
        dismissKeyboardButton.alpha = progress
        let scale = 0.5 + (0.5 * progress)
        dismissKeyboardButton.transform = CGAffineTransform(scaleX: scale, y: scale)
        dismissKeyboardButton.isUserInteractionEnabled = progress > 0.1
        
        if fieldText.text.isEmpty {
            let fieldCenter = fieldView.bounds.width / 2
            let currentLabelCenter = fieldPlaceholder.center.x
            let distanceToCenter = fieldCenter - currentLabelCenter
            let xOffset = distanceToCenter * (1 - progress)
            fieldPlaceholder.transform = CGAffineTransform(translationX: xOffset, y: 0)
        } else {
            fieldPlaceholder.transform = .identity
        }
    }
    
}


//MARK: - Extensions

extension UITextView {
    var isEditing: Bool {
        isFirstResponder
    }
}

extension UIScrollView {
    func isRoughlyAtBottom(tolerance: CGFloat = 30) -> Bool {
        return contentOffset.y + bounds.height >= contentSize.height - tolerance
    }
    
    func isVisuallyAtBottom(tolerance: CGFloat = 30) -> Bool {
        let visibleBottomY = contentOffset.y + bounds.height - adjustedContentInset.bottom
        return visibleBottomY >= contentSize.height - tolerance
    }
}

extension ViewController: UIScreenshotServiceDelegate {
    
    func screenshotService(_ screenshotService: UIScreenshotService, generatePDFRepresentationWithCompletion completionHandler: @escaping (Data?, Int, CGRect) -> Void) {
        let collectionView = self.messagesCollectionView
        let layout = collectionView.collectionViewLayout
        let contentSize = layout.collectionViewContentSize
        
        guard contentSize.height > 0 && !collectionView.messages.isEmpty else {
            completionHandler(nil, 0, .zero)
            return
        }
        
        let pdfBounds = CGRect(origin: .zero, size: contentSize)
        let pdfData = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(pdfData, pdfBounds, nil)
        UIGraphicsBeginPDFPageWithInfo(pdfBounds, nil)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let renderCell = MessageCollectionViewCell(frame: .zero)
        
        for section in 0..<collectionView.messages.count {
            let indexPath = IndexPath(item: 0, section: section)
            
            if let attributes = layout.layoutAttributesForItem(at: indexPath) {
                let message = collectionView.messages[section]
                renderCell.frame = attributes.frame
                renderCell.contentView.frame = renderCell.bounds
                
                renderCell.configure(with: message.content, role: message.role)
                renderCell.updateBubbleWidth(maxWidth: collectionView.bounds.width * 0.8)
                renderCell.layoutIfNeeded()
                
                context.saveGState()
                context.translateBy(x: attributes.frame.origin.x, y: attributes.frame.origin.y)
                renderCell.layer.render(in: context)
                context.restoreGState()
            }
        }
        
        UIGraphicsEndPDFContext()
        completionHandler(pdfData as Data, 0, pdfBounds)
    }
}
