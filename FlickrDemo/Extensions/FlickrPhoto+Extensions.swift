//
//  FlickrPhoto+Extensions.swift
//  FlickrDemo
//
//  Created by CH Kaan on 27/02/2023.
//

import Foundation

extension FlickrPhoto {
    
    func smallSizePhotoUrl() -> URL? {
        return urlForPhoto(size: "n")
    }
    
    func bigSizePhotoUrl() -> URL? {
        return urlForPhoto(size: "b")
    }
    
    private func urlForPhoto(size : String) -> URL? {
        return URL(string: "https://live.staticflickr.com/\(server)/\(id)_\(secret)_\(size).jpg")
    }
    
}
