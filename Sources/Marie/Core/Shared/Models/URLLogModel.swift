//
//  URLLogModel.swift
//  Marie
//
//  Created by Gabriel Olbrisch on 15/04/23.
//

import Foundation

struct URLLogModel {
    let id: UUID
    let time: Date = Date()
    let request: URLRequest
    let url: URL?
    let method: String?
    let requestHeaders: [String: String]?
    let responseHeaders: [String: String]?
    var status: HTTPStatusCode?
    var responseBody: String?
    var requestBody: String?
    var responseTime: Double?
}
