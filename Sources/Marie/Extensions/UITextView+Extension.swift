//
//  UITextView+Extension.swift
//  MarieLib
//
//  Created by Gabriel Olbrisch de Souza on 14/09/25.
//

import UIKit

extension UITextView {
    func textRange(fromNSRange range: NSRange) -> UITextRange? {
        guard let start = position(from: beginningOfDocument, offset: range.location),
              let end = position(from: start, offset: range.length) else { return nil }
        return textRange(from: start, to: end)
    }
}
