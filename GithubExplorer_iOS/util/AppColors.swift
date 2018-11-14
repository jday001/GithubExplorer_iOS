//
//  AppColors.swift
//  GithubExplorer_iOS
//
//  Created by Day, Jeff @ Dallas on 10/29/18.
//  Copyright © 2018 Day, Jeff @ Dallas. All rights reserved.
//

import UIKit


enum AppColors {
    case lightBlue
    
    var color: UIColor {
        switch self {
        case .lightBlue:    return UIColor(red: 92/255, green: 193/255, blue: 240/255, alpha: 1)
        }
    }
}
