//
//  JSONEditorView.swift
//  MarieLib
//
//  Created by Gabriel Olbrisch de Souza on 14/09/25.
//

import UIKit

public final class JSONEditorView: UIView, UITextViewDelegate {
    public let textView: UITextView = {
        let tv = UITextView()
        tv.autocorrectionType = .no
        tv.autocapitalizationType = .none
        tv.smartDashesType = .no
        tv.smartQuotesType = .no
        tv.smartInsertDeleteType = .no
        tv.spellCheckingType = .no
        tv.keyboardDismissMode = .interactive
        tv.alwaysBounceVertical = true
        tv.textContainer.lineBreakMode = .byWordWrapping
        tv.textContainer.lineFragmentPadding = 8
        tv.backgroundColor = .clear
        tv.isEditable = false
        return tv
    }()
    
    public var isLineWrapEnabled: Bool = true
    
    private let gutter = NumberedGutterView()
    private var theme: JSONEditorTheme
    private let font: UIFont
    private var debounce: DispatchWorkItem?
    
    public var gutterFontSize: CGFloat {
        get { gutter.fontSize }
        set {
            gutter.fontSize = newValue
            invalidateGutterWidth()
        }
    }

    public var gutterMinWidth: CGFloat = 36

    public init(theme: JSONEditorTheme = .default, font: UIFont = .monospacedSystemFont(ofSize: 14, weight: .regular)) {
        self.theme = theme
        self.font = font
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setup() {
        backgroundColor = theme.background
        
        gutter.textView = textView
        gutter.theme = theme

        addSubview(textView)
        addSubview(gutter)

        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        gutter.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            gutter.leadingAnchor.constraint(equalTo: leadingAnchor),
            gutter.topAnchor.constraint(equalTo: topAnchor),
            gutter.bottomAnchor.constraint(equalTo: bottomAnchor),
            gutter.widthAnchor.constraint(equalToConstant: gutterMinWidth),

            textView.leadingAnchor.constraint(equalTo: gutter.trailingAnchor),
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        textView.textContainerInset.left = 1
        textView.typingAttributes = [
            .font: font,
            .foregroundColor: theme.text
        ]
        textView.backgroundColor = theme.background
    }
    
    public func updateGutter() {
        gutter.setNeedsDisplay()
    }
    
    public func toggleLineWrap(preserveCaret: Bool = true) {
        isLineWrapEnabled.toggle()
        applyLineWrap(preserveCaret: preserveCaret)
    }
    
    private func applyLineWrap(preserveCaret: Bool) {
        let tv = textView
        let sel = tv.selectedRange

        // Ajusta paragraphStyle do texto e typingAttributes (evita que o estilo vença o container)
        let current = NSMutableAttributedString(attributedString: tv.attributedText ?? NSAttributedString(string: tv.text ?? ""))
        let full = NSRange(location: 0, length: current.length)
        
        tv.layoutManager.invalidateDisplay(forCharacterRange: full)
        tv.layoutManager.invalidateLayout(forCharacterRange: full, actualCharacterRange: nil)
        tv.layoutManager.ensureLayout(for: tv.textContainer)
        
        let ps = NSMutableParagraphStyle()
        ps.lineBreakMode = isLineWrapEnabled ? .byWordWrapping : .byClipping
        current.addAttribute(.paragraphStyle, value: ps, range: full)
        
         
        let used = tv.layoutManager.usedRect(for: tv.textContainer)
        tv.textContainer.size = CGSize(
            width: 10_000,
            height: used.height
        )
        
        if isLineWrapEnabled {
            tv.textContainer.widthTracksTextView = true
            tv.showsHorizontalScrollIndicator = false
            tv.alwaysBounceHorizontal = false
        } else {
            tv.textContainer.widthTracksTextView = false
            tv.showsHorizontalScrollIndicator = true
            tv.alwaysBounceHorizontal = true
            tv.isDirectionalLockEnabled = true
        }
        
        tv.attributedText = current
        tv.selectedRange = sel
        
        gutter.setNeedsDisplay()
    }


    // MARK: - API pública
    public func setText(_ json: String, highlight: Bool = true) {
        textView.attributedText = json.getFormattedText()
        invalidateGutterWidth()
        updateGutter()
    }

    public func getText() -> String { textView.text }

    // MARK: - Gutter width
    private func invalidateGutterWidth() {
        let lines = max(1, textView.text.components(separatedBy: "\n").count)
        let digits = max(2, Int(log10(Double(lines))) + 1)
        let sample = String(repeating: "8", count: digits) as NSString
        let size = sample.size(withAttributes: [.font: gutter.font])
        let width = max(gutterMinWidth, size.width + gutter.lineInset * 2)
        if let widthConstraint = gutter.constraints.first(where: { $0.firstAttribute == .width }) {
            widthConstraint.constant = width
            layoutIfNeeded()
        }
    }

    // MARK: - UITextViewDelegate / Scroll
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateGutter()
    }

    public func textViewDidChange(_ textView: UITextView) {
        debounce?.cancel()
        let item = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            let current = textView.text ?? ""
            let selected = textView.selectedRange
            DispatchQueue.main.async {
                // Evita pulo de caret
                textView.attributedText = current.getFormattedText()
                textView.selectedRange = selected
                self.invalidateGutterWidth()
                self.updateGutter()
            }
        }
        debounce = item
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08, execute: item)
    }
}
