//
//  ImageService.swift
//  FlickrDemo
//
//  Created by CH Kaan on 27/02/2023.
//

import Foundation
import Combine
import UIKit

class ImageService : ImageServiceType {
    
    func getImageFromUrl(url : URL) -> AnyPublisher<UIImage?, Never> {
        //Check if image data is cached
        if let imageData : Data  = CacheManager.shared.getObject(key: url.absoluteString) {
            let cachedImage = UIImage(data: imageData)
            return Just(cachedImage).replaceError(with: nil).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
        .tryMap { (data: Data, response: URLResponse) -> UIImage? in
            let imageFromData = UIImage(data: data)
            if(data.count > 0){
                CacheManager.shared.putObject(object: data, key: url.absoluteString)
            }
            return imageFromData
        }
        .subscribe(on: DispatchQueue.global())
        .receive(on: DispatchQueue.main)
        .replaceError(with: nil)
        .eraseToAnyPublisher()
    }
    
}
