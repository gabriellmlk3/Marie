//
//  RequestDetailViewModel.swift
//  Marie
//
//  Created by Gabriel Olbrisch on 15/04/23.
//

import UIKit

protocol RequestDetailViewModelDelegate: AnyObject {
    func didLogChange()
}

final class RequestDetailViewModel: Observer {
    
    var log: URLLogModel
    
    weak var delegate: RequestDetailViewModelDelegate?
    
    lazy var responseBodyFormatted: NSAttributedString? = {
        getFormattedText(with: log.responseBody ?? "")
    }()
    
    lazy var requestBodyFormatted: NSAttributedString? = {
        getFormattedText(with: log.requestBody ?? "")
    }()
    
    lazy var requestHeadersFormatted: NSAttributedString? = {
        var text: String = ""
        log.headers?.forEach { (key: String, value: String) in
            text.append("\(key): \(value)\n")
        }
        return getFormattedText(with: text)
    }()
    
    init(log: URLLogModel) {
        self.log = log
        super.init()
        LogManager.shared.attach(self)
    }
    
    override func update(log: URLLogModel?) {
        DispatchQueue.main.async { [weak self] in
            if let log, self?.log.id == log.id {
                self?.log = log
                self?.delegate?.didLogChange()
            }
        }
    }
    
    func getFormattedText(with text: String) -> NSMutableAttributedString? {
        var body: NSMutableAttributedString?
        
        if let jsonData = (text).data(using: .utf8),
           let formattedJson = jsonData.getFormatedJSONData() {
            body = formattedJson.getFormattedJsonText()
        } else if let formatedHtml = text.getFormattedHtml() {
            body = formatedHtml
        } else {
            body = .init(string: text)
            body?.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: body?.length ?? 0))
        }
        
        return body
    }
}

