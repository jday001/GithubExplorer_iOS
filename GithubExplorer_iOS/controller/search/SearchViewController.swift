//
//  SearchViewController.swift
//  GithubExplorer_iOS
//
//  Created by Day, Jeff @ Dallas on 10/29/18.
//  Copyright © 2018 Day, Jeff @ Dallas. All rights reserved.
//

import UIKit


class SearchViewController: UIViewController, MenuPresenter {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    
    @IBAction func search(_ sender: Any) {
        let searchQuery = searchTextField.text ?? ""
        
        let identifier = "SearchResultsVC"
        let detailVC = storyboard?.instantiateViewController(withIdentifier: identifier) as! SearchResultsTableViewController
        detailVC.searchQuery = searchQuery
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        showMenu()
    }
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.layer.borderColor = AppColors.lightBlue.color.cgColor
        searchTextField.layer.borderWidth = 1.0
    }
}
