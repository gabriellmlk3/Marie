//
//  RequestSheetView.swift
//  Marie
//
//  Created by Gabriel Olbrisch on 14/04/23.
//

import UIKit

final class RequestSheetView: UIView {
    
    let gapView: UIView = {
        let view = UIView()
        view.backgroundColor = .primaryTextColor.withAlphaComponent(0.2)
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let emptyViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .backgroudColor
        addSubview(tableView)
        addSubview(gapView)
        
        NSLayoutConstraint.activate([
            gapView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            gapView.widthAnchor.constraint(equalToConstant: 100),
            gapView.heightAnchor.constraint(equalToConstant: 5),
            gapView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
