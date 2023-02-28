//
//  FlickrPhotoSearchResult.swift
//  FlickrDemo
//
//  Created by CH Kaan on 28/02/2023.
//

import Foundation

struct FlickrPhotoSearchResult : Codable {
    let photos : FlickrPhotoSearchPage?
    let stat : String
    let code : Int?
    let message : String?
}
