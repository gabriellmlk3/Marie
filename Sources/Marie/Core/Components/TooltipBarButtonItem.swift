////
////  TooltipBarButtonItem.swift
////  MarieLib
////
////  Created by Gabriel Olbrisch de Souza on 06/06/25.
////
//
//
//import UIKit
//
//class TooltipBarButtonItem: UIBarButtonItem {
//    
//    private let containerView: UIView = {
//        let view = UIView()
//        view.layer.cornerRadius = 8
//        view.layer.masksToBounds = true
//        view.backgroundColor = .black.withAlphaComponent(0.7)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.alpha = 0
//        return view
//    }()
//    
//    private let tooltipLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 14)
//        label.textColor = .white
//        label.numberOfLines = 0
//        label.textAlignment = .center
//        label.alpha = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    init(tooltip: String, image: UIImage?, target: Any?, action: Selector) {
//        self.image = image
//        super.init()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func positionTooltipLaterally() {
//        guard let superview = self.superview else { return }
//        
//        let buttonFrame = 0
//        let tooltipWidth = containerView.frame.width
//        let tooltipHeight = containerView.frame.height
//        let superviewBounds = superview.bounds
//
//        let spacing: CGFloat = 8
//        
//        let spaceRight = superviewBounds.width - buttonFrame.maxX
//        let spaceLeft = buttonFrame.minX
//        
//        let showRight = spaceRight >= tooltipWidth + spacing
//        
//        let tooltipX: CGFloat
//        if showRight {
//            tooltipX = buttonFrame.maxX + spacing
//        } else {
//            tooltipX = buttonFrame.minX - tooltipWidth - spacing
//        }
//        
//        let tooltipY = buttonFrame.midY - tooltipHeight / 2
//        
//        containerView.frame.origin = CGPoint(x: tooltipX, y: tooltipY)
//    }
//
//    func showTooltip() {
//        positionTooltipLaterally()
//        
//        UIView.animate(withDuration: 0.2) {
//            self.containerView.alpha = 1
//            self.tooltipLabel.alpha = 1
//        }
//    }
//    
//    func hideTooltip() {
//        UIView.animate(withDuration: 0.2) {
//            self.containerView.alpha = 0
//            self.tooltipLabel.alpha = 0
//        }
//    }
//}
//
