//
//  LoginViewController.swift
//  GithubExplorer_iOS
//
//  Created by Day, Jeff @ Dallas on 10/25/18.
//  Copyright © 2018 Day, Jeff @ Dallas. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet var textFields: [UITextField]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFields.forEach { textField in
            textField.layer.borderColor = AppColors.lightBlue.color.cgColor
            textField.layer.borderWidth = 1.0
        }
    }
    
    
    @IBAction func login(_ sender: Any) {
        showActivitySpinner()
        
        let credentials = Credentials.init(username: usernameTextField.text!, password: passwordTextField.text!)
        LoginService.shared.login(credentials: credentials) { result in
            self.hideActivitySpinner()
            
            switch result {
            case .success(_ ):
                break
                
            case .failure(let error):
                print(String(describing: error.localizedDescription))
            }
        }
    }
}
