//
//  FlickrPhoto.swift
//  FlickrDemo
//
//  Created by CH Kaan on 27/02/2023.
//

import Foundation

struct FlickrPhoto : Codable,Hashable {
    let id : String
    let owner : String
    let secret : String
    let server : String
    let title : String
    
    
    // TODO: Interesting bug occurs here if we use Diffable data source without UUID, which is not hashing the values into unique hashes
    let uuid = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    public static func == (lhs: FlickrPhoto, rhs: FlickrPhoto) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
