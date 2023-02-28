//
//  APIError.swift
//  FlickrDemo
//
//  Created by CH Kaan on 28/02/2023.
//

import Foundation

enum APIError : Error,Equatable {
    case networkError
    case invalidUrl
    case invalidResponse
    case apiNotAvailable
    case invalidApiKey
    case serviceUnavailable
    case customError
}
