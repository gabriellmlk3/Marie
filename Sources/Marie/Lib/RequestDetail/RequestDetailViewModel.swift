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
    var responseBodyFormatted: String { get }
    var requestBodyFormatted: String { get }
    var requestHeadersFormatted: NSAttributedString? { get }
    func getFormattedText(with text: String) -> NSMutableAttributedString?
    func recallRequest()
}

protocol RequestDetailViewModelDelegate: AnyObject {
    func didLogChange()
}

final class RequestDetailViewModel: RequestDetailViewModelProtocol {
    
    var log: URLLogModel
    
    weak var delegate: RequestDetailViewModelDelegate?
    
    var isEditable: Bool = false
    
    lazy var responseBodyFormatted: String = {
        log.responseBody ?? ""
    }()
    
    lazy var requestBodyFormatted: String = {
        log.requestBody ?? ""
    }()
    
    lazy var requestHeadersFormatted: NSAttributedString? = {
        var text: String = ""
        log.requestHeaders?.forEach { (key: String, value: String) in
            text.append("\(key): \(value)\n")
        }
        return getFormattedText(with: text)
    }()
    
    init(log: URLLogModel) {
        self.log = log
        LogManager.shared.attach(self)
    }
    
    func getFormattedText(with text: String) -> NSMutableAttributedString? {
        var body: NSMutableAttributedString?
        
        if let data = (text).data(using: .utf8),
           let formattedJson = data.getFormattedText() {
            body = formattedJson
        } else {
            body = .init(string: text)
            body?.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: body?.length ?? 0))
        }
        
        return body
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
