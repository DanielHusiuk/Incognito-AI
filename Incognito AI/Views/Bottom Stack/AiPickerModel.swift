//
//  AiPickerModel.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 29.09.2025.
//

import UIKit

struct Button {
    let id: Int
    var title: String
    var image: UIImage
    var action: () -> Void
}

struct AiPickerModel {
    var buttons: [Button] = [
        Button(id: 1,
               title: "Open AI",
               image: UIImage(named: "openai")!,
               action: { print("Open AI") } ),
        
        Button(id: 2,
               title: "Claude AI",
               image: UIImage(named: "claude")!,
               action: { print("Claude AI") } ),
        
        Button(id: 3,
               title: "Perplexity AI",
               image: UIImage(named: "perplexity")!,
               action: { print("Perplexity AI") } ),
        
        Button(id: 4,
               title: "Gemini AI",
               image: UIImage(named: "gemini")!,
               action: { print("Gemini AI") } ),
        
        Button(id: 5,
               title: "DeepSeek AI",
               image: UIImage(named: "deepseek")!,
               action: { print("DeepSeek AI") } ),
    ]
}

