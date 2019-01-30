//
//  AppRouter.swift
//  GitList
//
//  Created by Gabriel vieira on 1/29/19.
//  Copyright © 2019 Gabriel Vieira Figueiredo Tomaz. All rights reserved.
//

import UIKit

//simple router for application
class AppRouter {
    
    private static var navigation: UINavigationController = UINavigationController()
    
    public static func getNavigation() -> UINavigationController {
        return self.navigation
    }
    
    public static func routeToRepositoryList() {
        
        let viewController = ListViewController()
        self.navigation.pushViewController(viewController, animated: false)
    }
}
