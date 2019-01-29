//
//  APIClient.swift
//  GitList
//
//  Created by Gabriel Vieira Figueiredo Tomaz on 28/01/19.
//  Copyright © 2019 Gabriel Vieira Figueiredo Tomaz. All rights reserved.
//

import Foundation
import Alamofire

typealias APIClientResponse<T:Codable> = (T?, APIClientError?)
typealias APIClientResponseArray<T:Codable> = ([T], APIClientError?)

enum APIClientError: Error {
    case CouldNotDecodeJSON
    case BadStatus(status: Int)
    case Other(Error?)
}

class APIClient {
    
    //custom session manager for further configurations
    private static var sessionManager: Alamofire.SessionManager  = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 4 // seconds
        configuration.timeoutIntervalForResource = 4
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    //request and generic parser 
    static func request<T:Decodable>(request: URLRequestConvertible, decodingType: T.Type,_ completionHandler: @escaping (APIClientResponse<T>) -> Void)  {
        
        self.sessionManager.request(request).responseData(completionHandler: { data in
            
            guard let HttpResponse = data.response else {
                completionHandler((nil, APIClientError.Other(data.error)))
                return
            }
        
            if HttpResponse.statusCode == 200 {
            
                switch data.result {
                    
                    case .success(let jsonData):
                        
                        guard let obj = try? JSONDecoder().decode(decodingType, from: jsonData) else {
                            completionHandler((nil,.CouldNotDecodeJSON))
                            return
                        }
                    
                        completionHandler((obj,nil))
                    
                    case .failure(let error):
                        
                        completionHandler((nil, APIClientError.Other(error)))
                }
            } else {
                completionHandler((nil, APIClientError.BadStatus(status: HttpResponse.statusCode)))
            }
        })
    }}
