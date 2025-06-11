//
//  MarieTextView.swift
//  MarieLib
//
//  Created by Gabriel Olbrisch de Souza on 10/06/25.
//

import UIKit

final class MarieTextView: UIScrollView {
    
    var text: String = "" {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var cursorPosition: Int = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    init() {
        super.init(frame: .zero)
        isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        becomeFirstResponder()
    }
    
    override func draw(_ rect: CGRect) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .regular),
            .foregroundColor: UIColor.white
        ]
        
        // Desenha texto
        let nsText = NSString(string: text)
        nsText.draw(at: CGPoint(x: 10, y: 10), withAttributes: attributes)
        
        // Desenha cursor
        let cursorX = nsText.substring(to: cursorPosition).size(withAttributes: attributes).width
        let cursorRect = CGRect(x: 11 + cursorX, y: 11, width: 2, height: 14)
        
        UIColor.white.setFill()
        UIBezierPath(rect: cursorRect).fill()
    }
}
