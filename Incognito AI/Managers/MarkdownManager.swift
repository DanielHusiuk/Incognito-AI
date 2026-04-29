//
//  MarkdownManager.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 16.02.2026.
//

import UIKit
import MarkdownKit

struct MarkdownManager {
    
    static func format(text: String, isUser: Bool) -> NSAttributedString {
        let textColor: UIColor = .label
        let font = UIFont.systemFont(ofSize: 16)
        
        let parser = MarkdownParser(font: font, color: textColor)
        parser.code.textBackgroundColor = .systemGray6
        parser.code.color = .black
        parser.link.color = .systemBlue
        parser.quote.color = .systemGray
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.paragraphSpacing = 6
        
        let parsedString = parser.parse(text)
        let mutableString = NSMutableAttributedString(attributedString: parsedString)
        let fullRange = NSRange(location: 0, length: mutableString.length)
        mutableString.addAttribute(.paragraphStyle, value: paragraphStyle, range: fullRange)
        
        return mutableString
    }
}
