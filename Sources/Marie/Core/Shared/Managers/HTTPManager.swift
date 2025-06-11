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
    
    public func get(url: URL) async throws -> Data {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await session.data(for: request)
        try validate(response: response)
        return data
    }
    
    public func post(url: URL, body: [String: Any]) async throws -> Data {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        
        let (data, response) = try await session.data(for: request)
        try validate(response: response)
        return data
    }
    
    public func recall(request: URLRequest, id: UUID) async throws -> Data {
        let newRequest = (request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
        URLProtocol.setProperty(id, forKey: "requestToRecallId", in: newRequest)
        
        let (data, response) = try await session.data(for: newRequest as URLRequest)
        try validate(response: response)
        return data
    }
    
    private func validate(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw NSError(
                domain: "HTTPManager",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Invalid server response"]
            )
        }
    }
}
