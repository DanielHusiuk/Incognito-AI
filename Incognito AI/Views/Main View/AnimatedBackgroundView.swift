//
//  AnimatedBackgroundView.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 16.09.2025.
//

import SwiftUI

let colorOpenAi:  [Color] = [Color(#colorLiteral(red: 0.2901960784, green: 0.6274509804, blue: 0.5058823529, alpha: 1)), Color(#colorLiteral(red: 0.4629276108, green: 1, blue: 0.8083280887, alpha: 1)), Color(#colorLiteral(red: 0.2901960784, green: 0.6274509804, blue: 0.5058823529, alpha: 1)), Color(#colorLiteral(red: 0.4629276108, green: 1, blue: 0.8083280887, alpha: 1))]
let colorClaude:  [Color] = [Color(#colorLiteral(red: 0.7568627451, green: 0.3725490196, blue: 0.2352941176, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.4973989637, blue: 0.3172358688, alpha: 1)), Color(#colorLiteral(red: 0.7568627451, green: 0.3725490196, blue: 0.2352941176, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.4973989637, blue: 0.3172358688, alpha: 1))]
let colorPerplex: [Color] = [Color(#colorLiteral(red: 0.07450980392, green: 0.2039215686, blue: 0.231372549, alpha: 1)), Color(#colorLiteral(red: 0.1254901961, green: 0.5019607843, blue: 0.5529411765, alpha: 1)), Color(#colorLiteral(red: 0.07450980392, green: 0.2039215686, blue: 0.231372549, alpha: 1)), Color(#colorLiteral(red: 0.1254901961, green: 0.5019607843, blue: 0.5529411765, alpha: 1))]
let colorGemini:  [Color] = [Color(#colorLiteral(red: 0.7524403038, green: 0.2176528094, blue: 0.1753449346, alpha: 1)), Color(#colorLiteral(red: 0.9843137255, green: 0.737254902, blue: 0.01960784314, alpha: 1)), Color(#colorLiteral(red: 0.2039215686, green: 0.6588235294, blue: 0.3254901961, alpha: 1)), Color(#colorLiteral(red: 0.2588235294, green: 0.5215686275, blue: 0.9568627451, alpha: 1))]
let colorDeepS:   [Color] = [Color(#colorLiteral(red: 0.337254902, green: 0.4039215686, blue: 0.9607843137, alpha: 1)), Color(#colorLiteral(red: 0.2023848712, green: 0.2449130144, blue: 0.5932173295, alpha: 1)), Color(#colorLiteral(red: 0.337254902, green: 0.4039215686, blue: 0.9607843137, alpha: 1)), Color(#colorLiteral(red: 0.2023848712, green: 0.2449130144, blue: 0.5932173295, alpha: 1))]

struct AnimatedBackgroundView: View {
    
    @State private var isShowAnimation = false
    var body: some View {
        GeometryReader { proxy in
        }
        .ignoresSafeArea(edges: .bottom)
        .background(AnimatedBackground())
    }
}

private struct AnimatedBackground: View {
    @State private var phaseIndex: Int = 0
    @State private var animationColor: [Color] = colorOpenAi
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
