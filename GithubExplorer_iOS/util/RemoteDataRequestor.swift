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


struct RemoteRequestResult {
    var data: Data
    var response: HTTPURLResponse
    var json: AnyObject
}

struct RemoteRequestFailure {
    var response: HTTPURLResponse?
    var error: RemoteRequestError?
}

struct RemoteRequestDetails {
    var path: URL
    var verb: RemoteRequestVerb
    var expectResponsePayload: Bool
    var additionalHeaders: [String: Any]?
    var payload: Any?
}

enum RemoteRequestVerb: String {
    case get    = "GET"
    case delete = "DELETE"
    case post   = "POST"
    case put    = "PUT"
}

enum RemoteRequestError: Error {
    case noResponse
    case invalidJSON
    case invalidURL
    case serverError
    
    func description() -> String {
        switch self {
        case .noResponse:   return "no response"
        case .invalidJSON:  return "invalid JSON"
        case .invalidURL:   return "invalid URL"
        case .serverError:  return "server error"
        }
    }
}



typealias RemoteResult = Result<RemoteRequestResult, RemoteRequestFailure>
typealias RemoteDataCompletion = ((RemoteResult) -> Void)



protocol RemoteDataRequestor { }

extension RemoteDataRequestor {
    
    func remoteRequest(with requestDetails: RemoteRequestDetails, completion: @escaping RemoteDataCompletion) {
        guard let request = requestWithDefaultHeaders(for: requestDetails.path) else {
            completion(.failure(RemoteRequestFailure(response: nil,
                                                     error: RemoteRequestError.invalidURL)))
            return
        }
        
        request.httpMethod = requestDetails.verb.rawValue
        
        if let additionalHeaders = requestDetails.additionalHeaders {
            for (key, value) in additionalHeaders {
                if let value = value as? String {
                    request.setValue(value, forHTTPHeaderField: key)
                } else if let values = value as? Array<String> {
                    for value in values {
                        request.addValue(value, forHTTPHeaderField: key)
                    }
                }
            }
        }
        
        if let payload = requestDetails.payload {
            if let payloadData = payload as? Data {
                request.httpBody = payloadData
            } else if let jsonData = try? JSONSerialization.data(withJSONObject: payload, options: []) {
                request.httpBody = jsonData
            } else {
                completion(.failure(
                    RemoteRequestFailure(response: nil, error: RemoteRequestError.invalidJSON)))
                return
            }
        }
        
        self.remoteRequest(requestDetails, request: request, completion: completion)
    }
    
    func remoteUploadRequest(_ requestDetails: RemoteRequestDetails, request: NSURLRequest, uploadData: Data, completion: @escaping RemoteDataCompletion) {
        var task: URLSessionUploadTask?
        task = RemoteRequestManager.shared.urlSession
            .uploadTask(with: request as URLRequest, from: uploadData, completionHandler: { (data, response, error) in
                
                self.handleResponse(requestDetails, data: data, response: response, error: error as NSError?, completion: { (result) in
                    RemoteRequestManager.shared.removeTask(task)
                    completion(result)
                })
            })
        
        RemoteRequestManager.shared.addTask(task)
        task?.resume()
    }
    
    
    
    
    // MARK: - Private Functions
    
    fileprivate func remoteRequest(_ requestDetails: RemoteRequestDetails, request: NSURLRequest, completion: @escaping RemoteDataCompletion) {
        
        print("request: \(request)")
        
        var task: URLSessionTask?
        task = RemoteRequestManager.shared.urlSession
            .dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                
                self.handleResponse(requestDetails, data: data, response: response, error: error as NSError?, completion: { (result) in
                    completion(result)
                    RemoteRequestManager.shared.removeTask(task)
                })
            })
        
        RemoteRequestManager.shared.addTask(task)
        task?.resume()
    }
    
    fileprivate func handleResponse(_ requestDetails: RemoteRequestDetails, data: Data?, response: URLResponse?, error: NSError?, completion: RemoteDataCompletion) {
        
        guard error == nil else {
            print("\(#function): \(String(describing: error?.localizedDescription))")
            
            completion(.failure(
                RemoteRequestFailure(response: (response as? HTTPURLResponse),
                                     error: RemoteRequestError.serverError)))
            return
        }
        
        guard let data = data,
            let response = response as? HTTPURLResponse else {
                completion(.failure(
                    RemoteRequestFailure(response: nil,
                                         error: RemoteRequestError.noResponse)))
                return
        }
        
        guard (200..<300).contains(response.statusCode) else {
            let data = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            print("response: \(response.statusCode), data: \(String(describing: data))")
            completion(.failure(RemoteRequestFailure(response: response, error: .serverError)))
            return
        }
        
        if requestDetails.expectResponsePayload {
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                completion(.failure(RemoteRequestFailure(response: response,
                                                         error: RemoteRequestError.invalidJSON)))
                return
            }
            
            completion(.success(RemoteRequestResult(data: data, response: response, json: json as AnyObject)))
        } else {
            completion(.success(RemoteRequestResult(data: data, response: response, json: [:] as AnyObject)))
        }
    }
    
    fileprivate func requestWithDefaultHeaders(for url: URL) -> NSMutableURLRequest? {
        let request = NSMutableURLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue(VersionManager.version(), forHTTPHeaderField: "Client-Version")
        
        return request
    }
}
