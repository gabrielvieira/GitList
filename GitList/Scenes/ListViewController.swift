//
//  ListViewController.swift
//  GitList
//
//  Created by Gabriel Vieira Figueiredo Tomaz on 28/01/19.
//  Copyright (c) 2019 Gabriel Vieira Figueiredo Tomaz. All rights reserved.

import UIKit
import SnapKit

protocol ListDisplayLogic: class {
    func displayRepositories(viewModel: ListRepositoriesViewModel)
    func displayError(message: String)
}

class ListViewController: UIViewController, ListDisplayLogic {
    
    var interactor: ListBusinessLogic?
    var router: (NSObjectProtocol & ListRoutingLogic & ListDataPassing)?
    var tableview: UITableView = UITableView()
    // MARK: Object lifecycle
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup
    private func setup() {
        let viewController = self
        let interactor = ListInteractor()
        let presenter = ListPresenter()
        let router = ListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
//        self.tableview.delegate = self
//        self.tableview.dataSource = self
        self.configUI()
    }
    
    private func configUI() {
        
        self.view.addSubview(self.tableview)
        self.tableview.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchRepositories()
    }
    
    func fetchRepositories() {
//        let request = List.Something.Request()
        interactor?.fetchRepositories()
    }
    
    func displayRepositories(viewModel: ListRepositoriesViewModel) {
        
    }
    
    func displayError(message: String) {
        //handle error
    }
}
//
//extension ListViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return UITableViewCell()
//    }
//}
