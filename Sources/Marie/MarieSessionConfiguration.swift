//
//  MarieSessionConfiguration.swift
//  MarieLib
//
//  Created by Gabriel Olbrisch on 23/04/25.
//

import Foundation

public class MarieSessionConfiguration {
    public static func defaultUsing(_ sessionConfiguration: URLSessionConfiguration) -> URLSessionConfiguration {
        sessionConfiguration.protocolClasses?.insert(MarieCustomURLProtocol.self, at: 0)
        return sessionConfiguration
    }
}
