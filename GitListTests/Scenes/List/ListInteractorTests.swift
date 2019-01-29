//
//  ListInteractorTests.swift
//  GitList
//
//  Created by Gabriel Vieira Figueiredo Tomaz on 29/01/19.
//  Copyright (c) 2019 Gabriel Vieira Figueiredo Tomaz. All rights reserved.

@testable import GitList
import XCTest

class ListInteractorTests: XCTestCase {
    // MARK: Subject under test

    var sut: ListInteractor!
    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        setupListInteractor()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: Test setup
    func setupListInteractor() {
        sut = ListInteractor()
    }
    // MARK: Test doubles

    class ListPresentationLogicSpy: ListPresentationLogic {
        
        var presentRepositoriesCalled: Bool = false
        var presentNextRepositoriesCalled: Bool = false
        var presentErrorCalled: Bool = false
        
        func presentRepositories(list: [RepositoryItem]) {
            presentRepositoriesCalled = true
        }
        
        func presentNextRepositories(list: [RepositoryItem]) {
            presentNextRepositoriesCalled = true
        }
        
        func presentError(error: String) {
            presentErrorCalled = true
        }
    }
    
    class ListWorkerSpy: ListWorker {
        
        var isError: Bool = false
        
        public init(isError: Bool) {
            self.isError = isError
        }
        // MARK: Method call expectations
        var fetchRepositoriesCalled: Bool = false
        
        // MARK: Spied methods
        override func fetchRepositories(request: ListRepositoriesRequest, completionHandler: @escaping (ListRepositoriesResponse?, APIClientError?) -> Void) {
            
            let mocklistResponse: ListRepositoriesResponse = ListRepositoriesResponse(totalCount: 123, incompleteResults: false, items: [])
            
            let error: APIClientError = APIClientError.CouldNotDecodeJSON
            
            if self.isError {
                completionHandler(nil,error)
            } else {
                completionHandler(mocklistResponse,nil)
            }
            
            fetchRepositoriesCalled = true
        }
    }
    
    func testFetchRepositoriesShouldAskListWorkerToFetchRepositoriesAndPresenterToFormatResult() {
        // Given
        let listOrdersPresentationLogicSpy = ListPresentationLogicSpy()
        sut.presenter = listOrdersPresentationLogicSpy
        let listWorkerSpy = ListWorkerSpy(isError: false)
        sut.worker = listWorkerSpy
        
        // When
        sut.fetchRepositories(resetPage: false)
        
        // Then
        XCTAssert(listWorkerSpy.fetchRepositoriesCalled, "fetchRepositories should ask ListWorker to fetch Repositories")
        XCTAssert(listOrdersPresentationLogicSpy.presentRepositoriesCalled, "FetchRepositories() should ask presenter to format repositories result")
    }
    
    func testFetchRepositoriesShouldAskListWorkerToFetchRepositoriesAndPresenterToFormatResultWhenPagesMajorThanOne() {
        // Given
        let listOrdersPresentationLogicSpy = ListPresentationLogicSpy()
        sut.presenter = listOrdersPresentationLogicSpy
        let listWorkerSpy = ListWorkerSpy(isError: false)
        sut.worker = listWorkerSpy
        
        // When
        
        //emulate infinite scrolling
        sut.fetchRepositories(resetPage: false)
        sut.fetchRepositories(resetPage: false)
        sut.fetchRepositories(resetPage: false)
        
        // Then
        XCTAssert(listWorkerSpy.fetchRepositoriesCalled, "fetchRepositories should ask ListWorker to fetch Repositories")
        XCTAssert(listOrdersPresentationLogicSpy.presentNextRepositoriesCalled, "FetchRepositories() should ask presenter to format repositories result")
    }
    
    func testFetchRepositoriesShouldAskListWorkerToFetchRepositoriesAndPresenteError() {
        // Given
        let listOrdersPresentationLogicSpy = ListPresentationLogicSpy()
        sut.presenter = listOrdersPresentationLogicSpy
        let listWorkerSpy = ListWorkerSpy(isError: true)
        sut.worker = listWorkerSpy
        
        // When
        sut.fetchRepositories(resetPage: false)
        
        // Then
        XCTAssert(listWorkerSpy.fetchRepositoriesCalled, "fetchRepositories should ask ListWorker to fetch Repositories")
        XCTAssert(listOrdersPresentationLogicSpy.presentErrorCalled, "Present error when returned")
    }
}
