//
//  ListWorker.swift
//  GitList
//
//  Created by Gabriel Vieira Figueiredo Tomaz on 28/01/19.
//  Copyright (c) 2019 Gabriel Vieira Figueiredo Tomaz. All rights reserved.

import UIKit

class ListWorker {

    func fetchRepositories(request: ListRepositoriesRequest, completionHandler: @escaping (ListRepositoriesResponse?, APIClientError?) -> Void) {

        APIClient.request(request: request, decodingType: ListRepositoriesResponse.self) { (result, error) in
            
            completionHandler(result, error)
        }
    }
}
