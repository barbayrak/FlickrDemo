//
//  PhotoListViewModelInput.swift
//  FlickrDemo
//
//  Created by CH Kaan on 01/03/2023.
//

import Foundation
import Combine

enum PhotoListViewModelInput{
    case viewDidAppear
    case searchChanged(query : String)
    case searchTapped(query : String)
    case pageFinished
}
