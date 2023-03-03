//
//  PhotoDetailViewModelTests.swift
//  FlickrDemoTests
//
//  Created by CH Kaan on 03/03/2023.
//

import XCTest
import Combine
@testable import FlickrDemo

final class PhotoDetailViewModelTests: XCTestCase {
    
    let viewModel = PhotoDetailViewModel()

    func testPhoto() throws {
        let mockPhoto = FlickrPhoto(id: "testId", owner: "testOwner", secret: "testSecret", server: "testServer", title: "testTitle")
        viewModel.setPhoto(photo: mockPhoto)
    
        XCTAssertEqual(viewModel.photo.id, mockPhoto.id)
        XCTAssertEqual(viewModel.photo.owner, mockPhoto.owner)
        XCTAssertEqual(viewModel.photo.secret, mockPhoto.secret)
        XCTAssertEqual(viewModel.photo.server, mockPhoto.server)
        XCTAssertEqual(viewModel.photo.title, mockPhoto.title)
    }

}
