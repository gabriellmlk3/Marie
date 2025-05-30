//
//  MarieHTTPManager.swift
//  Marie
//
//  Created by Gabriel Olbrisch on 14/04/23.
//

import Foundation

public final class HTTPManager {
    
    public static let shared = HTTPManager()
    
    private let session: URLSession
    
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MarieCustomURLProtocol.self]
        session = URLSession(configuration: configuration)
    }
    
    public func get(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(NSError(domain: "HTTPManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data returned"])))
            }
        }
        task.resume()
    }
    
    public func post(url: URL, body: [String: Any], completion: @escaping (Result<Data, Error>) -> Void) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(NSError(domain: "HTTPManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data returned"])))
            }
        }
        task.resume()
    }
    
    public func recall(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(NSError(domain: "HTTPManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data returned"])))
            }
        }
        task.resume()
    }
    
}
