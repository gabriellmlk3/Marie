//
//  MarieWindow.swift
//  Marie
//
//  Created by Gabriel Olbrisch on 15/04/23.
//

import UIKit

open class MarieWindow: UIWindow {
    
    public let requestSheetviewController: RequestSheetViewController = .init()
    
    @available(iOS 13.0, *)
    public override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        setupGesture()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupGesture()
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupGesture() {
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(_:)))
        longGesture.numberOfTapsRequired = 2
        longGesture.minimumPressDuration = 1
        addGestureRecognizer(longGesture)
    }
    
    @objc private func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
        if let rootViewController = UIApplication.getCurrentViewController(), gesture.state == .began {
            ImpactController.shared.doTactilFeedback(.light)
            let navigationController = UINavigationController(rootViewController: requestSheetviewController)
            navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController.navigationBar.shadowImage = UIImage()
            navigationController.navigationBar.barTintColor = nil
            navigationController.navigationBar.isTranslucent = true
            rootViewController.present(navigationController, animated: true, completion: nil)
        }
    }
}

fileprivate extension UIApplication {

    /// Retorna a `UIWindow` ativa de forma segura, compatível com todas as versões de iOS.
    static var activeKeyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared
                .connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first(where: { $0.activationState == .foregroundActive })?
                .windows
                .first(where: \.isKeyWindow)
        } else {
            return UIApplication.shared.keyWindow
        }
    }

    /// Retorna o `UIViewController` visível no momento, navegando por UINavigationController, UITabBarController e presentedViewController.
    static func getCurrentViewController(from base: UIViewController? = UIApplication.activeKeyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getCurrentViewController(from: nav.visibleViewController)
        }

        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getCurrentViewController(from: selected)
        }

        if let presented = base?.presentedViewController {
            return getCurrentViewController(from: presented)
        }

        return base
    }

    /// Retorna o `UIViewController` atual de forma assíncrona, tratando `UIAlertController` do tipo `.actionSheet`.
    static func getCurrentViewController(
        from base: UIViewController? = UIApplication.activeKeyWindow?.rootViewController,
        completion: @escaping (UIViewController) -> Void
    ) {
        guard let viewController = getCurrentViewController(from: base) else { return }

        if let alert = viewController as? UIAlertController, alert.preferredStyle == .actionSheet {
            alert.dismiss(animated: true) {
                if let newVC = getCurrentViewController(from: base) {
                    completion(newVC)
                }
            }
        } else {
            completion(viewController)
        }
    }
}



