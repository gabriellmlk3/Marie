//
//  ImpactController.swift
//  Marie
//
//  Created by Gabriel Olbrisch on 17/04/23.
//

import UIKit

final class ImpactController {
    
    static let shared: ImpactController = .init()
    
    static let userDefaultsKey: String = String(describing: ImpactController.Type.self)
    
    static var isEnable: Bool = UserDefaults.standard.bool(forKey: userDefaultsKey) {
        didSet {
            UserDefaults.standard.setValue(isEnable, forKey: String(describing: ImpactController.Type.self))
        }
    }
    
    func doTactilFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        guard ImpactController.isEnable else { return }
        let feedbackGenerator = UIImpactFeedbackGenerator(style: style)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
    }
    
}
