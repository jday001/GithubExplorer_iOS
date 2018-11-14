//
//  GithubRepo.swift
//  GithubExplorer_iOS
//
//  Created by Day, Jeff @ Dallas on 10/29/18.
//  Copyright © 2018 Day, Jeff @ Dallas. All rights reserved.
//

import Foundation

struct GithubItems: Codable {
    let items: [GithubRepo]
}

struct GithubRepo: Codable {
    let fullName: String
    let stargazerCount: Int
    let forks: Int
    let openIssues: Int
    
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case stargazerCount = "stargazers_count"
        case forks
        case openIssues = "open_issues"
    }
}
