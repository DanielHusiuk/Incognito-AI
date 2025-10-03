//
//  AnimatedBackgroundView.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 16.09.2025.
//

import SwiftUI

struct AnimatedBackgroundView: View {
    
    @State private var isShowAnimation = false
    @AppStorage("buttonId") private var selectedButtonId: Int = 0
    private var aiPickerModel = AiPickerModel()
    
    var body: some View {
        GeometryReader { proxy in
        }
        .ignoresSafeArea(edges: .bottom)
        .background(AnimatedBackground(animationColor: aiPickerModel.buttons[selectedButtonId].backgroundColor))
    }
}

private struct AnimatedBackground: View {
    var animationColor: [Color]
    @State private var phaseIndex: Int = 0
    @State private var topOpacity: Double = 1.0
    @State private var bottomOpacity: Double = 0.0
    
    var body: some View {
        VStack {
            if #available(iOS 17.0, *) {
                Rectangle()
                    .frame(height: 100)
                    .phaseAnimator(animationColor, content: { content, colorPhase in content
                            .overlay(colorPhase)
                            .blur(radius: 160)
                    }, animation: { _ in
                            .easeInOut(duration: 5)
                    })
                    .frame(maxHeight: .infinity, alignment: .top)
                    .ignoresSafeArea(.keyboard)
                    .opacity(topOpacity)
                    .animation(.easeInOut(duration: 1), value: topOpacity)
                
                Spacer()
                
                Rectangle()
                    .frame(height: 100)
                    .phaseAnimator(animationColor, content: { content, colorPhase in content
                            .overlay(colorPhase)
                            .blur(radius: 160)
                    }, animation: { _ in
                            .easeInOut(duration: 5)
                    })
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .ignoresSafeArea(.keyboard)
                    .opacity(bottomOpacity)
                    .animation(.easeInOut(duration: 1), value: bottomOpacity)
            } else {
                Rectangle()
                    .frame(height: 200)
                    .overlay(animationColor.first)
                    .blur(radius: 160)
                    .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .onAppear{
            startPhaseLoop()
        }
    }
    
    func startPhaseLoop() {
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 1), {
                if topOpacity == 1 {
                    topOpacity = 0
                    bottomOpacity = 1
                } else if topOpacity == 0 {
                    topOpacity = 1
                    bottomOpacity = 0
                }
            })
            phaseIndex = (phaseIndex + 1) % animationColor.count
        }
    }
    
}
