//
//  FlickrPhotoTests.swift
//  FlickrDemoTests
//
//  Created by CH Kaan on 28/02/2023.
//

import XCTest
@testable import FlickrDemo

final class FlickrPhotoTests: XCTestCase {
    
    let cacheManager = CacheManager.shared

    func testDecode() throws {
        let json = """
        {
            "id": "kaanId",
            "owner": "kaanOwner",
            "secret": "kaanSecret",
            "server": "kaanServer",
            "title": "kaanTitle"
        }
        """
        let jsonData = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let photo = try decoder.decode(FlickrPhoto.self, from: jsonData)
        
        XCTAssertEqual(photo.id, "kaanId", "FlickrPhoto id decoding error")
        XCTAssertEqual(photo.owner, "kaanOwner", "FlickrPhoto owner decoding error")
        XCTAssertEqual(photo.secret, "kaanSecret", "FlickrPhoto secret decoding error")
        XCTAssertEqual(photo.server, "kaanServer", "FlickrPhoto server decoding error")
        XCTAssertEqual(photo.title, "kaanTitle", "FlickrPhoto title decoding error")
    }
        
    func testSmallSizePhotoUrl() throws {
        let photo = FlickrPhoto(id: "kaanId", owner: "kaanOwner", secret: "kaanSecret", server: "kaanServer", title: "kaanTitle")
        let smallSizeAbsoluteUrl = photo.smallSizePhotoUrl()?.absoluteString
        let expectedAbsoluteUrl = "https://live.staticflickr.com/kaanServer/kaanId_kaanSecret_t.jpg"
        XCTAssertEqual(smallSizeAbsoluteUrl, expectedAbsoluteUrl, "FlickrPhoto small size url building error")
    }
    
    func testBigSizePhotoUrl() throws {
        let photo = FlickrPhoto(id: "kaanId", owner: "kaanOwner", secret: "kaanSecret", server: "kaanServer", title: "kaanTitle")
        let bigSizeAbsoluteUrl = photo.bigSizePhotoUrl()?.absoluteString
        let expectedAbsoluteUrl = "https://live.staticflickr.com/kaanServer/kaanId_kaanSecret_b.jpg"
        XCTAssertEqual(bigSizeAbsoluteUrl, expectedAbsoluteUrl, "FlickrPhoto big size url building error")
    }

}
