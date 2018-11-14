//
//  SearchResultsTableViewController.swift
//  GithubExplorer_iOS
//
//  Created by Day, Jeff @ Dallas on 10/29/18.
//  Copyright © 2018 Day, Jeff @ Dallas. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var issuesLabel: UILabel!
}


class SearchResultsTableViewController: UITableViewController {

    
    var searchQuery: String?
    var searchResults = [GithubRepo]()
    
    private lazy var searchService = SearchService()
    
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showActivitySpinner()
        
        navigationItem.title = "Search Results"
        tableView.tableFooterView = UIView(frame: .zero)
        
        getSearchResults()
    }
    
    
    
    
    // MARK: - Private Functions
    
    private func getSearchResults() {
        guard let searchQuery = searchQuery else { return }
        
        searchService.search(query: searchQuery) { result in
            self.hideActivitySpinner()
            
            switch result {
            case .success(let items):
                self.searchResults = items.items
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
    // MARK: - UITableView Datasource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "SearchResultCellIdentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! SearchResultTableViewCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? SearchResultTableViewCell else { return }
        
        let repoItem = searchResults[indexPath.row]
        cell.nameLabel.text = repoItem.fullName
        cell.starsLabel.text = "\(repoItem.stargazerCount)"
        cell.forksLabel.text = "\(repoItem.forks)"
        cell.issuesLabel.text = "\(repoItem.openIssues)"
    }
}
