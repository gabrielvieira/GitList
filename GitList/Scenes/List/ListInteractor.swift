//
//  ListInteractor.swift
//  GitList
//
//  Created by Gabriel Vieira Figueiredo Tomaz on 28/01/19.
//  Copyright (c) 2019 Gabriel Vieira Figueiredo Tomaz. All rights reserved.

import UIKit

protocol ListBusinessLogic {
    func fetchRepositories(resetPage: Bool)
    func openRepoPage(_ url: String)
}

//protocol for inject properties on interactor
protocol ListDataStore {

}

class ListInteractor: ListBusinessLogic, ListDataStore {
 
    var presenter: ListPresentationLogic?
    var worker: ListWorker = ListWorker()
    private var currentPage: Int = 1
    private let serachQuery: String = "language:swift"
    private let genericError: String = "Ocorreu um erro"

    func fetchRepositories(resetPage: Bool) {
        
        if resetPage {
            self.currentPage = 1
        }
        
        let request = ListRepositoriesRequest(page: self.currentPage, query: self.serachQuery, sort: .stars)
        self.worker.fetchRepositories(request: request, completionHandler: { (result, error) in
        
            if let apiError = error {
                //more error handlers need to be addded, but was prepared for
                switch apiError {
                    
                case .CouldNotDecodeJSON:
                    self.presenter?.presentError(error: self.genericError)
                case .BadStatus(let status):
                    //error code for repository limit
                    if status == 422 {
                        self.presenter?.presentError(error: "Não há mais repositórios")
                    } else {
                        self.presenter?.presentError(error: self.genericError)
                    }
                case .Other( let error ):
                    self.presenter?.presentError(error: error?.localizedDescription ?? self.genericError)
                }
                
            } else {
                
                guard let _result = result else {
                    //handle error
                    return
                }
                
                let list = _result.items
                
                if self.currentPage == 1 {
                    self.presenter?.presentRepositories(list: list)
                } else {
                    self.presenter?.presentNextRepositories(list: list)
                }
                
                self.currentPage += 1
            }
        })
    }
    
    func openRepoPage(_ url: String) {
        
        guard let url = URL(string: url) else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
