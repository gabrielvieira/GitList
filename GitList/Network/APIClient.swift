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
    case Other(NSError)
}

class BaseAPIClient {
    
    //custom session manager for further configurations
    private static var sessionManager: Alamofire.SessionManager  = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 4 // seconds
        configuration.timeoutIntervalForResource = 4
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    static func request<T:Codable>(url: URLRequestConvertible, ofType _: T.Type,_ completionHandler: @escaping (APIClientResponse<T>) -> Void)  {
        
        self.sessionManager.request(url).responseData(completionHandler: { response in
        
//        self.sessionManager.request(url).responseJSON(completionHandler: { response in
            
            switch response.result {
                
            case .failure(let error):
                let error_cast = APIClientError.Other(error as NSError)
                completionHandler( (nil,error_cast) )
                return
                
            case .success(let data):
            
                guard let obj = try? JSONDecoder().decode(T.self, from: data) else {
                    completionHandler((nil,.CouldNotDecodeJSON))
                    return
                }

                completionHandler((obj,nil))
                return
            }
        })
    }}
