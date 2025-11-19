//
//  MessageCollectionViewCell.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 04.11.2025.
//

import UIKit

final class MessageCollectionViewCell: UICollectionViewCell {
    
    let bubbleView = UIView()
    private let messageLabel = UITextView()
    
    private var leftConstraint: NSLayoutConstraint!
    private var rightConstraint: NSLayoutConstraint!
    var bubbleViewWidthConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        bubbleView.layer.cornerRadius = 16
        
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)
        
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.isEditable = false
        messageLabel.isScrollEnabled = false
        messageLabel.isSelectable = true
        messageLabel.backgroundColor = .clear
        
        messageLabel.textContainerInset = .zero
        messageLabel.textContainer.lineFragmentPadding = 0
        
        messageLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        messageLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -10),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 14),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -14)
        ])
        
        leftConstraint = bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14)
        rightConstraint = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14)
        
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        bubbleViewWidthConstraint = bubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: 0)
        bubbleViewWidthConstraint.isActive = true
        
    }
    
    func updateBubbleWidth(maxWidth: CGFloat) {
        bubbleViewWidthConstraint.constant = maxWidth
        ShadowManager().applyShadow(to: bubbleView, opacity: 0.2, shadowRadius: 5, viewBounds: bubbleView.bounds.insetBy(dx: 0, dy: 5))
        layoutIfNeeded()
    }
    
    func configure(with text: String, role: String) {
        messageLabel.text = text
        
        if role == "user" {
            leftConstraint.isActive = false
            rightConstraint.isActive = true
            bubbleView.backgroundColor = .userBubble
        } else {
            rightConstraint.isActive = false
            leftConstraint.isActive = true
            bubbleView.backgroundColor = .systemBubble
        }
    }
}
