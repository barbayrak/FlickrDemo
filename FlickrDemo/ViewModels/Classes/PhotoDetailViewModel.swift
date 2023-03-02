//
//  PhotoDetailViewModel.swift
//  FlickrDemo
//
//  Created by CH Kaan on 02/03/2023.
//

import Foundation
import Combine


class PhotoDetailViewModel : ObservableObject {

    @Published var photo : FlickrPhoto = FlickrPhoto(id: "", owner: "", secret: "", server: "", title: "")
    
    func setPhoto(photo : FlickrPhoto){
        self.photo = photo
    }

    
}
