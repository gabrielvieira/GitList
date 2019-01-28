//
//  ListInteractor.swift
//  GitList
//
//  Created by Gabriel Vieira Figueiredo Tomaz on 28/01/19.
//  Copyright (c) 2019 Gabriel Vieira Figueiredo Tomaz. All rights reserved.

import UIKit

protocol ListBusinessLogic {
    func fetchRepositories()
}

protocol ListDataStore {
  //var name: String { get set }
}

class ListInteractor: ListBusinessLogic, ListDataStore {
 
    var presenter: ListPresentationLogic?
    var worker: ListWorker?

    func fetchRepositories() {
        
        let request = ListRepositoriesRequest(pageNumber: "1", query: "language:swift", sort: "stars")
        self.worker = ListWorker()
        
        self.worker?.fetchRepositories(request: request, completionHandler: { (result, error) in
            
            if error != nil {
                //handle error
            } else {
                
                if let list = result {
                    self.presenter?.presentRepositories(response: list)
                } else {
                    //handle error
                }
            }
        })
    }
}
