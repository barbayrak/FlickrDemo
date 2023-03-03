//
//  PhotoListViewModelTests.swift
//  FlickrDemoTests
//
//  Created by CH Kaan on 03/03/2023.
//

import XCTest
import Combine
@testable import FlickrDemo

final class PhotoListViewModelTests: XCTestCase {
    
    let viewModel = PhotoListViewModel()
    let flickrService = FlickrPhotoService()
    var inputEvents = PassthroughSubject<PhotoListViewModelInput,Never>()
    var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
        Configurations.FlickrAPI.apiKey = "1508443e49213ff84d566777dc211f2a"
        viewModel.removeAllQueries()
    }
    
    func testWithEmptyQuery() throws {
        let expectation = self.expectation(description: "Test with empty query expectation")
        expectation.assertForOverFulfill = false
        var outputEvents = [PhotoListViewModelOutput]()
        
        viewModel.transform(input: self.inputEvents.eraseToAnyPublisher())
            .sink { output in
                outputEvents.append(output)
                switch(output){
                case .showSearchQuery:
                    XCTFail("Empty Search query should not result with showing searchQueries")
                case .showQueryHistory:
                    expectation.fulfill()
                case .searchQueryFailed(let error):
                    XCTFail("Empty Search query should not result with error : " + error.localizedDescription)
                }
            }
            .store(in: &cancellables)
        
        inputEvents.send(.searchChanged(query: ""))
        
        waitForExpectations(timeout: 3.0)
        XCTAssertEqual(outputEvents.count, 1 , "Should receive 1 event")
    }
    
    func testSearchShortQuery() throws {
        let expectation = self.expectation(description: "Test with short query expectation")
        expectation.assertForOverFulfill = false
        var outputEvents = [PhotoListViewModelOutput]()
        
        viewModel.transform(input: self.inputEvents.eraseToAnyPublisher())
            .sink { output in
                outputEvents.append(output)
                switch(output){
                case .showSearchQuery:
                    XCTFail("Short Search query should not result with showing old search queries")
                case .showQueryHistory:
                    expectation.fulfill()
                case .searchQueryFailed(let error):
                    XCTFail("Short Search query should not result with error : " + error.localizedDescription)
                }
            }
            .store(in: &cancellables)
        
        inputEvents.send(.searchChanged(query: "t"))
        
        waitForExpectations(timeout: 3.0)
        XCTAssertEqual(outputEvents.count, 1 , "Should receive 1 event")
    }
    
    func testWithValidQuery() throws {
        let expectation = self.expectation(description: "Test with valid query expectation")
        expectation.assertForOverFulfill = false
        var outputEvents = [PhotoListViewModelOutput]()
        
        viewModel.transform(input: self.inputEvents.eraseToAnyPublisher())
            .sink { output in
                outputEvents.append(output)
                switch(output){
                case .showSearchQuery:
                    expectation.fulfill()
                case .showQueryHistory:
                    XCTFail("Valid Search query should not result with showing old search queries")
                case .searchQueryFailed(let error):
                    XCTFail("Valid Search query should not result with error : " + error.localizedDescription)
                }
            }
            .store(in: &cancellables)
        
        inputEvents.send(.searchChanged(query: "glasses"))
        
        waitForExpectations(timeout: 3.0)
        XCTAssertEqual(outputEvents.count, 1 , "Should receive 1 event")
        XCTAssertGreaterThan(viewModel.photos.count, 0)
    }
    
    func testWithInvalidQuery() throws {
        let expectation = self.expectation(description: "Test with invalid query expectation")
        expectation.assertForOverFulfill = false
        var outputEvents = [PhotoListViewModelOutput]()
        
        viewModel.transform(input: self.inputEvents.eraseToAnyPublisher())
            .sink { output in
                outputEvents.append(output)
                switch(output){
                case .showSearchQuery:
                    expectation.fulfill()
                case .showQueryHistory:
                    XCTFail("Invalid Search query should not result with showing old search queries")
                case .searchQueryFailed(let error):
                    XCTFail("Invalid Search query should not result with error : " + error.localizedDescription)
                }
            }
            .store(in: &cancellables)
        
        inputEvents.send(.searchChanged(query: "!!!test-too  long-query-should   result-with-empty!!"))
        
        waitForExpectations(timeout: 3.0)
        XCTAssertEqual(outputEvents.count, 1 , "Should receive 1 event")
        XCTAssertEqual(viewModel.photos.count, 0)
    }
    
    func testSearchingOldQueries() throws {
        let expectation = self.expectation(description: "Test with previous query expectation")
        expectation.assertForOverFulfill = false
        var outputEvents = [PhotoListViewModelOutput]()
        
        viewModel.transform(input: self.inputEvents.eraseToAnyPublisher())
            .sink { output in
                outputEvents.append(output)
                switch(output){
                case .showSearchQuery:
                    expectation.fulfill()
                case .showQueryHistory:
                    XCTFail("Old Search query should not result with showing old search queries")
                case .searchQueryFailed(let error):
                    XCTFail("Old Search query should not result with error : " + error.localizedDescription)
                }
            }
            .store(in: &cancellables)
        
        inputEvents.send(.searchTapped(query: "test"))
        
        waitForExpectations(timeout: 3.0)
        XCTAssertEqual(outputEvents.count, 1 , "Should receive 1 event")
        XCTAssertGreaterThan(viewModel.photos.count, 0)
    }

    func testGetAnotherPage() throws {
        let expectation = self.expectation(description: "Test with valid query expectation")
        expectation.assertForOverFulfill = false
        var outputEvents = [PhotoListViewModelOutput]()
        
        viewModel.searchQuery = "kitten"
        viewModel.currentPage = 1
        viewModel.totalPage = 5
        viewModel.transform(input: self.inputEvents.eraseToAnyPublisher())
            .sink { output in
                outputEvents.append(output)
                switch(output){
                case .showSearchQuery:
                    expectation.fulfill()
                case .showQueryHistory:
                    XCTFail("Get next page of query should not result with showing old search queries")
                case .searchQueryFailed(let error):
                    XCTFail("Get next page of query should not result with error : " + error.localizedDescription)
                }
            }
            .store(in: &cancellables)
        
        inputEvents.send(.pageFinished)
        
        waitForExpectations(timeout: 3.0)
        XCTAssertEqual(outputEvents.count, 1 , "Should receive 1 event")
        XCTAssertGreaterThan(viewModel.photos.count, 0)
    }
    
    func testAddingQueryToOldQueries() throws {
        viewModel.addSearchQueryIfNotExists(query: "test")
        let oldQueries = viewModel.previousSearchQueries
        XCTAssert(oldQueries.contains("test"),"Previous search queries should contain new query")
    }
    
    func testGetOldSearchQueries() throws {
        let firstQuery = "test"
        let secondQuery = "kaan"
        viewModel.addSearchQueryIfNotExists(query: firstQuery)
        viewModel.addSearchQueryIfNotExists(query: secondQuery)
        let oldQueries = viewModel.previousSearchQueries
        XCTAssert(oldQueries.contains(firstQuery),"Previous search queries should contain 'test' query")
        XCTAssert(oldQueries.contains(secondQuery),"Previous search queries should contain 'kaan' query")
        XCTAssertEqual(oldQueries.count,2,"Previous search queries should be equal to 2")
    }
    
    func testRemoveOldQueries() throws {
        viewModel.addSearchQueryIfNotExists(query: "test")
        viewModel.addSearchQueryIfNotExists(query: "kaan")
        viewModel.removeAllQueries()
        let oldQueries = viewModel.previousSearchQueries
        XCTAssertEqual(oldQueries.count,0,"Previous search queries should be equal to zero")
    }

}
