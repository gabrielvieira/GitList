//
//  ListModels.swift
//  GitList
//
//  Created by Gabriel Vieira Figueiredo Tomaz on 28/01/19.
//  Copyright (c) 2019 Gabriel Vieira Figueiredo Tomaz. All rights reserved.

import Foundation
import Alamofire

struct ListRepositoriesViewModel {
    
    var itemList: [RepositoryItem]
}

struct RepositoryItem {
    
    var repositoryName: String
    var authorName: String
    var authorImageUrl: String
    var starCount: Int
}

struct ListRepositoriesRequest: BaseRequest {

    var pageNumber: String
    var query: String
    var sort: String
    
    public init(pageNumber: String, query: String, sort: String) {
        self.pageNumber = pageNumber
        self.query = query
        self.sort = sort
    }
    
    var endpoint: String {
        return "https://api.github.com/search/repositories"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var body: [String : Any] {
        
        return [
            "q": self.query,
            "page": self.pageNumber,
            "sort": self.sort
        ]
    }
}

struct ListRepositoriesResponse: Codable {
    
    let totalCount: Int
    let incompleteResults: Bool
    let items: [Item]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

struct Item: Codable {
    
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
