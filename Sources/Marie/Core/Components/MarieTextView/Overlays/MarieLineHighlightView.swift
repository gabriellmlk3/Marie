//
//  MarieLineHighlightView.swift
//  MarieLib
//
//  Created by Gabriel Olbrisch de Souza on 08/06/25.
//

import UIKit

final class MarieLineHighlightView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        isOpaque = false
        isUserInteractionEnabled = false
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
