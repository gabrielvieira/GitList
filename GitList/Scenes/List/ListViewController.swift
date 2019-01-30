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
}

class ListViewController: BaseViewController, ListDisplayLogic {
    
    var interactor: ListBusinessLogic?
    var tableView: UITableView = UITableView()
    var tableViewData: [RepositoryViewModelItem] = []
    private let refreshControl = UIRefreshControl()
    private let footerView: ListFooterTableView = ListFooterTableView()
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
        
        //refresh control
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = self.refreshControl
        } else {
            self.tableView.addSubview(self.refreshControl)
        }
        
        self.refreshControl.addTarget(self, action: #selector(refreshRepositories(_:)), for: .valueChanged)
        
        //TableView setup
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.reuseIdentifier)
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        self.tableView.tableFooterView = self.footerView
        self.view.backgroundColor = .white
    }
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Github"
        self.showLoader()
        self.fetchRepositories(resetPage: false)
    }
    
    private func fetchRepositories(resetPage: Bool) {
        self.viewState = .loading
        self.interactor?.fetchRepositories(resetPage: resetPage)
    }
    
    @objc private func refreshRepositories(_ sender: Any) {
        self.fetchRepositories(resetPage: true)
    }
    
    func displayRepositories(viewModel: ListRepositoriesViewModel) {
        self.hideLoader()
        self.stopRefresing()
        self.tableViewData = viewModel.itemList
        self.footerView.show()
        self.tableView.reloadData()
        self.viewState = .normal
    }
    
    func displayNextRepositories(viewModel: ListRepositoriesViewModel) {
        self.hideLoader()
        self.stopRefresing()
        self.tableViewData.append(contentsOf: viewModel.itemList)
        self.tableView.reloadData()
        self.viewState = .normal
    }
    
    func displayError(message: String) {
        //handle error
        self.hideLoader()
        self.stopRefresing()
        let alert = UIAlertController(title: "Alerta", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        self.viewState = .normal
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
    
    func hideFooterLoader(_ isHidden: Bool) {
        self.footerView.isHidden = isHidden
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let item = self.tableViewData[indexPath.row]
        self.interactor?.openRepoPage(item.repositoryUrl)
    }
    
    //check end of tableview for infinite scroll
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let tableviewHeight = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        
        if ((distanceFromBottom < tableviewHeight) && (self.viewState != .loading)) {
            self.viewState = .loading
            self.interactor?.fetchRepositories(resetPage: false)
        }
    }
}
