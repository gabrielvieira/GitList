//
//  ListFooterTableView.swift
//  GitList
//
//  Created by Gabriel vieira on 1/29/19.
//  Copyright © 2019 Gabriel Vieira Figueiredo Tomaz. All rights reserved.
//

import UIKit

class ListFooterTableView: UIView {
   
    private let loader: UIActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
    private let loaderColor: UIColor = UIColor(red:0.27, green:0.27, blue:0.27, alpha:1.0)
    
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        self.configUI()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI () {
        self.loader.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        self.loader.backgroundColor = .clear
        self.loader.color = self.loaderColor
        self.addSubview(self.loader)
        self.loader.center = self.center
        self.hide()
    }
    
    public func hide() {
        self.alpha = 0
        self.frame.size.height = 0
        self.loader.stopAnimating()
    }
    
    public func show() {
        self.alpha = 1
        self.frame.size.height = 50
        self.loader.startAnimating()
    }
}
