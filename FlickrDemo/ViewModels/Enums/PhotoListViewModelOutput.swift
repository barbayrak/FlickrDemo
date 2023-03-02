//
//  PhotoListViewModelOutput.swift
//  FlickrDemo
//
//  Created by CH Kaan on 01/03/2023.
//

import Foundation
import Combine

enum PhotoListViewModelOutput{
    case searchQueryFailed(error : Error)
    case showSearchQuery
    case showQueryHistory
}
