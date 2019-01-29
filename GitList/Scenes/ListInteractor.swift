//
//  ListInteractor.swift
//  GitList
//
//  Created by Gabriel Vieira Figueiredo Tomaz on 28/01/19.
//  Copyright (c) 2019 Gabriel Vieira Figueiredo Tomaz. All rights reserved.

import UIKit

protocol ListBusinessLogic {
    func fetchRepositories(resetPage: Bool)
}

//protocol for inject properties on interactor
protocol ListDataStore {

}

class ListInteractor: ListBusinessLogic, ListDataStore {
 
    var presenter: ListPresentationLogic?
    var worker: ListWorker = ListWorker()
    private var currentPage: Int = 1
    private let serachQuery: String = "language:swift"

    func fetchRepositories(resetPage: Bool) {
        
        if resetPage {
            self.currentPage = 1
        }
        
        let request = ListRepositoriesRequest(page: self.currentPage, query: self.serachQuery, sort: .stars)
        self.worker.fetchRepositories(request: request, completionHandler: { (result, error) in
            
            if error != nil {
                //handle error
            } else {
                
                guard let _result = result else {
                    //handle error
                    return
                }
                
                let list = _result.items
                
                if self.currentPage == 1 {
                    self.presenter?.presentRepositories(list: list)
                } else {
                    
                }
                
                
                
                self.currentPage += 1
            }
        })
    }
}
