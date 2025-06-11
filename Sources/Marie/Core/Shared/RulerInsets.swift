//
//  RulerInsets.swift
//  MarieLib
//
//  Created by Gabriel Olbrisch de Souza on 08/06/25.
//

import Foundation

public struct RulerInsets: Equatable {
    public let leading: CGFloat
    public let trailing: CGFloat
    
    public init(leading: CGFloat = 0, trailing: CGFloat = 0) {
        self.leading = leading
        self.trailing = trailing
    }
}
