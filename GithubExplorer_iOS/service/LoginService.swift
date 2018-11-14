//
//  LoginService.swift
//  GithubExplorer_iOS
//
//  Created by Day, Jeff @ Dallas on 10/25/18.
//  Copyright © 2018 Day, Jeff @ Dallas. All rights reserved.
//

import Foundation


enum LoginError: Error {
    case invalidJSON
    case server
}

typealias LoginResult = Result<User, LoginError>
typealias LoginCompletion = (_ result: LoginResult) -> Void



protocol LoginServiceDelegate: class {
    func loginStatusChanged()
}


final class LoginService: RemoteDataRequestor {
    
    weak var delegate: LoginServiceDelegate?
    
    static let shared = LoginService()
    
    
    var loggedInUser: User? {
        let keychain = KeychainSwift()
        guard let userData = keychain.getData(KeychainKeys.userData.rawValue),
            let decoded = Data(base64Encoded: userData),
            let user = try? JSONDecoder().decode(User.self, from: decoded) else {
                return nil
        }
        
        return user
    }
    
    
    
    
    func login(credentials: Credentials, completion: @escaping LoginCompletion) {
        let headers = ["Authorization": "Basic \(credentials.encoded)"]
        let request = RemoteRequestDetails.init(path: URL(string: "https://api.github.com/user")!,
                                                verb: .get,
                                                expectResponsePayload: true,
                                                additionalHeaders: headers,
                                                payload: nil)
        
        self.remoteRequest(with: request) { result in
            switch result {
            case .success(let response):
                do {
                    print("json: \(response.json)")
                    var user = try JSONDecoder().decode(User.self, from: response.data)
                    user.authCredentials = credentials.encoded
                    user.saveToKeychain()
                    self.delegate?.loginStatusChanged()
                    completion(.success(user))
                } catch {
                    print(String(describing: error.localizedDescription))
                    completion(.failure(.invalidJSON))
                }
                
            case .failure(let failure):
                print(String(describing: failure.error?.localizedDescription))
            }
        }
    }
    
    func logout() {
        let keychain = KeychainSwift()
        keychain.delete(KeychainKeys.userData.rawValue)
        delegate?.loginStatusChanged()
    }
}
