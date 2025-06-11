//
//  RequestDetailResponseView.swift
//  Marie
//
//  Created by Gabriel Olbrisch on 21/04/23.
//

import UIKit

final class RequestDetailResponseView: UIView {
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.backgroundColor = .black
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .backgroudColor
        addTextView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addTextView() {
        addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
}

class CodeTextView: UIView {

    private let lineNumberView = LineNumberView()
    private let textView = UITextView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        textView.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        lineNumberView.translatesAutoresizingMaskIntoConstraints = false
        lineNumberView.backgroundColor = UIColor(white: 0.95, alpha: 1)

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(lineNumberView)
        scrollView.addSubview(textView)
        addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            lineNumberView.leadingAnchor.constraint(equalTo: leadingAnchor),
            lineNumberView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            lineNumberView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            lineNumberView.widthAnchor.constraint(equalToConstant: 40),
            textView.leadingAnchor.constraint(equalTo: lineNumberView.trailingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            textView.topAnchor.constraint(equalTo: lineNumberView.topAnchor)
        ])
    }

    func setJSON(_ json: String) {
        let formatted = formatJSON(json)
        textView.attributedText = syntaxHighlight(json: formatted)
    }

    private func formatJSON(_ json: String) -> String {
        guard let data = json.data(using: .utf8),
              let object = try? JSONSerialization.jsonObject(with: data),
              let prettyData = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyString = String(data: prettyData, encoding: .utf8) else {
            return json
        }
        return prettyString
    }

    private func syntaxHighlight(json: String) -> NSAttributedString {
        let attributed = NSMutableAttributedString(string: json)
        let fullRange = NSRange(location: 0, length: attributed.length)
        attributed.addAttribute(.font, value: UIFont.monospacedSystemFont(ofSize: 14, weight: .regular), range: fullRange)

        let stringColor = UIColor.systemRed
        let keyColor = UIColor.systemBlue
        let numberColor = UIColor.systemGreen
        let boolColor = UIColor.systemOrange
        let nullColor = UIColor.systemGray

        let patterns: [(String, UIColor)] = [
            ("\"(.*?)\"(?=\\s*:)", keyColor), // keys
            ("\".*?\"", stringColor),         // strings
            ("\\b(true|false)\\b", boolColor),// booleans
            ("\\bnull\\b", nullColor),        // null
            ("\\b[0-9]+(\\.[0-9]+)?\\b", numberColor) // numbers
        ]
        
        for (pattern, color) in patterns {
            let regex = try! NSRegularExpression(pattern: pattern)
            for match in regex.matches(in: json, range: fullRange) {
                attributed.addAttributes(
                    [
                     .foregroundColor: color],
                    range: match.range
                )
            }
        }

        return attributed
    }

    func updateLineNumbers() {
        // 1. Garante que o sistema já posicionou e dimensionou o textView
        layoutIfNeeded()
        
        // 2. Força o layout interno do layoutManager para o textContainer
        textView.layoutManager.ensureLayout(for: textView.textContainer)
        
        // 3. Pega o range de glifos que caem no textContainer
        let glyphRange = textView.layoutManager.glyphRange(for: textView.textContainer)
        
        // 4. Conta cada “line fragment” (linha visual)
        var lineCount = 0
        textView.layoutManager.enumerateLineFragments(forGlyphRange: glyphRange) { (_, _, _, _, _) in
            lineCount += 1
        }
        
        // 5. Atualiza o lineNumberView
        lineNumberView.setLineCount(lineCount)
    }

}


class LineNumberView: UIView {
    private var lineCount: Int = 0

    func setLineCount(_ count: Int) {
        self.lineCount = count
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.monospacedSystemFont(ofSize: 14, weight: .regular),
            .foregroundColor: UIColor.gray,
            .paragraphStyle: paragraphStyle
        ]

        let lineHeight = "A".size(withAttributes: attributes).height
        for i in 0..<lineCount {
            let y = CGFloat(i) * lineHeight
            let text = "\(i + 1)"
            text.draw(in: CGRect(x: 0, y: y, width: bounds.width - 5, height: lineHeight), withAttributes: attributes)
        }
    }
}
