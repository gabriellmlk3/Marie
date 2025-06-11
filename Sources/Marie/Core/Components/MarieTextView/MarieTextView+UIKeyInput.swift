//
//  MarieTextView+UIKeyInput.swift
//  MarieLib
//
//  Created by Gabriel Olbrisch de Souza on 10/06/25.
//

import UIKit

extension MarieTextView: UITextInput {
    
    override var canBecomeFirstResponder: Bool { true }
    
    func text(in range: UITextRange) -> String? {
        text
    }
    
    func replace(_ range: UITextRange, withText text: String) {
        //
    }
    
    var selectedTextRange: UITextRange? {
        get {
            nil
        }
        set(selectedTextRange) {
            //
        }
    }
    
    var markedTextRange: UITextRange? {
        nil
    }
    
    var markedTextStyle: [NSAttributedString.Key : Any]? {
        get {
            nil
        }
        set(markedTextStyle) {
            //
        }
    }
    
    func setMarkedText(_ markedText: String?, selectedRange: NSRange) {
        //
    }
    
    func unmarkText() {
        //
    }
    
    var beginningOfDocument: UITextPosition {
        MarieTextPosition()
    }
    
    var endOfDocument: UITextPosition {
        MarieTextPosition()
    }
    
    func textRange(from fromPosition: UITextPosition, to toPosition: UITextPosition) -> UITextRange? {
        nil
    }
    
    func position(from position: UITextPosition, offset: Int) -> UITextPosition? {
        nil
    }
    
    func position(from position: UITextPosition, in direction: UITextLayoutDirection, offset: Int) -> UITextPosition? {
        nil
    }
    
    func compare(_ position: UITextPosition, to other: UITextPosition) -> ComparisonResult {
        .orderedAscending
    }
    
    func offset(from: UITextPosition, to toPosition: UITextPosition) -> Int {
        0
    }
    
    var inputDelegate: (any UITextInputDelegate)? {
        get {
            nil
        }
        set(inputDelegate) {
            //
        }
    }
    
    var tokenizer: any UITextInputTokenizer {
        MarieTextInputTokenizer()
    }
    
    func position(within range: UITextRange, farthestIn direction: UITextLayoutDirection) -> UITextPosition? {
        nil
    }
    
    func characterRange(byExtending position: UITextPosition, in direction: UITextLayoutDirection) -> UITextRange? {
        nil
    }
    
    func baseWritingDirection(for position: UITextPosition, in direction: UITextStorageDirection) -> NSWritingDirection {
        .natural
    }
    
    func setBaseWritingDirection(_ writingDirection: NSWritingDirection, for range: UITextRange) {
        //
    }
    
    func firstRect(for range: UITextRange) -> CGRect {
        CGRect(x: 0, y: 0, width: 1, height: 10)
    }
    
    func caretRect(for position: UITextPosition) -> CGRect {
        CGRect(x: 0, y: 0, width: 1, height: 10)
    }
    
    func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        []
    }
    
    func closestPosition(to point: CGPoint) -> UITextPosition? {
        nil
    }
    
    func closestPosition(to point: CGPoint, within range: UITextRange) -> UITextPosition? {
        nil
    }
    
    func characterRange(at point: CGPoint) -> UITextRange? {
        nil
    }
    
    var hasText: Bool {
        !text.isEmpty
    }
    
    func insertText(_ text: String) {
        let index = self.text.index(self.text.startIndex, offsetBy: cursorPosition)
        self.text.insert(contentsOf: text, at: index)
        cursorPosition += text.count
    }
    
    func deleteBackward() {
        guard cursorPosition > 0 else { return }
        let index = text.index(text.startIndex, offsetBy: cursorPosition - 1)
        text.remove(at: index)
        cursorPosition -= 1
    }
    
}
