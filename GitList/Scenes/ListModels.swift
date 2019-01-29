//
//  ListModels.swift
//  GitList
//
//  Created by Gabriel Vieira Figueiredo Tomaz on 28/01/19.
//  Copyright (c) 2019 Gabriel Vieira Figueiredo Tomaz. All rights reserved.

import Foundation
import Alamofire

// MARK: ViewModel
struct ListRepositoriesViewModel {
    
    var itemList: [RepositoryViewModelItem]
}

struct RepositoryViewModelItem {
    
    var repositoryName: String
    var authorName: String
    var authorImageUrl: String
    var starCount: Int
}

// MARK: Request
enum SortRepository: String {
    
    case stars = "stars"
    case forks = "forks"
    case help_wanted_issues = "help-wanted-issues"
    case updated = "updated"
}

struct ListRepositoriesRequest: BaseRequest {

    var page: Int
    var query: String
    var sort: SortRepository
    
    var endpoint: String {
        return "https://api.github.com/search/repositories"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var body: [String : Any] {
        
        return [
            "q": self.query,
            "page": self.page,
            "sort": self.sort.rawValue
        ]
    }
}

// MARK: Response
struct ListRepositoriesResponse: Codable {
    
    let totalCount: Int
    let incompleteResults: Bool
    let items: [RepositoryItem]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

struct RepositoryItem: Codable {
    
    let id: Int
    let name: String
    let stargazersCount: Int
    let owner: Owner
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case stargazersCount = "stargazers_count"
        case owner = "owner"
    }
}

struct Owner: Codable {
    
    let login: String
    let id: Int
    let avatarURL: String
    
    enum CodingKeys: String, CodingKey {
        case login, id
        case avatarURL = "avatar_url"
    }
}
