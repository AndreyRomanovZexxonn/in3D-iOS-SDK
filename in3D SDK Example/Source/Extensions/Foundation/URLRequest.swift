//
//  URLRequest.swift
//  I3DRecorder
//
//  Created by Булат Якупов on 27.11.2020.
//  Copyright © 2020 Булат Якупов. All rights reserved.
//

import Foundation

enum RequestMethod: String {
    
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
    
}

enum RequestEncoding {
    
    case json
    case base
    
}

extension URLRequest {
    
    static func createRequest(method: RequestMethod,
                              url: URL,
                              parameters: [String: Any]?,
                              header: [String: String]?,
                              body: [String: Any]?,
                              encoding: RequestEncoding) throws -> URLRequest  {
        var url = url
        
        if let parameters = parameters {
            var urlComponents = URLComponents()
            urlComponents.scheme = url.scheme
            urlComponents.host = url.host
            urlComponents.path = url.path
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            
            url = urlComponents.url!
        }
        
        var request = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 30)
        request.httpMethod = method.rawValue
        
        if let header = header {
            for (key, value) in header {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let body = body {
            switch encoding {
            case .base:
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                
                var requestBodyComponents = URLComponents()
                requestBodyComponents.queryItems = body.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                request.httpBody = requestBodyComponents.query?.data(using: .utf8)
            case .json:
                let jsonData = try JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = jsonData
            }
        }
        
        return request
    }
    
}
