//
//  SearchService.swift
//  GithubExplorer_iOS
//
//  Created by Day, Jeff @ Dallas on 10/29/18.
//  Copyright © 2018 Day, Jeff @ Dallas. All rights reserved.
//

import Foundation



enum SearchServiceError: Error {
    case invalidJSON
    case server
}


class SearchService: RemoteDataRequestor {
    
    typealias SearchResult = Result<GithubItems, SearchServiceError>
    typealias SearchCompletion = (_ result: SearchResult) -> Void
    
    func search(query: String, completion: @escaping SearchCompletion) {
        let path = "https://api.github.com/search/repositories?q=\(query)"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let request = RemoteRequestDetails.init(path: URL(string: path)!,
                                                verb: .get,
                                                expectResponsePayload: true,
                                                additionalHeaders: nil,
                                                payload: nil)
        
        remoteRequest(with: request) { result in
            switch result {
            case .success(let response):
                do {
                    let items = try JSONDecoder().decode(GithubItems.self, from: response.data)
                    completion(.success(items))
                } catch {
                    completion(.failure(.invalidJSON))
                }
                
            case .failure(let failure):
                completion(.failure(.server))
                print("error: \(String(describing: failure.error))")
            }
        }
    }
}

