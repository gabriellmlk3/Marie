//
//  Data+Extension.swift
//  Marie
//
//  Created by Gabriel Olbrisch on 16/04/23.
//

import Foundation
import UIKit

extension Data {
    
    func getFormattedJsonText() -> NSMutableAttributedString? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: self, options: [])
            let attributedString = NSMutableAttributedString()
            
            format(jsonObject, into: attributedString, indentation: 0)
            return attributedString
        } catch {
            let errorString = NSMutableAttributedString(string: "⚠️ Invalid JSON: \(error.localizedDescription)")
            errorString.addAttributes([.foregroundColor: UIColor.red], range: NSRange(location: 0, length: errorString.length))
            return errorString
        }
    }

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
                attrString.deleteCharacters(in: NSRange(location: attrString.length - 2, length: 1))
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
                    attrString.deleteCharacters(in: NSRange(location: attrString.length - 2, length: 1))
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
                .font: UIFont.systemFont(ofSize: UIFont.requestResponseTextViewfontSize, weight: .semibold)
            ]
        )
    }
    
    func getFormatedJSONData() -> Data? {
        do {
            let json = try JSONSerialization.jsonObject(with: self, options: .fragmentsAllowed)
            
            if JSONSerialization.isValidJSONObject(json) {
                return try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            } else {
                // Fragmento simples como string, número ou booleano
                return "\(json)".data(using: .utf8)
            }
        } catch {
            print("❌ Erro ao decodificar JSON: \(error)")
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
                break  // added
            }
            self.append(buffer, count: read)
        }
        buffer.deallocate()
        
        input.close()
    }
}
