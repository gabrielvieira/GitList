//
//  ListPresenter.swift
//  GitList
//
//  Created by Gabriel Vieira Figueiredo Tomaz on 28/01/19.
//  Copyright (c) 2019 Gabriel Vieira Figueiredo Tomaz. All rights reserved.

import UIKit

protocol ListPresentationLogic {
    func presentRepositories(response: ListRepositoriesResponse)
}

class ListPresenter: ListPresentationLogic {
    
    weak var viewController: ListDisplayLogic?

    // MARK: Present Repositories

    func presentRepositories(response: ListRepositoriesResponse) {
        
        //convert response to view model to decouple service and front end
        let repositoryItems = response.items
                              .compactMap {
                                RepositoryItem.init(repositoryName: $0.name,
                                                           authorName: $0.owner.login,
                                                       authorImageUrl: $0.owner.avatarURL,
                                                            starCount: $0.stargazersCount)
                               }
        
        let viewModel = ListRepositoriesViewModel.init(itemList: repositoryItems)
        viewController?.displayRepositories(viewModel: viewModel)
    }
}
