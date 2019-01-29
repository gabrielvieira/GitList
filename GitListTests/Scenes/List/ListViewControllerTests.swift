//
//  ListViewControllerTests.swift
//  GitList
//
//  Created by Gabriel Vieira Figueiredo Tomaz on 29/01/19.
//  Copyright (c) 2019 Gabriel Vieira Figueiredo Tomaz. All rights reserved.

@testable import GitList
import XCTest

class ListViewControllerTests: XCTestCase {
// MARK: Subject under test

    var sut: ListViewController!
    var window: UIWindow!

    // MARK: Test lifecycle
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupListViewController()
    }

    override func tearDown() {
        window = nil
        super.tearDown()
    }

    // MARK: Test setup
    func setupListViewController() {
        self.sut = ListViewController()
    }

    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }

    // MARK: Test doubles
    class ListBusinessLogicSpy: ListBusinessLogic {
    
        var fetchRepositoriesCalled: Bool = false
        var openRepoPageCalled: Bool = false
        
        func fetchRepositories(resetPage: Bool) {
            self.fetchRepositoriesCalled = true
        }

        func openRepoPage(_ url: String) {
            self.openRepoPageCalled = true
        }
    }
    
    class TableViewSpy: UITableView {
        // MARK: Method call expectations
        var reloadDataCalled: Bool = false
        
        var didSelectCalled: Bool = false
        // MARK: Spied methods
        
        override func reloadData()
        {
            reloadDataCalled = true
        }
    }

    // MARK: Tests

    func testShouldfetchRepositoriesWhenViewIsLoaded() {
        // Given
        let spy = ListBusinessLogicSpy()
        sut.interactor = spy

        // When
        loadView()
        sut.viewDidLoad()

        // Then
        XCTAssertTrue(spy.fetchRepositoriesCalled, "viewDidLoad() should ask the interactor to do fetch repositories")
    }
    
    func testShouldDisplayFetchedRepositories() {
        // Given
        let tableViewSpy = TableViewSpy()
        sut.tableView = tableViewSpy
        
        // When
        let displayedRepositories = [ RepositoryViewModelItem(repositoryName: "fake repo", authorName: "fake author", authorImageUrl: "fake_url", starCount: 1234, repositoryUrl: "fake_repo_url") ]
        
        let viewModel = ListRepositoriesViewModel(itemList: displayedRepositories)
        sut.displayRepositories(viewModel: viewModel)
        
        // Then
        XCTAssert(tableViewSpy.reloadDataCalled, "Displaying fetched repositories should reload the table view")
    }
    
    func testShouldDisplayNextFetchedRepositories() {
        // Given
        let displayedRepositories = [ RepositoryViewModelItem(repositoryName: "fake repo", authorName: "fake author", authorImageUrl: "fake_url", starCount: 1234, repositoryUrl: "fake_repo_url") ]
        
        let viewModel = ListRepositoriesViewModel(itemList: displayedRepositories)
        sut.displayRepositories(viewModel: viewModel)
        sut.displayNextRepositories(viewModel: viewModel)
        
        // When
        let numberOfRows = sut.tableView.numberOfRows(inSection: 0)
        //
        // Then
        XCTAssertEqual(numberOfRows, 2, "The number of table view rows should equal the number of orders to display")
    }
    
    func testNumberOfSectionsInTableViewShouldAlwaysBeOne() {
        // Given
        let tableView = sut.tableView
        
        // When
        let numberOfSections = sut.numberOfSections(in: tableView)
        
        // Then
        XCTAssertEqual(numberOfSections, 1, "The number of table view sections should always be 1")
    }

    func testNumberOfRowsInAnySectionShouldEqaulNumberOfOrdersToDisplay() {
     
        // Given
        let displayedRepositories = [ RepositoryViewModelItem(repositoryName: "fake repo", authorName: "fake author", authorImageUrl: "fake_url", starCount: 1234, repositoryUrl: "fake_repo_url") ]
       
        let viewModel = ListRepositoriesViewModel(itemList: displayedRepositories)
        sut.displayRepositories(viewModel: viewModel)
        
        // When
        let numberOfRows = sut.tableView.numberOfRows(inSection: 0)

        // Then
        XCTAssertEqual(numberOfRows, displayedRepositories.count, "The number of table view rows should equal the number of orders to display")
    }
    
    func testShouldConfigureTableViewCellToDisplayOrder() {
        
        // Given
        let displayedRepositories = [ RepositoryViewModelItem(repositoryName: "fake repo", authorName: "fake author", authorImageUrl: "fake_url", starCount: 1234, repositoryUrl: "fake_repo_url") ]
        
        let viewModel = ListRepositoriesViewModel(itemList: displayedRepositories)
        sut.displayRepositories(viewModel: viewModel)
        
        // When
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView.cellForRow(at: indexPath) as! ListTableViewCell
        
        // Then
        XCTAssertEqual(cell.repoNameLabel.text, "fake repo", "A properly configured table view cell should display the repository name")
        
        XCTAssertEqual(cell.authorNameLabel.text, "fake author", "A properly configured table view cell should display the author name")
        
        let startText = cell.starLabel.text ?? ""
        
        XCTAssertEqual(Int(startText), 1234, "A properly configured table view cell should display the star count")
    }
    
    func testShouldCallOpenRepoPage() {
        
        let displayedRepositories = [ RepositoryViewModelItem(repositoryName: "fake repo", authorName: "fake author", authorImageUrl: "fake_url", starCount: 1234, repositoryUrl: "fake_repo_url") ]
        
        let viewModel = ListRepositoriesViewModel(itemList: displayedRepositories)
        sut.displayRepositories(viewModel: viewModel)
        
        let spy = ListBusinessLogicSpy()
        sut.interactor = spy
        
        // When
        let numberOfRows = sut.tableView.numberOfRows(inSection: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        sut.tableView.delegate?.tableView!(sut.tableView, didSelectRowAt: indexPath)
        
        XCTAssertEqual(numberOfRows, displayedRepositories.count, "The number of table view rows should equal the number of orders to display")
        XCTAssert(spy.openRepoPageCalled, "Open Repo must be called when click on tableViewCell")
    }
}
