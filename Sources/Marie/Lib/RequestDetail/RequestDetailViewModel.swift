//
//  RequestDetailViewModel.swift
//  Marie
//
//  Created by Gabriel Olbrisch on 15/04/23.
//

import UIKit

protocol RequestDetailViewModelProtocol: Observer {
    var log: URLLogModel { get }
    var isEditable: Bool { get set }
    var delegate: RequestDetailViewModelDelegate? { get set }
    var responseBodyFormatted: NSMutableAttributedString? { get }
    var requestBodyFormatted: NSMutableAttributedString? { get }
    var requestHeadersFormatted: NSAttributedString? { get }
    func recallRequest()
}

protocol RequestDetailViewModelDelegate: AnyObject {
    func didLogChange()
}

final class RequestDetailViewModel: RequestDetailViewModelProtocol {
    
    var log: URLLogModel
    
    weak var delegate: RequestDetailViewModelDelegate?
    
    var isEditable: Bool = false
    
    lazy var responseBodyFormatted: NSMutableAttributedString? = {
        log.responseBody?.getFormattedText()
    }()
    
    lazy var requestBodyFormatted: NSMutableAttributedString? = {
        log.requestBody?.getFormattedText()
    }()
    
    lazy var requestHeadersFormatted: NSAttributedString? = {
        var text: String = ""
        log.requestHeaders?.forEach { (key: String, value: String) in
            text.append("\(key): \(value)\n")
        }
        return text.getFormattedText()
    }()
    
    init(log: URLLogModel) {
        self.log = log
        LogManager.shared.attach(self)
    }
    
    func recallRequest() {
        guard let log = LogManager.shared.requestsLog.first else { return }
        var newRequest = log.request
        
        Task {
            do {
                try await HTTPManager.shared.recall(request: log.request, id: log.id)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension RequestDetailViewModel: Observer {
    
    func update(log: URLLogModel?) {
        DispatchQueue.main.async { [weak self] in
            if let log, self?.log.id == log.id {
                self?.log = log
                self?.delegate?.didLogChange()
            }
        }
    }
    
}
