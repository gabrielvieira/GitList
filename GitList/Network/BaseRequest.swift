//
//  BaseRequest.swift
//  GitList
//
//  Created by Gabriel Vieira Figueiredo Tomaz on 28/01/19.
//  Copyright © 2019 Gabriel Vieira Figueiredo Tomaz. All rights reserved.
//

import Foundation
import Alamofire

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
        
        guard let _url = URL.init(string: self.endpoint) else {
            throw BaseRequestError.invalidEndPoint
        }
        
        var urlRequest = URLRequest(url: _url)
        urlRequest.httpMethod = self.method.rawValue
        urlRequest.allHTTPHeaderFields = self.headers
        
        return try URLEncoding.methodDependent.encode(urlRequest, with: self.body)
    }
}

// MARK: Encode/decode helpers
class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
