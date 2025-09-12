//
//  ViewController.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 11.09.2025.
//

import UIKit

class ViewController: UIViewController {
    
    let topStackView: UIStackView = .init(frame: .zero)
    let centerLabel: UILabel = .init(frame: .zero)
    let centerDetailLabelButton: UIButton = .init(frame: .zero)
    let settingsButton: UIButton = .init(frame: .zero)
    let newChatButton: UIButton = .init(frame: .zero)
    
    let bottomStackView: UIStackView = .init(frame: .zero)
    var bottomStackBottomConstraint: NSLayoutConstraint!
    let sendButton: UIButton = .init(frame: .zero)
    let aiButton: UIButton = .init(frame: .zero)
    
    let fieldView: UIView = .init(frame: .zero)
    let fieldText: UITextField = .init(frame: .zero)
    let dismissKeyboardButton: UIButton = .init(frame: .zero)
    let eraseButton: UIButton = .init(frame: .zero)
    
    let navigateToSettings = UINavigationController(rootViewController: SettingsViewController())
    let navigateToMessages = UINavigationController(rootViewController: MessagesViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(true, forKey: "HapticState")
        backgroundSetup()
        
        topStackViewSetup()
        centerLabelSetup()
        centerDetailLabelButtonSetup()
        
        settingsButtonSetup()
        newChatButtonSetup()
        
        bottomStackViewSetup()
        textFieldViewSetup()
        textFieldTextSetup()
        
        sendButtonSetup()
        aiButtonSetup()
        
        eraseButtonSetup()
        dismissKeyboardButtonSetup()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func backgroundSetup() {
        let imageView = UIImageView(image: UIImage(named: "background"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        self.view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        let blurEffect = UIBlurEffect(style: .systemThinMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.isUserInteractionEnabled = false
        view.addSubview(blurEffectView)
    }
    
    
    //MARK: - Top Buttons UI
    
    func topStackViewSetup() {
        topStackView.axis = .vertical
        topStackView.distribution = .fill
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(topStackView)
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            topStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func centerLabelSetup() {
        centerLabel.text = "Incognito AI"
        centerLabel.textColor = .white
        centerLabel.textAlignment = .center
        centerLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        centerLabel.translatesAutoresizingMaskIntoConstraints = false
        topStackView.addArrangedSubview(centerLabel)
    }
    
    func centerDetailLabelButtonSetup() {
        centerDetailLabelButton.translatesAutoresizingMaskIntoConstraints = false
        centerDetailLabelButton.setTitle("10 messages left", for: .normal)
        centerDetailLabelButton.setTitleColor(.systemGray, for: .normal)
        centerDetailLabelButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        centerDetailLabelButton.titleLabel?.textAlignment = .center
        centerDetailLabelButton.backgroundColor = .clear
        centerDetailLabelButton.layer.cornerRadius = 9
        
        centerDetailLabelButton.addTarget(self, action: #selector(centerDetailLabelButtonTouchDown), for: [.touchDown, .touchDragEnter, .touchDownRepeat])
        centerDetailLabelButton.addTarget(self, action: #selector(centerDetailLabelButtonTouchUp), for: [.touchUpInside, .touchDragExit, .touchCancel])
        
        topStackView.addArrangedSubview(centerDetailLabelButton)
        NSLayoutConstraint.activate([
            centerDetailLabelButton.widthAnchor.constraint(equalTo: centerDetailLabelButton.titleLabel!.widthAnchor, constant: 10),
            centerDetailLabelButton.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    @objc func centerDetailLabelButtonTouchDown() {
        centerDetailLabelButton.backgroundColor = .systemGray3
    }
    
    @objc func centerDetailLabelButtonTouchUp() {
        centerDetailLabelButton.backgroundColor = .clear
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        present(navigateToMessages, animated: true)
    }
    
    func settingsButtonSetup() {
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.imageView?.contentMode = .scaleAspectFit
        settingsButton.setImage(UIImage(systemName: "gear"), for: .normal)
        settingsButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .regular), forImageIn: .normal)
        settingsButton.tintColor = .white
        settingsButton.layer.cornerRadius = 25
        
        settingsButton.addTarget(self, action: #selector(settingsButtonTouchDown), for: [.touchDown, .touchDragEnter, .touchDownRepeat])
        settingsButton.addTarget(self, action: #selector(settingsButtonTouchUp), for: [.touchUpInside, .touchDragExit, .touchCancel])

        view.addSubview(settingsButton)
        NSLayoutConstraint.activate([
            settingsButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            settingsButton.heightAnchor.constraint(equalToConstant: 50),
            settingsButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func settingsButtonTouchDown() {
        settingsButton.tintColor = .white
        settingsButton.backgroundColor = .systemGray3
    }
    
    @objc func settingsButtonTouchUp() {
        settingsButton.tintColor = .white
        settingsButton.backgroundColor = nil
        present(navigateToSettings, animated: true)
    }
    
    func newChatButtonSetup() {
        newChatButton.translatesAutoresizingMaskIntoConstraints = false
        newChatButton.imageView?.contentMode = .scaleAspectFit
        newChatButton.setImage(UIImage(systemName: "plus.message"), for: .normal)
        newChatButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .regular), forImageIn: .normal)
        newChatButton.tintColor = .white
        newChatButton.layer.cornerRadius = 25

        newChatButton.addTarget(self, action: #selector(newChatButtonTouchDown), for: [.touchDown, .touchDragEnter, .touchDownRepeat])
        newChatButton.addTarget(self, action: #selector(newChatButtonTouchUp), for: [.touchUpInside, .touchDragExit, .touchCancel])
        
        view.addSubview(newChatButton)
        NSLayoutConstraint.activate([
            newChatButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            newChatButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            newChatButton.heightAnchor.constraint(equalToConstant: 50),
            newChatButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func newChatButtonTouchDown() {
        newChatButton.tintColor = .white
        newChatButton.backgroundColor = .systemGray3
    }
    
    @objc func newChatButtonTouchUp() {
        newChatButton.tintColor = .white
        newChatButton.backgroundColor = nil
        if UserDefaults.standard.bool(forKey: "HapticState") {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }
    
    
    //MARK: - Text Field UI
    
    func bottomStackViewSetup() {
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.axis = .horizontal
        bottomStackView.distribution = .fill
        bottomStackView.alignment = .fill
        bottomStackView.spacing = 10
        bottomStackBottomConstraint = bottomStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        
        view.addSubview(bottomStackView)
        NSLayoutConstraint.activate([
            bottomStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            bottomStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
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
        
        bottomStackView.addSubview(fieldView)
        NSLayoutConstraint.activate([
            fieldView.bottomAnchor.constraint(equalTo: bottomStackView.bottomAnchor, constant: -10),
            fieldView.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor, constant: 70),
            fieldView.trailingAnchor.constraint(equalTo: bottomStackView.trailingAnchor, constant: -70),
            fieldView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
    }
    
    func textFieldTextSetup() {
        fieldText.translatesAutoresizingMaskIntoConstraints = false
        fieldText.autocapitalizationType = .sentences
        fieldText.autocorrectionType = .yes
        fieldText.backgroundColor = .clear
        fieldText.textColor = .black
        fieldText.alpha = 0.9
        fieldText.font = .systemFont(ofSize: 16, weight: .medium)
        fieldText.attributedPlaceholder = NSAttributedString(
            string: "Ask AI anything",
            attributes: [
                .foregroundColor: UIColor.systemGray2
            ]
        )
        fieldText.addTarget(self, action: #selector(checkDismissButton), for: .allEditingEvents)
        fieldText.addTarget(self, action: #selector(checkEraseButton), for: .allEditingEvents)
        
        fieldView.addSubview(fieldText)
        NSLayoutConstraint.activate([
            fieldText.topAnchor.constraint(equalTo: fieldView.topAnchor, constant: 5),
            fieldText.bottomAnchor.constraint(equalTo: fieldView.bottomAnchor, constant: -5),
            fieldText.leadingAnchor.constraint(equalTo: fieldView.leadingAnchor, constant: 20),
            fieldText.trailingAnchor.constraint(equalTo: fieldView.trailingAnchor, constant: -20)
        ])
    }
    
    func eraseButtonSetup() {
        eraseButton.translatesAutoresizingMaskIntoConstraints = false
        eraseButton.imageView?.contentMode = .scaleAspectFit
        eraseButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        eraseButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(weight: .semibold), forImageIn: .normal)
        eraseButton.tintColor = .systemGray2
        eraseButton.alpha = 0
        eraseButton.addTarget(self, action: #selector(eraseText), for: .touchUpInside)
        
        bottomStackView.addSubview(eraseButton)
        NSLayoutConstraint.activate([
            eraseButton.trailingAnchor.constraint(equalTo: fieldView.trailingAnchor, constant: -12),
            eraseButton.centerYAnchor.constraint(equalTo: fieldView.centerYAnchor),
            eraseButton.heightAnchor.constraint(equalTo: fieldView.heightAnchor),
            eraseButton.widthAnchor.constraint(equalToConstant: 30)
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
        fieldText.text = ""
        UIView.animate(withDuration: 0.15, animations: {
            self.eraseButton.alpha = 0
        })
        if UserDefaults.standard.bool(forKey: "HapticState") {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }
    
    func sendButtonSetup() {
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.imageView?.contentMode = .scaleAspectFit
        sendButton.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        sendButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(weight: .semibold), forImageIn: .normal)
        sendButton.tintColor = .white
        sendButton.backgroundColor = .black
        sendButton.layer.borderColor = #colorLiteral(red: 0.1999999881, green: 0.1999999881, blue: 0.1999999881, alpha: 1)
        sendButton.layer.borderWidth = 2
        sendButton.layer.cornerRadius = 25
        sendButton.alpha = 0.9
        sendButton.addTarget(self, action: #selector(sendButtonTouchDown), for: [.touchDown, .touchDragEnter, .touchDownRepeat])
        sendButton.addTarget(self, action: #selector(sendButtonTouchUp), for: [.touchUpInside, .touchDragExit, .touchCancel])
        
        bottomStackView.addSubview(sendButton)
        NSLayoutConstraint.activate([
            sendButton.trailingAnchor.constraint(equalTo: bottomStackView.trailingAnchor, constant: -10),
            sendButton.bottomAnchor.constraint(equalTo: bottomStackView.bottomAnchor, constant: -10),
            sendButton.heightAnchor.constraint(equalToConstant: 50),
            sendButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func sendButtonTouchDown() {
        sendButton.backgroundColor = #colorLiteral(red: 0.1999999881, green: 0.1999999881, blue: 0.1999999881, alpha: 1)
        sendButton.layer.borderColor = #colorLiteral(red: 0.3000000119, green: 0.3000000119, blue: 0.3000000119, alpha: 1)
    }
    
    @objc func sendButtonTouchUp() {
        sendButton.backgroundColor = .black
        sendButton.layer.borderColor = #colorLiteral(red: 0.1999999881, green: 0.1999999881, blue: 0.1999999881, alpha: 1)
        print("send")
    }
    
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
        aiButton.addTarget(self, action: #selector(aiButtonTouchUp), for: [.touchUpInside, .touchDragExit, .touchCancel])
        
        bottomStackView.addSubview(aiButton)
        NSLayoutConstraint.activate([
            aiButton.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor, constant: 10),
            aiButton.bottomAnchor.constraint(equalTo: bottomStackView.bottomAnchor, constant: -10),
            aiButton.heightAnchor.constraint(equalToConstant: 50),
            aiButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func aiButtonTouchDown() {
        aiButton.tintColor = .white
        aiButton.backgroundColor = .systemGray3
        aiButton.layer.borderColor = UIColor.systemGray2.cgColor
    }
    
    @objc func aiButtonTouchUp() {
        aiButton.tintColor = .systemGray2
        aiButton.backgroundColor = .systemGray6
        aiButton.layer.borderColor = UIColor.systemGray5.cgColor
    }
    
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
            dismissKeyboardButton.topAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -50),
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
            })
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                self.dismissKeyboardButton.alpha = 0
            })
        }
    }
    
    //MARK: - Keyboard Handle
    
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
        
        let keyboardDuration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let keyboardCurve = UIView.AnimationCurve(rawValue: notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! Int)!
        
        if keyboardWillSHow {
            let safeAreaExists = (self.view?.window?.safeAreaInsets.bottom != 0)
            let bottomConstant: CGFloat = 10
            viewBottomConstraint.constant = -(keyboardHeight - (safeAreaExists ? 30 : -bottomConstant))
        } else {
            viewBottomConstraint.constant = -10
        }
        
        let animator = UIViewPropertyAnimator(duration: keyboardDuration, curve: keyboardCurve) {
            self.view.layoutIfNeeded()
        }
        
        animator.startAnimation()
    }
    
}

