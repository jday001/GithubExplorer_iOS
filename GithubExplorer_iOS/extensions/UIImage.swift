//
//  UIImage.swift
//  GithubExplorer_iOS
//
//  Created by Day, Jeff @ Dallas on 10/29/18.
//  Copyright © 2018 Day, Jeff @ Dallas. All rights reserved.
//

import UIKit

typealias ImageResult = Result<UIImage, ImageError>
typealias ImageCompletion = (_ result: ImageResult) -> Void

enum ImageError: Error {
    case invalidData
}

class ImageService: RemoteDataRequestor {
    func image(from url: URL, completion: @escaping ImageCompletion) {
        let request = RemoteRequestDetails.init(path: url,
                                                verb: .get,
                                                expectResponsePayload: false,
                                                additionalHeaders: nil,
                                                payload: nil)
        remoteRequest(with: request) { result in
            switch result {
            case .success(let response):
                ImageService.image(from: response.data, completion: { result in
                    switch result {
                    case .success(let image):
                        completion(.success(image))
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                })
                
            case .failure(_ ):
                completion(.failure(.invalidData))
            }
        }
    }
    
    private static func image(from data: Data, completion: @escaping ImageCompletion) {
        DispatchQueue.global(qos: .default).async {
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(.success(image))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidData))
                }
            }
        }
    }
}

extension UIImage {
    static func asyncFrom(url: URL, completion: @escaping ImageCompletion) {
        let imageService = ImageService()
        imageService.image(from: url, completion: completion)
    }
    
    func rounded(radius: CGFloat) -> UIImage {
        let imageLayer = CALayer()
        imageLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        imageLayer.contents = self.cgImage
        
        imageLayer.masksToBounds = true
        imageLayer.cornerRadius = radius
        
        UIGraphicsBeginImageContext(size)
        imageLayer.render(in: UIGraphicsGetCurrentContext()!)

        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return roundedImage
    }
}
