//
//  DateFormatters.swift
//  GithubExplorer_iOS
//
//  Created by Day, Jeff @ Dallas on 11/14/18.
//  Copyright © 2018 Day, Jeff @ Dallas. All rights reserved.
//

import Foundation


class DateFormatters {
    
    static var inputDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        return formatter
    }
    
    static var displayDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy - H:mm"
        return formatter
    }
}
