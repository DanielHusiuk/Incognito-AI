//
//  AnimationManager.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 13.09.2025.
//

import UIKit

class AnimationManager {
    

    func animateTextWithTopSlide(label: UITextView, newText: String, duration: TimeInterval) {
        let transform = CGAffineTransform(translationX: 0, y: -12)
        UIView.animate(withDuration: duration, animations: {
            label.transform = transform
            label.alpha = 0
        }) { _ in
            label.text = newText
            label.transform = CGAffineTransform(translationX: 0, y: 12)
            UIView.animate(withDuration: duration) {
                label.transform = .identity
                label.alpha = 1
            }
        }
    }
    
    func animateTextWithBottomSlide(label: UITextView, newText: String, duration: TimeInterval) {
        let transform = CGAffineTransform(translationX: 0, y: 12)
        UIView.animate(withDuration: duration, animations: {
            label.transform = transform
            label.alpha = 0
        }) { _ in
            label.text = newText
            label.transform = CGAffineTransform(translationX: 0, y: -12)
            UIView.animate(withDuration: duration) {
                label.transform = .identity
                label.alpha = 1
            }
        }
    }
    
    //MARK: - UILabel
    
    func animateLabelWithTopSlide(label: UILabel, duration: TimeInterval) {
        let transform = CGAffineTransform(translationX: 0, y: -12)
        UIView.animate(withDuration: duration, animations: {
            label.transform = transform
            label.alpha = 0
        }) { _ in
            label.transform = CGAffineTransform(translationX: 0, y: 12)
            UIView.animate(withDuration: duration) {
                label.transform = .identity
                label.alpha = 1
            }
        }
    }
    
    func animateLabelWithBottomSlide(label: UILabel, duration: TimeInterval) {
        let transform = CGAffineTransform(translationX: 0, y: 12)
        UIView.animate(withDuration: duration, animations: {
            label.transform = transform
            label.alpha = 0
        }) { _ in
            label.transform = CGAffineTransform(translationX: 0, y: -12)
            UIView.animate(withDuration: duration) {
                label.transform = .identity
                label.alpha = 1
            }
        }
    }
    
}
