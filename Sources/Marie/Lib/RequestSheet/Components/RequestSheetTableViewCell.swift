//
//  RequestSheetTableViewCell.swift
//  Marie
//
//  Created by Gabriel Olbrisch on 14/04/23.
//

import UIKit

class RequestSheetTableViewCell: UITableViewCell {
    
    static let reuseId = String(describing: RequestSheetTableViewCell.self)
    
    private let statusView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let methodLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusCodeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let requestEndpointLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    private let requestRouteLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryTextColor
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .secondaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .primaryTextColor
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private let milisecondsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryTextColor
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        buildHierarchy()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(logModel: URLLogModel) {
        guard let status = logModel.status else { return }
        statusView.backgroundColor = status.color
        methodLabel.text = logModel.method
        statusCodeLabel.text = status.rawValue == 0 ? "-" : "\(status.rawValue)"
        requestEndpointLabel.text = logModel.url?.path.isEmpty ?? true ? " " : logModel.url?.path
        requestRouteLabel.text = logModel.url?.absoluteString
        
        status.rawValue == 0 ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        activityIndicator.isHidden = status.rawValue != 0
        
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 4
        if let number = logModel.responseTime,
            let formattedNumber = numberFormatter.string(from: NSNumber(value: Int(number > 999 ? (number / 1000) : number))) {
            milisecondsLabel.text = "\(formattedNumber)\(number > 999 ? "s" : "ms")"
        } else {
            milisecondsLabel.text = ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        timeLabel.text = dateFormatter.string(from: logModel.time)
    }
    
    private func buildHierarchy() {
        contentView.addSubview(statusView)
        contentView.addSubview(methodLabel)
        contentView.addSubview(statusCodeLabel)
        contentView.addSubview(requestEndpointLabel)
        contentView.addSubview(requestRouteLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(milisecondsLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            statusView.topAnchor.constraint(equalTo: contentView.topAnchor),
            statusView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            statusView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            statusView.widthAnchor.constraint(equalToConstant: 10),
            
            methodLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            methodLabel.leadingAnchor.constraint(equalTo: statusView.trailingAnchor, constant: 16),
            methodLabel.widthAnchor.constraint(equalToConstant: 90),
            
            requestRouteLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            requestRouteLabel.leadingAnchor.constraint(equalTo: methodLabel.trailingAnchor, constant: 20),
            requestRouteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            statusCodeLabel.topAnchor.constraint(greaterThanOrEqualTo: methodLabel.bottomAnchor),
            statusCodeLabel.leadingAnchor.constraint(equalTo: statusView.trailingAnchor, constant: 16),
            statusCodeLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),
            statusCodeLabel.trailingAnchor.constraint(equalTo: methodLabel.trailingAnchor),
            
            requestEndpointLabel.topAnchor.constraint(equalTo: requestRouteLabel.bottomAnchor, constant: 5),
            requestEndpointLabel.leadingAnchor.constraint(equalTo: methodLabel.trailingAnchor, constant: 20),
            requestEndpointLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            milisecondsLabel.topAnchor.constraint(equalTo: requestEndpointLabel.bottomAnchor, constant: 5),
            milisecondsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            milisecondsLabel.leadingAnchor.constraint(greaterThanOrEqualTo: statusCodeLabel.trailingAnchor, constant: 50),
            
            timeLabel.topAnchor.constraint(equalTo: requestEndpointLabel.bottomAnchor, constant: 5),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            timeLabel.leadingAnchor.constraint(equalTo: milisecondsLabel.trailingAnchor, constant: 10),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            activityIndicator.topAnchor.constraint(greaterThanOrEqualTo: methodLabel.bottomAnchor, constant: 10),
            activityIndicator.centerXAnchor.constraint(equalTo: statusCodeLabel.centerXAnchor),
        ])
    }
    
}
