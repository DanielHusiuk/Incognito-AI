//
//  ShadowManager.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 15.09.2025.
//

import UIKit

class ShadowManager {
    func applyShadow(to view: UIView, opacity: Float, shadowRadius: CGFloat, viewBounds: CGRect) {
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = opacity
        view.layer.shadowRadius = shadowRadius
        view.layer.shadowPath = UIBezierPath(roundedRect: viewBounds, cornerRadius: view.layer.cornerRadius).cgPath
  
    }
}
