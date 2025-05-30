//
//  LogManager.swift
//  Marie
//
//  Created by Gabriel Olbrisch on 15/04/23.
//

import Foundation

class Observer {
    func update(log: URLLogModel?) {}
}

final class LogManager {
    
    static let shared: LogManager = .init()
    
    private var observers = [Observer]()
    
    var requestsLog: [URLLogModel] = []
    
    func log(model: URLLogModel) {
        requestsLog.insert(model, at: 0)
        ImpactController.shared.doTactilFeedback(.light)
        notify(with: model)
    }
    
    func update(model: URLLogModel) {
        guard let modelIndex = requestsLog.firstIndex(where: {  $0.id == model.id }) else { return }
        ImpactController.shared.doTactilFeedback(.light)
        ImpactController.shared.doTactilFeedback(.medium)
        ImpactController.shared.doTactilFeedback(.heavy)
        requestsLog[modelIndex] = model
        notify(with: model)
    }
    
    func notify(with log: URLLogModel?) {
        print("LogManager: observers Notified\n")
        observers.forEach({
            $0.update(log: log)
        })
    }
    
    func attach(_ observer: Observer) {
        guard !observers.contains(where: {$0 === observer}) else { return }
        observers.append(observer)
        print("LogManager: Attached an observer \(observer)\n")
    }
    
    func detach(_ observer: Observer) {
        if let idx = observers.firstIndex(where: { $0 === observer }) {
            observers.remove(at: idx)
            print("LogManager: Detached an observer \(observer)\n")
        }
    }
    
    func clean() {
        requestsLog.removeAll()
        notify(with: nil)
        print("LogManager: Logs has been cleaned\n")
    }
}
