//
//  FlickrPhoto.swift
//  FlickrDemo
//
//  Created by CH Kaan on 27/02/2023.
//

import Foundation

struct FlickrPhoto : Codable {
    let id : String
    let owner : String
    let secret : String
    let server : String
    let title : String
}
