//
//  AiPickerModel.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 29.09.2025.
//

import UIKit
import SwiftUI

struct PickerButton {
    let id: Int
    var title: String
    var image: UIImage
    var token: String
    var backgroundColor: [Color]
    var action: (PickerButton) -> Void
}

struct AiPickerModel {
    var buttons: [PickerButton] = [
        PickerButton(id: 0,
                     title: "Open AI  gpt-5-mini",
                     image: UIImage(named: "openai")!,
                     token: "",
                     backgroundColor: [Color(#colorLiteral(red: 0.2901960784, green: 0.6274509804, blue: 0.5058823529, alpha: 1)), Color(#colorLiteral(red: 0.4629276108, green: 1, blue: 0.8083280887, alpha: 1)), Color(#colorLiteral(red: 0.2901960784, green: 0.6274509804, blue: 0.5058823529, alpha: 1)), Color(#colorLiteral(red: 0.4629276108, green: 1, blue: 0.8083280887, alpha: 1))],
                     action: { button in
                         didTapButton(button)
                     } ),
        
        PickerButton(id: 1,
                     title: "Claude 4o",
                     image: UIImage(named: "claude")!,
                     token: "",
                     backgroundColor: [Color(#colorLiteral(red: 0.7568627451, green: 0.3725490196, blue: 0.2352941176, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.4973989637, blue: 0.3172358688, alpha: 1)), Color(#colorLiteral(red: 0.7568627451, green: 0.3725490196, blue: 0.2352941176, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.4973989637, blue: 0.3172358688, alpha: 1))],
                     action: { button in
                         didTapButton(button)
                     } ),
        
        PickerButton(id: 2,
                     title: "Perplexity 2",
                     image: UIImage(named: "perplexity")!,
                     token: "",
                     backgroundColor: [Color(#colorLiteral(red: 0.07450980392, green: 0.2039215686, blue: 0.231372549, alpha: 1)), Color(#colorLiteral(red: 0.1254901961, green: 0.5019607843, blue: 0.5529411765, alpha: 1)), Color(#colorLiteral(red: 0.07450980392, green: 0.2039215686, blue: 0.231372549, alpha: 1)), Color(#colorLiteral(red: 0.1254901961, green: 0.5019607843, blue: 0.5529411765, alpha: 1))],
                     action: { button in
                         didTapButton(button)
                     } ),
        
        PickerButton(id: 3,
                     title: "Gemini 3",
                     image: UIImage(named: "gemini")!,
                     token: "",
                     backgroundColor: [Color(#colorLiteral(red: 0.7524403038, green: 0.2176528094, blue: 0.1753449346, alpha: 1)), Color(#colorLiteral(red: 0.9843137255, green: 0.737254902, blue: 0.01960784314, alpha: 1)), Color(#colorLiteral(red: 0.2039215686, green: 0.6588235294, blue: 0.3254901961, alpha: 1)), Color(#colorLiteral(red: 0.2588235294, green: 0.5215686275, blue: 0.9568627451, alpha: 1))],
                     action: { button in
                         didTapButton(button)
                     } ),
        
        PickerButton(id: 4,
                     title: "DeepSeek R1-0528",
                     image: UIImage(named: "deepseek")!,
                     token: "",
                     backgroundColor: [Color(#colorLiteral(red: 0.337254902, green: 0.4039215686, blue: 0.9607843137, alpha: 1)), Color(#colorLiteral(red: 0.2023848712, green: 0.2449130144, blue: 0.5932173295, alpha: 1)), Color(#colorLiteral(red: 0.337254902, green: 0.4039215686, blue: 0.9607843137, alpha: 1)), Color(#colorLiteral(red: 0.2023848712, green: 0.2449130144, blue: 0.5932173295, alpha: 1))],
                     action: { button in
                         didTapButton(button)
                     } ),
    ]
}

func didTapButton(_ button: PickerButton) {
    UserDefaults.standard.set(button.id, forKey: "buttonId")
    UserDefaults.standard.set(button.title, forKey: "buttonTitle")
    UserDefaults.standard.set(button.token, forKey: "buttonToken")
    NotificationCenter.default.post(name: Notification.Name("pickerButtonTapped"), object: button)
}
