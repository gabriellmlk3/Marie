//
//  String+Extension.swift
//  Marie
//
//  Created by Gabriel Olbrisch on 26/04/23.
//

import UIKit

extension String {
    
    func getFormattedHtml() -> NSMutableAttributedString? {
        let attributedString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        let firstRegexPattern = "<[a-zA-Z\\d]+(\\s+[a-zA-Z\\-]+\\s*=\\s*(\"[^\"]*\"|'[^']*'|[^\\s>]+))*\\s*\\/?>|<\\/[a-zA-Z\\d]+\\s*>"
        let secondRegexPattern = "(\"([a-zA-Z!@#$%ˆ&* -:;/'?~,_1234567890])+(=[a-zA-Z!@#$%ˆ&*-:;/'?~,_1234567890]+)*\")"
        let firstRegex = try? NSRegularExpression(pattern: firstRegexPattern)
        let secondRegex = try? NSRegularExpression(pattern: secondRegexPattern)
        
        let fullRange = NSRange(location: 0, length: self.utf16.count)
        
        if let firstMatches = firstRegex?.matches(in: self, options: [], range: fullRange),
            let secondMatches = secondRegex?.matches(in: self, options: [], range: fullRange) {
            for match in firstMatches {
                let tagRange = match.range(at: 0)
                
                let tagAttributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor:  UIColor(hex: "#ff0055"),
                    .font: UIFont.monospacedSystemFont(ofSize: UIFont.requestResponseTextViewfontSize, weight: .regular)
                ]
                
                attributedString.addAttributes(tagAttributes, range: tagRange)
            }
            
            for match in secondMatches {
                let stringRange = match.range(at: 0)
                
                let stringAttributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor:  UIColor.JSONStringValueColor,
                    .font: UIFont.monospacedSystemFont(ofSize: UIFont.requestResponseTextViewfontSize, weight: .regular)
                ]
                
                attributedString.addAttributes(stringAttributes, range: stringRange)
            }
        }
        
        return attributedString
    }
    
    func getFormattedText() -> NSMutableAttributedString? {
        var body: NSMutableAttributedString?
        
        if let data = (self).data(using: .utf8),
           let formattedJson = data.getFormattedText() {
            body = formattedJson
        } else {
            body = .init(string: self)
            body?.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: body?.length ?? 0))
        }
        
        return body
    }
    
}
