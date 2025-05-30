//
//  CustomURLProtocol.swift
//  Marie
//
//  Created by Gabriel Olbrisch on 14/04/23.
//

import UIKit
import QuartzCore

open class MarieCustomURLProtocol: URLProtocol {
    
    open override class func canInit(with request: URLRequest) -> Bool {
        if URLProtocol.property(forKey: "Intercepted", in: request) != nil {
            return false
        }
        
        guard let scheme = request.url?.scheme else { return false }
        return scheme == "http" || scheme == "https"
    }
    
    open override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    open override func startLoading() {
        var logModel = URLLogModel(
            request: request,
            url: request.url,
            method: request.httpMethod,
            headers: request.allHTTPHeaderFields,
            status: .awaiting,
            responseBody: nil,
            requestBody: nil,
            responseTime: nil
        )

        if let body = request.httpBodyStream {
            logModel.requestBody = (String(data: Data(reading: body), encoding: .utf8) ?? "")
        } else {
            logModel.requestBody = "Empty body"
        }

        LogManager.shared.log(model: logModel)
        let startTime = CACurrentMediaTime()

        let newRequest = (request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
        URLProtocol.setProperty(true, forKey: "Intercepted", in: newRequest)

        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: newRequest as URLRequest) { data, response, error in
            let endTime = CACurrentMediaTime()
            logModel.responseTime = (endTime - startTime) * 1000

            if let httpResponse = response as? HTTPURLResponse {
                self.client?.urlProtocol(self, didReceive: httpResponse, cacheStoragePolicy: .notAllowed)
                logModel.status = HTTPStatusCode(rawValue: httpResponse.statusCode)
            }

            if let data {
                self.client?.urlProtocol(self, didLoad: data)
                logModel.responseBody = String(data: data, encoding: .utf8) ?? ""
            }

            if let error {
                self.client?.urlProtocol(self, didFailWithError: error)
                logModel.responseBody = error.localizedDescription
            } else {
                self.client?.urlProtocolDidFinishLoading(self)
            }

            LogManager.shared.update(model: logModel)
        }

        task.resume()
    }

    
    open override func stopLoading() { }
    
}
