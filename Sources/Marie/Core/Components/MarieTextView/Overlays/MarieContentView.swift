//
//  MarieContentView.swift
//  MarieLib
//
//  Created by Gabriel Olbrisch de Souza on 08/06/25.
//

import UIKit

final class MarieContentView: UIView {

    override class var layerClass: AnyClass {
        CATiledLayer.self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
        isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
