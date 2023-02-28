//
//  FlickrPhotoSearchPage.swift
//  FlickrDemo
//
//  Created by CH Kaan on 28/02/2023.
//

import Foundation

struct FlickrPhotoSearchPage : Codable {
    let page : Int
    let pages : Int
    let perpage : Int
    let total : Int
    let photo : [FlickrPhoto]
}
