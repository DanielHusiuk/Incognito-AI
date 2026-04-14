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
    var model: String
    var requestsPerDay: Int
    var backgroundColor: [Color]
    var tintColor: UIColor
    var action: (PickerButton) -> Void
}

struct AiPickerModel {
    var buttons: [PickerButton] = [
        PickerButton(id: 0,
                     title: "Open AI GPT-4o-mini",
                     image: UIImage(named: "openai")!,
                     model: "openai/gpt-4o-mini",
                     requestsPerDay: 150,
                     backgroundColor: [Color(#colorLiteral(red: 0.1542924345, green: 0.3336031437, blue: 0.2708898783, alpha: 1)), Color(#colorLiteral(red: 0.2901960784, green: 0.6274509804, blue: 0.5058823529, alpha: 1)), Color(#colorLiteral(red: 0.1542924345, green: 0.3336031437, blue: 0.2708898783, alpha: 1)), Color(#colorLiteral(red: 0.2901960784, green: 0.6274509804, blue: 0.5058823529, alpha: 1))],
                     tintColor: #colorLiteral(red: 0.2901960784, green: 0.6274509804, blue: 0.5058823529, alpha: 1),
                     action: { button in
                         didTapButton(button)
                     } ),
        
        PickerButton(id: 1,
                     title: "Open AI GPT-4.1-mini",
                     image: UIImage(named: "openai")!,
                     model: "openai/gpt-4.1-mini",
                     requestsPerDay: 150,
                     backgroundColor: [Color(#colorLiteral(red: 0.7568627451, green: 0.3725490196, blue: 0.2352941176, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.4980392157, blue: 0.3176470588, alpha: 1)), Color(#colorLiteral(red: 0.7568627451, green: 0.3725490196, blue: 0.2352941176, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.4973989637, blue: 0.3172358688, alpha: 1))],
                     tintColor: #colorLiteral(red: 0.7568627451, green: 0.3725490196, blue: 0.2352941176, alpha: 1),
                     action: { button in
                         didTapButton(button)
                     } ),
        
        PickerButton(id: 2,
                     title: "Meta Llama 4 Scout 17B",
                     image: UIImage(named: "meta")!,
                     model: "meta/Llama-4-Scout-17B-16E-Instruct",
                     requestsPerDay: 50,
                     backgroundColor: [Color(#colorLiteral(red: 0.3753327245, green: 0.1084319534, blue: 0.5240490846, alpha: 1)), Color(#colorLiteral(red: 0.5803921569, green: 0, blue: 0.8980392157, alpha: 1)), Color(#colorLiteral(red: 0.3753327245, green: 0.1084319534, blue: 0.5240490846, alpha: 1)), Color(#colorLiteral(red: 0.5294117647, green: 0.09803921569, blue: 0.862745098, alpha: 1))],
                     tintColor: #colorLiteral(red: 0.5790046453, green: 0, blue: 0.8964880109, alpha: 1),
                     action: { button in
                         didTapButton(button)
                     } ),
        
        PickerButton(id: 3,
                     title: "X Grok 3 Mini",
                     image: UIImage(named: "grok")!,
                     model: "xai/grok-3-mini",
                     requestsPerDay: 30,
                     backgroundColor: [Color(#colorLiteral(red: 0.662745098, green: 0, blue: 0, alpha: 1)), Color(#colorLiteral(red: 0.8588235294, green: 0, blue: 0, alpha: 1)), Color(#colorLiteral(red: 0.662745098, green: 0, blue: 0, alpha: 1)), Color(#colorLiteral(red: 0.8588235294, green: 0, blue: 0, alpha: 1))],
                     tintColor: #colorLiteral(red: 0.662745098, green: 0, blue: 0, alpha: 1),
                     action: { button in
                         didTapButton(button)
                     } ),
        
        PickerButton(id: 4,
                     title: "DeepSeek V3-0324",
                     image: UIImage(named: "deepseek")!,
                     model: "deepseek/DeepSeek-V3-0324",
                     requestsPerDay: 50,
                     backgroundColor: [Color(#colorLiteral(red: 0.2023848712, green: 0.2449130144, blue: 0.5932173295, alpha: 1)), Color(#colorLiteral(red: 0.337254902, green: 0.4039215686, blue: 0.9607843137, alpha: 1)), Color(#colorLiteral(red: 0.2023848712, green: 0.2449130144, blue: 0.5932173295, alpha: 1)), Color(#colorLiteral(red: 0.337254902, green: 0.4039215686, blue: 0.9607843137, alpha: 1))],
                     tintColor: #colorLiteral(red: 0.2023848712, green: 0.2449130144, blue: 0.5932173295, alpha: 1),
                     action: { button in
                         didTapButton(button)
                     } ),
    ]
}

func didTapButton(_ button: PickerButton) {
    UserDefaults.standard.set(button.id, forKey: "buttonId")
    UserDefaults.standard.set(button.title, forKey: "buttonTitle")
    UserDefaults.standard.set(button.model, forKey: "buttonModel")
    UserDefaults.standard.set(button.requestsPerDay, forKey: "buttonRequestsPerDay")
    UserDefaults.standard.setColor(button.tintColor, forKey: "buttonTintColor")
    NotificationCenter.default.post(name: Notification.Name("pickerButtonTapped"), object: button)
}
