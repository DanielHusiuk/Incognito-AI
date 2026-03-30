//
//  RequestsButton.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 16.09.2025.
//

import UIKit

class RequestsButton: UIButton {

    let navigateToRequests = UINavigationController(rootViewController: RequestsViewController())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buttonSetup()
        refresh()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        buttonSetup()
        refresh()
    }
    
    func buttonSetup() {
        translatesAutoresizingMaskIntoConstraints = false
        setTitleColor(.lightText, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        self.titleLabel?.textAlignment = .center
        backgroundColor = .clear
        layer.cornerRadius = 9
        alpha = 0.8
        
        addTarget(self, action: #selector(requestsButtonTouchDown), for: [.touchDown, .touchDragEnter, .touchDownRepeat])
        addTarget(self, action: #selector(requestsButtonCancel), for: [.touchCancel, .touchDragExit, .touchUpOutside])
        addTarget(self, action: #selector(requestsButtonTouchUp), for: [.touchUpInside])
    }
    
    @objc func refresh() {
        let remainingRequests = RequestLimitManager.shared.remainingRequestsToday()
        
        if remainingRequests == 1 {
            setTitle("\(remainingRequests) request left for today", for: .normal)
        } else {
            setTitle("\(remainingRequests) requests left for today", for: .normal)
        }
    }
    
    @objc func requestsButtonTouchDown() {
        backgroundColor = .messagesButton
    }
    
    @objc func requestsButtonCancel() {
        UIView.animate(withDuration: 0.1, animations: {
            self.backgroundColor = .clear
        })
    }
    
    @objc func requestsButtonTouchUp() {
        UIView.animate(withDuration: 0.1, animations: {
            self.backgroundColor = .clear
        })
        
        if UserDefaults.standard.bool(forKey: "HapticState") {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
        UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
            .first?.rootViewController?
            .present(navigateToRequests, animated: true)
    }

}
