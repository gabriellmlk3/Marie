//
//  Data+Extension.swift
//  Marie
//
//  Created by Gabriel Olbrisch on 16/04/23.
//

import Foundation
import UIKit

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
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: self, options: [])
            let attributedString = NSMutableAttributedString()
            format(jsonObject, into: attributedString, indentation: 0)
            return attributedString
        } catch {
            let errorString = NSMutableAttributedString(string: "Invalid JSON: \(error.localizedDescription)")
            errorString.addAttributes([.foregroundColor: UIColor.white], range: NSRange(location: 0, length: errorString.length))
            return errorString
        }
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
    
    // MARK: - JSON Pretty Print Utilities
    private func format(_ value: Any, into attrString: NSMutableAttributedString, indentation: Int) {
        let indent = String(repeating: "    ", count: indentation)
        let newline = "\n"
        
        switch value {
        case let dict as [String: Any]:
            attrString.append(colored("{\(newline)", .white))
            for (key, val) in dict {
                attrString.append(colored("\(indent)  \"\(key)\"", .JSONKeyColor))
                attrString.append(colored(": ", .white))
                format(val, into: attrString, indentation: indentation + 1)
                attrString.append(colored(",\(newline)", .white))
            }
            if attrString.string.hasSuffix(",\(newline)") {
                attrString.deleteCharacters(in: NSRange(location: attrString.length - newline.count - 1, length: 1))
            }
            attrString.append(colored("\(indent)}", .white))

        case let array as [Any]:
            if array.isEmpty {
                attrString.append(colored("[]", .white))
            } else {
                attrString.append(colored("[\(newline)", .white))
                for val in array {
                    attrString.append(colored("\(indent)  ", .white))
                    format(val, into: attrString, indentation: indentation + 1)
                    attrString.append(colored(",\(newline)", .white))
                }
                if attrString.string.hasSuffix(",\(newline)") {
                    attrString.deleteCharacters(in: NSRange(location: attrString.length - newline.count - 1, length: 1))
                }
                attrString.append(colored("\(indent)]", .white))
            }
            
        case let str as String:
            attrString.append(colored("\"\(str)\"", .JSONStringValueColor))
            
        case let num as NSNumber:
            attrString.append(colored("\(num)", .JSONNumbersValueColor))
            
        case is NSNull:
            attrString.append(colored("null", .JSONOtherValuesColor))
            
        default:
            attrString.append(colored("\"\(String(describing: value))\"", .JSONOtherValuesColor))
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
    
    private func getJSONDataString(_ data: Data) -> String {
        return String(decoding: data, as: UTF8.self)
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
