//
//  RequestSheetViewModel.swift
//  Marie
//
//  Created by Gabriel Olbrisch on 14/04/23.
//

import UIKit

protocol RequestSheetViewModelProtocol {
    var delegate: RequestSheetViewModelDelegate? { get set }
}

protocol RequestSheetViewModelDelegate: AnyObject {
    func didLogChange()
}

final class RequestSheetViewModel: RequestSheetViewModelProtocol {
    
    weak var delegate: RequestSheetViewModelDelegate?
    
    init() {
        LogManager.shared.attach(self)
    }
}

extension RequestSheetViewModel: Observer {
    
    func update(log: URLLogModel?) {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.didLogChange()
        }
    }
    
}
