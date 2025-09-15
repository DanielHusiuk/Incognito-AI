//
//  BlurView.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 14.09.2025.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    var removeAllFilters: Bool = false
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        if let backdropLayer = uiView.layer.sublayers?.first {
            if removeAllFilters {
                backdropLayer.filters = []
            } else {
                backdropLayer.filters?.removeAll(where: { filter in String(describing: filter) != "gaussianBlur"})
            }
        }
    }
}

#Preview {
    BlurView()
}
