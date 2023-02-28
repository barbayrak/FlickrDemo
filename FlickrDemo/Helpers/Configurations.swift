//
//  Configurations.swift
//  FlickrDemo
//
//  Created by CH Kaan on 27/02/2023.
//

import Foundation

struct Configurations {
    
    struct FlickrAPI {
        static var scheme = "https"
        static var host = "api.flickr.com"
        static var searchPath = "/services/rest"
        static var apiKey = "1508443e49213ff84d566777dc211f2a"
        static var searchMethod = "flickr.photos.search"
        static var itemPerPage = 25
        static var noJsonCallback = "1"
        static var responseFormat = "json"
    }
    
    struct Cache {
        static let countLimit = 50
        static let memoryLimit = 50 * 1024 * 1024 // 50MB
    }
    
}
