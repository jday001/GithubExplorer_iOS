//
//  Result.swift
//  GithubExplorer_iOS
//
//  Created by Day, Jeff @ Dallas on 10/25/18.
//  Copyright © 2018 Day, Jeff @ Dallas. All rights reserved.
//

import Foundation


enum Result<T, Error> {
    case success(T)
    case failure(Error)
}
