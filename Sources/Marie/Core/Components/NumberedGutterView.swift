//
//  NumberedGutterView.swift
//  MarieLib
//
//  Created by Gabriel Olbrisch de Souza on 14/09/25.
//

import UIKit

final class NumberedGutterView: UIView {
    weak var textView: UITextView?
    var theme: JSONEditorTheme = .default { didSet { setNeedsDisplay() } }
    var lineInset: CGFloat = 4
    
    var font: UIFont = .monospacedSystemFont(ofSize: UIFont.requestResponseGutterfontSize, weight: .regular) {
        didSet { setNeedsDisplay() }
    }
    
    var fontSize: CGFloat = 14 {
        didSet {
            font = .monospacedSystemFont(ofSize: fontSize, weight: .regular)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = true
        contentMode = .redraw
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func draw(_ rect: CGRect) {
        guard let tv = textView else { return }
        let lm = tv.layoutManager
        let tc = tv.textContainer

        // Fundo do gutter
        theme.gutterBackground.setFill()
        UIBezierPath(rect: bounds).fill()

        // Separador
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.maxX - 0.5, y: bounds.minY))
        path.addLine(to: CGPoint(x: bounds.maxX - 0.5, y: bounds.maxY))
        theme.gutterSeparator.setStroke()
        path.lineWidth = 1
        path.stroke()

        // Calcular range visível
        let inset = tv.textContainerInset
        let visibleY = tv.contentOffset.y
        let visibleHeight = tv.bounds.height
        let visibleRect = CGRect(x: 0, y: visibleY, width: tc.size.width, height: visibleHeight)

        let glyphRange = lm.glyphRange(forBoundingRect: visibleRect, in: tc)

        // Encontrar número lógico da primeira linha (baseado em '\n', não em quebras de layout)
        let textNSString = tv.text as NSString
        let charRangeForFirstGlyph = lm.characterRange(forGlyphRange: NSRange(location: glyphRange.location, length: 0), actualGlyphRange: nil)
        let startLineNumber = max(1, textNSString.substring(to: charRangeForFirstGlyph.location).components(separatedBy: "\n").count)
        var logicalLine = startLineNumber

        // Atributos para os números
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .right
        let attrs: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: theme.gutterText,
            .paragraphStyle: paragraph
        ]

        var lastDrawnLine: Int = -1
        lm.enumerateLineFragments(forGlyphRange: glyphRange) { _, usedRect, _, glyphRange, _ in
            // Posição Y relativa ao textView
            let y = usedRect.minY + inset.top - visibleY

            // Descobre a "linha lógica" de cada fragmento com base no texto real
            let charRange = lm.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
            let logicalNumber = textNSString.substring(to: charRange.location).components(separatedBy: "\n").count

            // Desenha somente quando a linha lógica mudar (ignora quebras de layout dentro da mesma linha)
            if logicalNumber != lastDrawnLine {
                let numberString = "\(logicalNumber)" as NSString
                let size = numberString.size(withAttributes: attrs)
                let x = self.bounds.maxX - self.lineInset
                numberString.draw(at: CGPoint(x: x - size.width, y: y.rounded(.down)), withAttributes: attrs)
                lastDrawnLine = logicalNumber
            }
        }
    }
}
