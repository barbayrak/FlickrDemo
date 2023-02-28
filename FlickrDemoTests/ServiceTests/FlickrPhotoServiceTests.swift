//
//  FlickrPhotoServiceTests.swift
//  FlickrDemoTests
//
//  Created by CH Kaan on 28/02/2023.
//

import XCTest
import Combine
@testable import FlickrDemo

final class FlickrPhotoServiceTests: XCTestCase {
    
    let service = FlickrPhotoService()
    var cancellables = Set<AnyCancellable>()

    override func setUp() {
        cancellables = Set<AnyCancellable>()
        Configurations.FlickrAPI.apiKey = "1508443e49213ff84d566777dc211f2a"
    }

    func testGetSearchResults() throws {
        let textQuery = "bird"
        let expectation = self.expectation(description: "Search result finished")
        service.getSearchResults(query: textQuery).sink { completion in
            switch(completion){
            case .finished:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Flickr Search results failed with error \(error.localizedDescription)")
            }
        } receiveValue: { photos in
            XCTAssertGreaterThan(photos.count, 0, "Search Results should not be empty")
        }.store(in: &cancellables)
        waitForExpectations(timeout: 5.0)
    }
    
    func testGetEmptySearchResults() throws {
        let textQuery = "somethingthatresultswithzero!!!"
        let expectation = self.expectation(description: "Search result get empty results finished")
        service.getSearchResults(query: textQuery).sink { completion in
            switch(completion){
            case .finished:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Flickr Search results failed with error \(error.localizedDescription)")
            }
        } receiveValue: { photos in
            XCTAssertEqual(photos.count, 0, "Search Results should be empty")
        }.store(in: &cancellables)
        waitForExpectations(timeout: 5.0)
    }
    
    func testGetInvalidApiKey() throws {
        Configurations.FlickrAPI.apiKey = "wrongapikey"
        let textQuery = "bird"
        let expectation = self.expectation(description: "Search result get invalid api key finished")
        service.getSearchResults(query: textQuery).sink { completion in
            switch(completion){
            case .finished:
                expectation.fulfill()
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription,APIError.invalidApiKey.localizedDescription, "Wrong error type")
                expectation.fulfill()
            }
        } receiveValue: { photos in
            XCTFail("Flickr Search results should not receive response with wront api key ")
        }.store(in: &cancellables)
        waitForExpectations(timeout: 55.0)
    }

}
