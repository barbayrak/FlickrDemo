//
//  FlickrPhotoServiceType.swift
//  FlickrDemo
//
//  Created by CH Kaan on 27/02/2023.
//

import Foundation
import Combine

protocol FlickrPhotoServiceType {
    func getSearchResults(query : String, page : Int) -> AnyPublisher<(Int,[FlickrPhoto]),Error>
}
