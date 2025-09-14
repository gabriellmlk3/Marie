//
//  JSONEditorTheme.swift
//  MarieLib
//
//  Created by Gabriel Olbrisch de Souza on 14/09/25.
//

import UIKit

public struct JSONEditorTheme {
    let background: UIColor
    let gutterBackground: UIColor
    let gutterSeparator: UIColor
    let gutterText: UIColor
    let text: UIColor
    let key: UIColor
    let string: UIColor
    let number: UIColor
    let boolNull: UIColor
    let punctuation: UIColor
    let errorBackground: UIColor

    public static let `default` = JSONEditorTheme(
        background: .black,
        gutterBackground: UIColor(white: 0.09, alpha: 1),
        gutterSeparator: UIColor.separator.withAlphaComponent(0.6),
        gutterText: .white.withAlphaComponent(0.5),
        text: UIColor.white,
        key: UIColor.systemBlue,
        string: UIColor.systemGreen,
        number: UIColor.systemOrange,
        boolNull: UIColor.systemPink,
        punctuation: UIColor.tertiaryLabel,
        errorBackground: UIColor.systemRed.withAlphaComponent(0.10)
    )
}
