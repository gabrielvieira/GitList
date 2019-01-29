//
//  ListPresenter.swift
//  GitList
//
//  Created by Gabriel Vieira Figueiredo Tomaz on 28/01/19.
//  Copyright (c) 2019 Gabriel Vieira Figueiredo Tomaz. All rights reserved.

import UIKit

protocol ListPresentationLogic {
    func presentRepositories(list: [RepositoryItem])
    func presentNextRepositories(list: [RepositoryItem])
    func presentError(error: String)
}

class ListPresenter: ListPresentationLogic {
    
    weak var viewController: ListDisplayLogic?

    // MARK: Present Repositories
    func presentRepositories(list: [RepositoryItem]) {
        let viewModel = self.generateViewModel(list)
        viewController?.displayRepositories(viewModel: viewModel)
    }
    
    func presentNextRepositories(list: [RepositoryItem]) {
        let viewModel = self.generateViewModel(list)
        viewController?.displayNextRepositories(viewModel: viewModel)
    }
    
    //convert response to view model to decouple service and front end
    private func generateViewModel(_ list: [RepositoryItem]) -> ListRepositoriesViewModel {
        
        let repositoryItems = list
            .compactMap {
                RepositoryViewModelItem.init(repositoryName: $0.name,
                                             authorName: $0.owner.login,
                                             authorImageUrl: $0.owner.avatarURL,
                                             starCount: $0.stargazersCount,
                                             repositoryUrl: $0.htmlURL)
        }
        return ListRepositoriesViewModel.init(itemList: repositoryItems)
    }
    
    func presentError(error: String) {
        self.viewController?.displayError(message: error)
    }
}
