//
//  ImageServiceTests.swift
//  FlickrDemoTests
//
//  Created by CH Kaan on 28/02/2023.
//

import XCTest
import Combine
import UIKit
@testable import FlickrDemo

final class ImageServiceTests: XCTestCase {
    
    let cacheManager = CacheManager.shared
    let service = ImageService()
    
    var cancellables = Set<AnyCancellable>()

    override func setUp() {
        cancellables = Set<AnyCancellable>()
        CacheManager.shared.purgeCache()
    }

    func testGetImageFromUrl() throws {
        let expectation = self.expectation(description: "Test get image from url finished")
        let testUrl = URL(string: "https://picsum.photos/200/300")
        service.getImageFromUrl(url: testUrl!).sink { completion in
            switch(completion){
            case .finished:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Image results failed with error \(error.localizedDescription)")
            }
        } receiveValue: { image in
            XCTAssertNotNil(image)
            let byteSize = image?.jpegData(compressionQuality: 1.0)?.count ?? 0
            XCTAssertGreaterThan(byteSize, 0, "Image size should not be 0")
        }.store(in: &cancellables)
        waitForExpectations(timeout: 5.0)
    }
    
    func testInvalidImageUrl() throws {
        let expectation = self.expectation(description: "Test invalid image from url finished")
        let testUrl = URL(string: "https://testwrongimage.com/testwrong")
        service.getImageFromUrl(url: testUrl!).sink { completion in
            switch(completion){
            case .finished:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Image results failed with error \(error.localizedDescription)")
            }
        } receiveValue: { [weak self] image in
            XCTAssertNil(image)
            let cachedData : Data? = self?.cacheManager.getObject(key: testUrl!.absoluteString)
            XCTAssertNil(cachedData, "Image should not be cached if its empty")
        }.store(in: &cancellables)
        waitForExpectations(timeout: 5.0)
    }
    
    func testCachedImage() throws {
        let expectation = self.expectation(description: "Test invalid image from url finished")
        let testUrl = URL(string: "https://someurl.com/testurl")
        cacheManager.putObject(object: UIImage(named: "test")?.pngData(), key: testUrl!.absoluteString)
        service.getImageFromUrl(url: testUrl!).sink { completion in
            switch(completion){
            case .finished:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Image results failed with error \(error.localizedDescription)")
            }
        } receiveValue: { image in
            XCTAssertNotNil(image)
            let byteSize = image?.jpegData(compressionQuality: 1.0)?.count ?? 0
            XCTAssertGreaterThan(byteSize, 0, "Cached image size should not be 0")
        }.store(in: &cancellables)
        waitForExpectations(timeout: 5.0)
    }

}
