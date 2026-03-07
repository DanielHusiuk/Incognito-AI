//
//  AnimatedBackgroundView.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 16.09.2025.
//

import SwiftUI

struct AnimatedBackgroundView: View {
    @AppStorage("buttonId") private var selectedButtonId: Int = 0
    private var aiPickerModel = AiPickerModel()
    
    var body: some View {
        AnimatedBackground(animationColors: aiPickerModel.buttons[selectedButtonId].backgroundColor)
            .ignoresSafeArea()
    }
}

private struct AnimatedBackground: View {
    var animationColors: [Color]
    
    @State private var colorIndex: Int = 0
    @State private var isTopVisible: Bool = true
    
    let colorTimer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    let opacityTimer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 0) {
            
            Rectangle()
                .fill(currentColor)
                .frame(height: 100)
                .blur(radius: 60)
                .scaleEffect(3)
                .opacity(isTopVisible ? 1.0 : 0.0)
            
            Spacer()
            
            Rectangle()
                .fill(currentColor)
                .frame(height: 100)
                .blur(radius: 60)
                .scaleEffect(3)
                .opacity(isTopVisible ? 0.0 : 1.0)
        }
        .animation(.easeInOut(duration: 1.0), value: animationColors)
        .onReceive(colorTimer) { _ in
            withAnimation(.easeInOut(duration: 5)) {
                colorIndex = (colorIndex + 1) % max(1, animationColors.count)
            }
        }
        .onReceive(opacityTimer) { _ in
            withAnimation(.easeInOut(duration: 1)) {
                isTopVisible.toggle()
            }
        }
    }
    
    var currentColor: Color {
        guard !animationColors.isEmpty else { return .clear }
        return animationColors[colorIndex]
    }
}
