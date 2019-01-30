//
//  BaseViewController.swift
//  GitList
//
//  Created by Gabriel vieira on 1/28/19.
//  Copyright © 2019 Gabriel Vieira Figueiredo Tomaz. All rights reserved.
//

import UIKit

enum ViewState {
    case loading
    case normal
}
//base view controller for futher customizations
class BaseViewController: UIViewController {

    private var loaderView: UIView = UIView()
    private let loader: UIActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
    internal var viewState: ViewState = .normal
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loader.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.loaderView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        self.loaderView.addSubview(self.loader)
    }
    
    func showLoader() {
        self.loaderView.frame = self.view.bounds
        self.loader.center = self.loaderView.center
        
        DispatchQueue.main.async {
            self.loader.startAnimating()
            self.view.addSubview(self.loaderView)
        }
    }
    
    func hideLoader() {
        
        DispatchQueue.main.async {
            self.loader.stopAnimating()
            self.loaderView.removeFromSuperview()
        }
    }
}
