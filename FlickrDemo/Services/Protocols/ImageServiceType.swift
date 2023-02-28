//
//  ImageServiceType.swift
//  FlickrDemo
//
//  Created by CH Kaan on 27/02/2023.
//

import Foundation
import UIKit
import Combine

protocol ImageServiceType {
    func getImageFromUrl(url : URL) -> AnyPublisher<UIImage?,Never>
}
