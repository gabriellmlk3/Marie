//
//  MarieTextInputTokenizer.swift
//  MarieLib
//
//  Created by Gabriel Olbrisch de Souza on 10/06/25.
//

import UIKit

final class MarieTextInputTokenizer: NSObject, UITextInputTokenizer {
    func rangeEnclosingPosition(_ position: UITextPosition, with granularity: UITextGranularity, inDirection direction: UITextDirection) -> UITextRange? {
        nil
    }
    
    func isPosition(_ position: UITextPosition, atBoundary granularity: UITextGranularity, inDirection direction: UITextDirection) -> Bool {
        false
    }
    
    func position(from position: UITextPosition, toBoundary granularity: UITextGranularity, inDirection direction: UITextDirection) -> UITextPosition? {
        nil
    }
    
    func isPosition(_ position: UITextPosition, withinTextUnit granularity: UITextGranularity, inDirection direction: UITextDirection) -> Bool {
        false
    }

}
