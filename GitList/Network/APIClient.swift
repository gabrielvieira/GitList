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

enum APIClientError: Error {
    case CouldNotDecodeJSON
    case BadStatus(status: Int)
    case Other(Error?)
}

class APIClient {

    //request and generic parser 
    static func request<T:Decodable>(request: URLRequestConvertible, decodingType: T.Type,_ completionHandler: @escaping (APIClientResponse<T>) -> Void)  {
        
       Alamofire.request(request).responseData(completionHandler: { data in
            
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
