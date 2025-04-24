//
//  UIImage+Extension.swift
//  Marie
//
//  Created by Gabriel Olbrisch on 20/04/23.
//

import UIKit

extension UIImage {
    
    static var phonewavesIcon: UIImage = (.init(named: "phonewaves", in: Bundle.module, compatibleWith: nil) ?? .init(named: "phonewavesPNG", in: Bundle.module, compatibleWith: nil) ?? .init())
    static var repeatIcon: UIImage = (.init(named: "repeat", in: Bundle.module, compatibleWith: nil) ?? .init(named: "repeatPNG", in: Bundle.module, compatibleWith: nil)) ?? .init()
    static var trashIcon: UIImage = (.init(named: "trash", in: Bundle.module, compatibleWith: nil) ?? .init(named: "trashPNG", in: Bundle.module, compatibleWith: nil)) ?? .init()
    
}
