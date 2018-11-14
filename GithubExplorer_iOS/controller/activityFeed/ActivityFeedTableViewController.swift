//
//  ActivityFeedTableViewController.swift
//  GithubExplorer_iOS
//
//  Created by Day, Jeff @ Dallas on 10/29/18.
//  Copyright © 2018 Day, Jeff @ Dallas. All rights reserved.
//

import UIKit


class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var creationDateLabel: UILabel!
    @IBOutlet weak var actorNameLabel: UILabel!
    @IBOutlet weak var repoNameLabel: UILabel!
    
}

class ActivityFeedTableViewController: UITableViewController, MenuPresenter {
    
    private var events = [Event]()
    private lazy var eventService = EventService()
    private var imageCache = [String: UIImage]()
    
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        showMenu()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchEvents()
    }
    
    
    
    
    // MARK: - Private Functions
    
    private func fetchEvents() {
        guard let currentUser = LoginService.shared.loggedInUser else {
            return
        }
        
        eventService.fetchEvents(user: currentUser) { result in
            switch result {
            case .success(let events):
                self.events = events
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                print("fetch error: \(String(describing: error.localizedDescription))")
            }
        }
    }
    
    
    
    
    // MARK: - UITableView Datasource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "EventCellIdentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! EventTableViewCell
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? EventTableViewCell else { return }
        
        let event = events[indexPath.row]
        cell.creationDateLabel.text = event.displayDate
        cell.actorNameLabel.text = event.actor.login
        cell.repoNameLabel.text = event.repo.name
        
        // TODO: would be faster to just draw a mask around the imageView instead of resizing -- ok for now
        UIImage.asyncFrom(url: event.actor.avatarURL, completion: { result in
            if case let .success(image) = result {
                let roundedImage = image.rounded(radius: image.size.width/2)
                cell.userAvatar.image = roundedImage
                self.imageCache[event.actor.avatarURL.absoluteString] = roundedImage
            }
        })
    }
    
    
    
    
    // MARK: - UITableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let identifier = "EventDetailVC"
        let detailVC = storyboard?.instantiateViewController(withIdentifier: identifier) as! EventDetailViewController
        let event = events[indexPath.row]
        detailVC.event = event
        detailVC.roundedAvatarImage = imageCache[event.actor.avatarURL.absoluteString]
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
