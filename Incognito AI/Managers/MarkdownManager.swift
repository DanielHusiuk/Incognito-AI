//
//  MarkdownManager.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 16.02.2026.
//

import UIKit

struct MarkdownManager {
    
    static func format(text: String, isUser: Bool) -> NSAttributedString {
        let textColor: UIColor = .label
        
        do {
            var options = AttributedString.MarkdownParsingOptions()
            options.interpretedSyntax = .full
            options.failurePolicy = .returnPartiallyParsedIfPossible
            
            let attrString = try AttributedString(markdown: text, options: options)
            let nsAttrString = try NSAttributedString(attrString, including: \.uiKit)
            
            let mutableString = NSMutableAttributedString(attributedString: nsAttrString)
            let fullRange = NSRange(location: 0, length: mutableString.length)
            
            mutableString.addAttribute(.foregroundColor, value: textColor, range: fullRange)
            mutableString.enumerateAttribute(.font, in: fullRange, options: []) { value, range, _ in
                if let oldFont = value as? UIFont {
                    let newFont = UIFont(descriptor: oldFont.fontDescriptor, size: 16)
                    mutableString.addAttribute(.font, value: newFont, range: range)
                } else {
                    mutableString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: range)
                }
            }
            
            mutableString.enumerateAttribute(.paragraphStyle, in: fullRange, options: []) { value, range, _ in
                let style = (value as? NSParagraphStyle)?.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
                style.lineSpacing = 4
                style.paragraphSpacing = 4
                mutableString.addAttribute(.paragraphStyle, value: style, range: range)
            }
            
           return mutableString
        } catch {
            return fallback(text: text, color: textColor)
        }
    }
    
    private static func fallback(text: String, color: UIColor) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: color
        ]
        return NSAttributedString(string: text, attributes: attributes)
    }
}
