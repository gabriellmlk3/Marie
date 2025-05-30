//
//  HTTPStatusCode.swift
//  Marie
//
//  Created by Gabriel Olbrisch on 15/04/23.
//

import UIKit

enum HTTPStatusCode: Int {
    case ok = 200
    case created = 201
    case accepted = 202
    case noContent = 204
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case requestTimeout = 408
    case conflict = 409
    case gone = 410
    case preconditionFailed = 412
    case payloadTooLarge = 413
    case uriTooLong = 414
    case unsupportedMediaType = 415
    case tooManyRequests = 429
    case internalServerError = 500
    case notImplemented = 501
    case badGateway = 502
    case serviceUnavailable = 503
    case gatewayTimeout = 504
    case awaiting = 0
    
    var color: UIColor {
        switch self {
        case .ok, .created, .accepted, .noContent:
            return .systemGreen
        case .badRequest, .unauthorized, .forbidden, .notFound, .methodNotAllowed, .requestTimeout, .conflict, .gone, .preconditionFailed, .payloadTooLarge, .uriTooLong, .unsupportedMediaType, .tooManyRequests:
            return .systemRed
        case .awaiting, .internalServerError, .notImplemented, .badGateway, .serviceUnavailable, .gatewayTimeout:
            return .systemYellow
        }
    }
}
