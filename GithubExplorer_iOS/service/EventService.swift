//
//  EventService.swift
//  GithubExplorer_iOS
//
//  Created by Day, Jeff @ Dallas on 10/29/18.
//  Copyright © 2018 Day, Jeff @ Dallas. All rights reserved.
//

import Foundation



enum EventServiceError: Error {
    case invalidCredentials
    case invalidJSON
}

class EventService: RemoteDataRequestor {
    
    typealias EventResult = Result<[Event], EventServiceError>
    typealias FetchEventsCompletion = (_ result: EventResult) -> Void
    
    func fetchEvents(user: User, completion: @escaping FetchEventsCompletion) {
        guard let encodedCredentials = user.authCredentials else {
            completion(.failure(EventServiceError.invalidCredentials))
            return
        }
        
        //let username = user.username
        let username = "facebook"
        let request = RemoteRequestDetails.init(path: URL(string: "https://api.github.com/users/\(username)/events")!,
                                                verb: .get,
                                                expectResponsePayload: true,
                                                additionalHeaders: ["Authorization": "Basic \(encodedCredentials)"],
                                                payload: nil)
        remoteRequest(with: request) { result in
            switch result {
            case .success(let response):
                print("response: \(response.json)")
                do {
                    let events = try JSONDecoder().decode([Event].self, from: response.data)
                    completion(.success(events))
                } catch {
                    completion(.failure(.invalidJSON))
                }
                
            case .failure(let failure):
                completion(.failure(.invalidJSON))
                print("error: \(String(describing: failure.error?.localizedDescription))")
            }
        }
    }
}
