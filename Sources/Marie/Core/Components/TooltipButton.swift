//
//  TooltipButton.swift
//  MarieLib
//
//  Created by Gabriel Olbrisch de Souza on 06/06/25.
//

import UIKit

class TooltipButton: UIButton {
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.backgroundColor = .black.withAlphaComponent(0.7)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    private let tooltipLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var tooltipText: String = ""
    
    init(tooltip: String) {
        self.tooltipText = tooltip
        super.init(frame: .zero)
        setupTooltip()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTooltip()
        setupGesture()
    }
    
    private func setupTooltip() {
        tooltipLabel.text = tooltipText
    }
    
    private func setupGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        self.addGestureRecognizer(longPress)
    }
    
    private func positionContainer() {
        guard let superview = self.superview else { return }

        let buttonFrame = self.convert(self.bounds, to: superview)
        let tooltipWidth = containerView.frame.width
        let tooltipHeight = containerView.frame.height
        let superviewBounds = superview.bounds

        let spacing: CGFloat = 8

        // Cálculo horizontal (centro, mas respeitando limites)
        var tooltipX = buttonFrame.midX - tooltipWidth / 2
        let maxX = superviewBounds.width - 10
        let minX: CGFloat = 10

        if tooltipX < minX {
            tooltipX = minX
        } else if tooltipX + tooltipWidth > maxX {
            tooltipX = maxX - tooltipWidth
        }

        // Cálculo vertical (tenta cima, senão vai pra baixo)
        let spaceAbove = buttonFrame.minY
        let spaceBelow = superviewBounds.height - buttonFrame.maxY

        let showAbove = spaceAbove >= tooltipHeight + spacing

        let tooltipY: CGFloat
        if showAbove {
            tooltipY = buttonFrame.minY - tooltipHeight - spacing
        } else {
            tooltipY = buttonFrame.maxY + spacing
        }

        containerView.frame.origin = CGPoint(x: tooltipX, y: tooltipY)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let superview = self.superview {
            superview.addSubview(containerView)
            containerView.addSubview(tooltipLabel)
            let centerXConstrraint = containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            centerXConstrraint.priority = .defaultLow
            
            NSLayoutConstraint.activate([
                containerView.bottomAnchor.constraint(equalTo: self.topAnchor, constant: -15),
                centerXConstrraint,
                containerView.widthAnchor.constraint(lessThanOrEqualToConstant: 200),
                containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
                tooltipLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
                tooltipLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5),
                tooltipLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
                tooltipLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5)
            ])
        }
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            showTooltip()
        case .ended, .cancelled, .failed:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.hideTooltip()
            }
        default:
            break
        }
    }
    
    private func showTooltip() {
        positionContainer()
        UIView.animate(withDuration: 0.2) {
            self.tooltipLabel.alpha = 1
            self.containerView.alpha = 1
        }
    }
    
    private func hideTooltip() {
        UIView.animate(withDuration: 0.2) {
            self.tooltipLabel.alpha = 0
            self.containerView.alpha = 0
        }
    }
}
