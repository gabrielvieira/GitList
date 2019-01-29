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
    func displayNextRepositories(viewModel: ListRepositoriesViewModel)
    func displayError(message: String)
    func stopRefresing()
    func showLoader()
    func hideLoader()
}

class ListViewController: BaseViewController, ListDisplayLogic {
    
    var interactor: ListBusinessLogic?
    var tableView: UITableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private var tableViewData: [RepositoryViewModelItem] = []
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
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        self.configUI()
    }
    
    private func configUI() {
        
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = self.refreshControl
        } else {
            self.tableView.addSubview(self.refreshControl)
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.reuseIdentifier)
        self.refreshControl.addTarget(self, action: #selector(refreshRepositories(_:)), for: .valueChanged)
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        self.view.backgroundColor = .white
    }
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchRepositories(resetPage: false)
    }
    
    private func fetchRepositories(resetPage: Bool) {
        self.showLoader()
        self.interactor?.fetchRepositories(resetPage: resetPage)
    }
    
    @objc private func refreshRepositories(_ sender: Any) {
        self.fetchRepositories(resetPage: true)
    }
    
    func displayRepositories(viewModel: ListRepositoriesViewModel) {
        self.hideLoader()
        self.stopRefresing()
        self.tableViewData = viewModel.itemList
        self.tableView.reloadData()
    }
    
    func displayNextRepositories(viewModel: ListRepositoriesViewModel) {
        self.hideLoader()
        self.stopRefresing()
        self.tableViewData.append(contentsOf: viewModel.itemList)
        self.tableView.reloadData()
    }
    
    func displayError(message: String) {
        //handle error
    }
    
    func stopRefresing() {
        self.refreshControl.endRefreshing()
    }
    
    override func showLoader() {
        super.showLoader()
    }
    
    override func hideLoader() {
        super.hideLoader()
    }
}


extension ListViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewData.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell =
            tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseIdentifier,
                                                     for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        let item = self.tableViewData[indexPath.row]
        
        cell.setup(item)
        return cell
    }
}
