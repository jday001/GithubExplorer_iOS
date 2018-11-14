//
//  RemoteDataRequestor.swift
//  Copyright 2016, JDay Apps, LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//  documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
//  persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
//  Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//  WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
//  OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//



import Foundation


class RemoteRequestManager: NSObject {
    
    static let shared = RemoteRequestManager()
    
    
    private lazy var operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .default
        return queue
    }()
    
    var urlSession: URLSession {
        get {
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: self.operationQueue)
            return session
        }
    }
    
    fileprivate var currentTasks: [URLSessionTask]?
    
    
    
    
    // MARK: - Internal Functions
    
    func addTask(_ task: URLSessionTask?) {
        guard let task = task else { return }
        
        DispatchQueue.main.async {
            self.currentTasks?.append(task)
        }
    }
    
    func removeTask(_ task: URLSessionTask?) {
        guard let task = task else { return }
        
        DispatchQueue.main.async {
            guard let index = self.currentTasks?.index(of: task) else {
                return
            }
            
            self.currentTasks?.remove(at: index)
        }
    }
    
    func cancelAllTasks() {
        DispatchQueue.main.async {
            self.currentTasks?.removeAll()
        }
    }
}

extension RemoteRequestManager: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}
