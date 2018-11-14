//
//  RootViewController.swift
//  GithubExplorer_iOS
//
//  Created by Day, Jeff @ Dallas on 10/27/18.
//  Copyright © 2018 Day, Jeff @ Dallas. All rights reserved.
//

import UIKit


class RootViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoginService.shared.delegate = self
        updateChildViewController()
    }
    
    fileprivate func updateChildViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let _ = LoginService.shared.loggedInUser {
            let tabController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
            tabController.view.willMove(toSuperview: self.view)
            view.addSubview(tabController.view)
            addChild(tabController)
            tabController.view.didMoveToSuperview()
        } else {
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            loginVC.view.willMove(toSuperview: self.view)
            view.addSubview(loginVC.view)
            addChild(loginVC)
            loginVC.view.didMoveToSuperview()
        }
    }
}

extension RootViewController: LoginServiceDelegate {
    func loginStatusChanged() {
        DispatchQueue.main.async {
            self.updateChildViewController()
        }
    }
}
