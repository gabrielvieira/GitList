//
//  BaseRequest.swift
//  GitList
//
//  Created by Gabriel Vieira Figueiredo Tomaz on 28/01/19.
//  Copyright © 2019 Gabriel Vieira Figueiredo Tomaz. All rights reserved.
//

import Foundation
import Alamofire

struct NetworkConstants {
    static let baseUrl = "https://api.github.com"
}

enum BaseRequestError: Error {
    case invalidEndPoint
}
//protocol for requests
public protocol BaseRequest: URLRequestConvertible {
    
    var endpoint: String { get }
    var method: HTTPMethod { get }
    var body: [String : Any] { get }
    var headers: [String : String] { get }
}
//default values for optional values, and default implementation of asURLRequest
extension BaseRequest {

    var headers: [String : String] {
        return [:]
    }
    
    var body: [String : Any] {
        return [:]
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let requestUrl = "\(NetworkConstants.baseUrl)\(self.endpoint)"
        
        guard let _url = URL.init(string: requestUrl) else {
            throw BaseRequestError.invalidEndPoint
        }
        
        var urlRequest = URLRequest(url: _url)
        urlRequest.httpMethod = self.method.rawValue
        urlRequest.allHTTPHeaderFields = self.headers
        return try URLEncoding.methodDependent.encode(urlRequest, with: self.body)
    }
}
