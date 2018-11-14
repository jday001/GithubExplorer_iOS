//
//  Event.swift
//  GithubExplorer_iOS
//
//  Created by Day, Jeff @ Dallas on 10/29/18.
//  Copyright © 2018 Day, Jeff @ Dallas. All rights reserved.
//

import Foundation



struct Event: Codable {
    let actor: EventActor
    let creationDate: String
    let id: String
    let payload: EventPayload
    let isPublic: Bool
    let repo: EventRepo
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case actor
        case creationDate = "created_at"
        case id
        case payload
        case isPublic = "public"
        case repo
        case type
    }
}

struct EventActor: Codable {
    let avatarURL: URL
    let login: String
    let id: Int
    let url: URL
    
    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
        case login
        case id
        case url
    }
}

struct EventPayload: Codable {
    let description: String?
    let masterBranch: String?
    let pusherType: String?
    let ref: String?
    let refType: String?
    let commits: [EventCommit]?
    
    enum CodingKeys: String, CodingKey {
        case description
        case masterBranch = "master_branch"
        case pusherType = "pusher_type"
        case ref
        case refType = "ref_type"
        case commits
    }
}

struct EventCommit: Codable {
    let sha: String
    let message: String
}

struct EventRepo: Codable {
    let id: Int
    let name: String
    let url: URL
}
