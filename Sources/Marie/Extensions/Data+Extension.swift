//
//  Data+Extension.swift
//  Marie
//
//  Created by Gabriel Olbrisch on 16/04/23.
//

import Foundation
import UIKit

private enum NonDestructiveJSON {
    static func pretty(_ text: String) -> String {
        var out = ""
        var indent = 0
        var inString = false
        var escape = false

        func writeIndent() { out += String(repeating: "  ", count: indent) } // 4 espaços

        for ch in text {
            if inString {
                out.append(ch)
                if escape { escape = false }
                else if ch == "\\" { escape = true }
                else if ch == "\"" { inString = false }
                continue
            }

            switch ch {
            case "\"":
                inString = true
                out.append(ch)

            case "{", "[":
                out.append(ch)
                out.append("\n")
                indent += 1
                writeIndent()

            case "}", "]":
                out.append("\n")
                indent = max(0, indent - 1)
                writeIndent()
                out.append(ch)

            case ",":
                out.append(ch)
                out.append("\n")
                writeIndent()

            case ":":
                out.append(": ")

            case " ", "\t", "\n", "\r":
                // ignora espaços/linhas fora de string
                break

            default:
                out.append(ch)
            }
        }
        return out
    }

    static func highlight(_ text: String,
                          font: UIFont,
                          key: UIColor,
                          string: UIColor,
                          number: UIColor,
                          boolNull: UIColor,
                          base: UIColor) -> NSMutableAttributedString {

        let attr = NSMutableAttributedString(string: text, attributes: [
            .font: font,
            .foregroundColor: base
        ])
        let full = NSRange(location: 0, length: attr.length)

        func apply(_ pattern: String, _ color: UIColor) {
            guard let rx = try? NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators]) else { return }
            for m in rx.matches(in: text, range: full) {
                attr.addAttribute(.foregroundColor, value: color, range: m.range)
            }
        }
        
        // números
        apply(#"(?<![A-Za-z0-9_\"\-])\-?\b\d+(?:\.\d+)?(?:[eE][\+\-]?\d+)?\b"#, number)

        // true | false | null
        apply(#"\b(?:true|false|null)\b"#, boolNull)

        // strings de valor (após :)
        apply(#""(?:[^"\\]|\\.)*""#, string)
        
        // chaves: "..." seguidas de :
        apply(#"\"([^\"\\]|\\.)*\"(?=\s*:)"#, key)

        return attr
    }
}


extension Data {
    
    /// Retorna um NSAttributedString formatado como JSON ou HTML, dependendo do conteúdo.
    func getFormattedText() -> NSMutableAttributedString? {
        // Tentativa de detectar HTML simples
        if let htmlString = String(data: self, encoding: .utf8),
           htmlString.trimmingCharacters(in: .whitespacesAndNewlines).hasPrefix("<") {
            return formatHTML(htmlString)
        }
        // Fallback para JSON
        return getFormattedJsonText()
    }
    
    /// Formata JSON em NSMutableAttributedString com cores e indentação
    private func getFormattedJsonText() -> NSMutableAttributedString? {
        guard let raw = String(data: self, encoding: .utf8) else { return nil }

        // Valida JSON, mas não usa o objeto para reformatar (só para saber se é válido)
        let isValidJSON: Bool = {
            do { _ = try JSONSerialization.jsonObject(with: self, options: [.fragmentsAllowed]); return true }
            catch { return false }
        }()

        let pretty = isValidJSON ? NonDestructiveJSON.pretty(raw) : raw
        return NonDestructiveJSON.highlight(
            pretty,
            font: .monospacedSystemFont(ofSize: UIFont.requestResponseTextViewfontSize, weight: .semibold),
            key: .JSONKeyColor,
            string: .JSONStringValueColor,
            number: .JSONNumbersValueColor,
            boolNull: .JSONOtherValuesColor,
            base: .white
        )
    }


    /// Converte HTML em NSMutableAttributedString preservando formatação básica
    private func formatHTML(_ html: String) -> NSMutableAttributedString? {
        guard let data = html.data(using: .utf8) else { return nil }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        do {
            let attributed = try NSMutableAttributedString(data: data,
                                                           options: options,
                                                           documentAttributes: nil)
            return attributed
        } catch {
            let errorString = NSMutableAttributedString(string: "Invalid HTML: \(error.localizedDescription)")
            errorString.addAttributes([.foregroundColor: UIColor.red], range: NSRange(location: 0, length: errorString.length))
            return errorString
        }
    }
    
    private func colored(_ text: String, _ color: UIColor) -> NSAttributedString {
        return NSAttributedString(
            string: text,
            attributes: [
                .foregroundColor: color,
                .font: UIFont.monospacedSystemFont(ofSize: UIFont.requestResponseTextViewfontSize, weight: .semibold)
            ]
        )
    }
    
    /// Retorna JSON formatado em Data (pretty-printed) ou string simples
    func getFormatedJSONData() -> Data? {
        do {
            let json = try JSONSerialization.jsonObject(with: self, options: .fragmentsAllowed)
            if JSONSerialization.isValidJSONObject(json) {
                return try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            } else {
                return "\(json)".data(using: .utf8)
            }
        } catch {
            print("Erro ao decodificar JSON")
            return nil
        }
    }
    
    init(reading input: InputStream) {
        self.init()
        input.open()
        
        let bufferSize = 1024
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        while input.hasBytesAvailable {
            let read = input.read(buffer, maxLength: bufferSize)
            if (read == 0) {
                break
            }
            self.append(buffer, count: read)
        }
        buffer.deallocate()
        
        input.close()
    }
}
