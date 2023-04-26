//
//  RequestDetailResponseView.swift
//  Marie
//
//  Created by Gabriel Olbrisch on 21/04/23.
//

import UIKit

final class RequestDetailResponseView: UIView {
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.backgroundColor = .black
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .backgroudColor
        addTextView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addTextView() {
        addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
}

