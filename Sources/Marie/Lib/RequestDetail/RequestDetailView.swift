//
//  RequestDetailView.swift
//  Marie
//
//  Created by Gabriel Olbrisch on 15/04/23.
//

import UIKit

final class RequestDetailView: UIView {
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let methodLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusCodeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .secondaryTextColor
        label.text = "Status: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let codeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let requestRouteLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .secondaryTextColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lockWidthButton: TooltipButton = {
        let button = TooltipButton(tooltip: "Lock width")
        button.setImage(.widthLockIcon, for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityLabel = "Lock width"
        button.accessibilityHint = "Lock width of the request body json visualizer."
        return button
    }()
    
    let segmentedControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Request", "Response"])
        segmentControl.backgroundColor = .backgroudColor
        segmentControl.tintColor = .primaryTextColor
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.selectedSegmentIndex = 1
        segmentControl.layer.maskedCorners = .init()
        return segmentControl
    }()
    
    let responseView: MarieTextView = {
        let view = MarieTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.isVerticallyResizable = true
//        view.selectedLineHighlightColor = .backgroudColor.withAlphaComponent(0.1)
//        view.gutterView?.backgroundColor = .backgroudColor
//        view.gutterView?.tintColor = .white
//        view.gutterView?.selectedLineHighlightColor = .secondaryTextColor
//        view.gutterView?.selectedLineTextColor = .backgroudColor
//        view.font = UIFont.monospacedSystemFont(ofSize: 0, weight: .regular)
        view.backgroundColor = .black
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .backgroudColor
        addSegmentedControl()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(with log: URLLogModel) {
        methodLabel.text = log.method ?? ""
        codeLabel.text = log.status?.rawValue == 0 ? "-" : "\(log.status?.rawValue ?? 0)"
        requestRouteLabel.text = "Route: \(log.url?.absoluteString ?? "")"
        codeLabel.textColor = log.status?.color
    }
    
    func toggleTextViewsVisibility() {
        UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations: {
            
        }, completion: nil)
    }
    
    func setJSON(_ string: String) {
//        responseView.text = string
        responseView.sizeToFit()
    }
    
    func clear() {
//        responseView.attributedText = nil
    }
    
    func toogleWidthTracksTextView() {
//        responseView.widthTracksTextView.toggle()
//        lockWidthButton.tintColor = responseView.widthTracksTextView ? .primaryTextColor : .gray
    }
    
    private func addSegmentedControl() {
        addSubview(methodLabel)
        addSubview(statusCodeLabel)
        addSubview(codeLabel)
        addSubview(requestRouteLabel)
        addSubview(lockWidthButton)
        addSubview(segmentedControl)
        addSubview(responseView)
        
        NSLayoutConstraint.activate([
            methodLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            methodLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            methodLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            statusCodeLabel.topAnchor.constraint(equalTo: methodLabel.bottomAnchor, constant: 10),
            statusCodeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            codeLabel.centerYAnchor.constraint(equalTo: statusCodeLabel.centerYAnchor),
            codeLabel.leadingAnchor.constraint(equalTo: statusCodeLabel.trailingAnchor, constant: 5),
            codeLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),
            
            requestRouteLabel.topAnchor.constraint(equalTo: statusCodeLabel.bottomAnchor, constant: 10),
            requestRouteLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            lockWidthButton.leadingAnchor.constraint(greaterThanOrEqualTo: requestRouteLabel.trailingAnchor, constant: 10),
            lockWidthButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            lockWidthButton.centerYAnchor.constraint(equalTo: requestRouteLabel.centerYAnchor),
            
            segmentedControl.topAnchor.constraint(equalTo: requestRouteLabel.bottomAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 30),
            
            responseView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            responseView.leadingAnchor.constraint(equalTo: leadingAnchor),
            responseView.trailingAnchor.constraint(equalTo: trailingAnchor),
            responseView.bottomAnchor.constraint(equalTo: bottomAnchor),
            responseView.widthAnchor.constraint(equalToConstant: bounds.size.width),
        ])
    }
    
}
