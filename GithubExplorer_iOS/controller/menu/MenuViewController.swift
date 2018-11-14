//
//  MenuViewController.swift
//  GithubExplorer_iOS
//
//  Created by Day, Jeff @ Dallas on 10/29/18.
//  Copyright © 2018 Day, Jeff @ Dallas. All rights reserved.
//

import UIKit


protocol MenuPresenter where Self: UIViewController {
    func showMenu()
}

extension MenuPresenter {
    func showMenu() {
        DispatchQueue.main.async {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let menuVC = sb.instantiateViewController(withIdentifier: "MenuNavController") as! UINavigationController
            self.navigationController?.topViewController?.present(menuVC, animated: true, completion: nil)
        }
    }
}


class MenuViewController: UIViewController {
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        dismiss(animated: false) {
            LoginService.shared.logout()
        }
    }
}
