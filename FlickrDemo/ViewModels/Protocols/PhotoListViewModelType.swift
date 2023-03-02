//
//  PhotoListViewModelType.swift
//  FlickrDemo
//
//  Created by CH Kaan on 01/03/2023.
//

import Foundation
import Combine

protocol PhotoListViewModelType {
    func transform(input: AnyPublisher<PhotoListViewModelInput,Never>) -> AnyPublisher<PhotoListViewModelOutput,Never>
}
