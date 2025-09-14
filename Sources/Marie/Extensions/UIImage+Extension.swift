//
//  UIImage+Extension.swift
//  Marie
//
//  Created by Gabriel Olbrisch on 20/04/23.
//

import UIKit

extension UIImage {
    static var phonewavesIcon: UIImage {
        UIImage(named: "phonewaves", in: Bundle.module, compatibleWith: nil)
        ?? UIImage(named: "phonewavesPNG", in: Bundle.module, compatibleWith: nil)
        ?? UIImage()
    }
    
    static var repeatIcon: UIImage {
        UIImage(named: "repeat", in: Bundle.module, compatibleWith: nil)
        ?? UIImage(named: "repeatPNG", in: Bundle.module, compatibleWith: nil)
        ?? UIImage()
    }
    
    static var trashIcon: UIImage {
        UIImage(named: "trash", in: Bundle.module, compatibleWith: nil)
        ?? UIImage(named: "trashPNG", in: Bundle.module, compatibleWith: nil)
        ?? UIImage()
    }
    
    static var menuIcon: UIImage {
        UIImage(systemName: "list.bullet") ?? UIImage()
    }
    
    static var pencilIcon: UIImage {
        UIImage(systemName: "pencil") ?? UIImage()
    }
    
    static var widthLockIcon: UIImage {
        UIImage(systemName: "timeline.selection") ?? UIImage()
    }
    
    static var xMarkIcon: UIImage {
        UIImage(systemName: "xmark") ?? UIImage()
    }
}
