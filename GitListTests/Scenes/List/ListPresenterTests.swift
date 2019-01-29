//
//  ListPresenterTests.swift
//  GitList
//
//  Created by Gabriel Vieira Figueiredo Tomaz on 29/01/19.
//  Copyright (c) 2019 Gabriel Vieira Figueiredo Tomaz. All rights reserved.

@testable import GitList

import XCTest

class ListPresenterTests: XCTestCase {
    // MARK: Subject under test

    var sut: ListPresenter!

    // MARK: Test lifecycle
    override func setUp() {
        
        super.setUp()
        setupListPresenter()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: Test setup
    func setupListPresenter() {
        sut = ListPresenter()
    }

    // MARK: Test doubles

    class ListDisplayLogicSpy: ListDisplayLogic {
        
        var displayRepositoriesCalled: Bool = false
        var displayNextRepositoriesCalled: Bool = false
        var displayErrorCalled: Bool = false
        
        func displayRepositories(viewModel: ListRepositoriesViewModel) {
            displayRepositoriesCalled = true
        }
        
        func displayNextRepositories(viewModel: ListRepositoriesViewModel) {
            displayNextRepositoriesCalled = true
        }
        
        func displayError(message: String) {
            displayErrorCalled = true
        }
    }

    // MARK: Tests
    func testGenerateViewModel() {
        
        let mockViewModelItem = RepositoryViewModelItem.init(repositoryName: "mock repo name",
                                                         authorName: "mock author name",
                                                         authorImageUrl: "mock_url",
                                                         starCount: 1234,
                                                         repositoryUrl: "mock_repo_url")
        
        let mockViewModel = ListRepositoriesViewModel.init(itemList: [mockViewModelItem])
        
        let mockOwner = Owner(login: "mock author name", id: 123, avatarURL: "mock_url")
        
        let resultViewModel = sut.generateViewModel([
            RepositoryItem(id: 123, name: "mock repo name", stargazersCount: 1234, owner: mockOwner, htmlURL: "mock_repo_url")
            ])
        
        XCTAssertEqual(mockViewModel.itemList[0].repositoryName, resultViewModel.itemList[0].repositoryName, "A properly configured must be the same in the mock and real generated view model")
        
        XCTAssertEqual(mockViewModel.itemList[0].authorName, resultViewModel.itemList[0].authorName, "A properly configured must be the same in the mock and real generated view model")
        
        XCTAssertEqual(mockViewModel.itemList[0].authorImageUrl, resultViewModel.itemList[0].authorImageUrl, "A properly configured must be the same in the mock and real generated view model")

        XCTAssertEqual(mockViewModel.itemList[0].starCount, resultViewModel.itemList[0].starCount, "A properly configured must be the same in the mock and real generated view model")

        XCTAssertEqual(mockViewModel.itemList[0].repositoryUrl, resultViewModel.itemList[0].repositoryUrl, "A properly configured must be the same in the mock and real generated view model")
    }
    
    func testPresentFetchedRepositoriesShouldAskViewControllerToDisplayRepositories() {
        // Given
        let listRepositoriesDisplayLogicSpy = ListDisplayLogicSpy()
        sut.viewController = listRepositoriesDisplayLogicSpy
        
        // When
        let response = ListRepositoriesResponse(totalCount: 123, incompleteResults: false, items: [])
        sut.presentRepositories(list: response.items)
        
        // Then
        XCTAssert(listRepositoriesDisplayLogicSpy.displayRepositoriesCalled, "Presenting fetched orders should ask view controller to display them")
    }
    
    func testPresentFetchedRepositoriesShouldAskViewControllerToDisplayNextRepositories() {
        // Given
        let listRepositoriesDisplayLogicSpy = ListDisplayLogicSpy()
        sut.viewController = listRepositoriesDisplayLogicSpy
        
        // When
        let response = ListRepositoriesResponse(totalCount: 123, incompleteResults: false, items: [])
        sut.presentNextRepositories(list: response.items)
        
        // Then
        XCTAssert(listRepositoriesDisplayLogicSpy.displayNextRepositoriesCalled, "Presenting fetched orders should ask view controller to display them")
    }
    
    func testPresentFetchedRepositoriesErrorShouldAskViewControllerToDisplayError() {
        // Given
        let listRepositoriesDisplayLogicSpy = ListDisplayLogicSpy()
        sut.viewController = listRepositoriesDisplayLogicSpy
        
        // When
        sut.presentError(error: "Erro generico")
        
        // Then
        XCTAssert(listRepositoriesDisplayLogicSpy.displayErrorCalled, "Presenting fetched orders should ask view controller to display them")
    }
}
