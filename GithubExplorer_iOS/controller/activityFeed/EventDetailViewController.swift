//
//  EventDetailViewController.swift
//  GithubExplorer_iOS
//
//  Created by Day, Jeff @ Dallas on 10/29/18.
//  Copyright © 2018 Day, Jeff @ Dallas. All rights reserved.
//

import UIKit


class EventDetailViewController: UIViewController {
    
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var creationDateLabel: UILabel!
    @IBOutlet weak var actorNameLabel: UILabel!
    @IBOutlet weak var branchNameLabel: UILabel!
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var commitsCountLabel: UILabel!
    
    
    var event: Event?
    var roundedAvatarImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let event = event else { return }
        
        userAvatar.image = roundedAvatarImage
        creationDateLabel.text = event.displayDate
        actorNameLabel.text = event.actor.login
        branchNameLabel.text = event.payload.ref?.replacingOccurrences(of: "refs/heads/", with: "") ?? ""
        repoNameLabel.text = event.repo.name
        commitsCountLabel.text = "\(event.payload.commits?.count ?? 0) commits"
    }
}
