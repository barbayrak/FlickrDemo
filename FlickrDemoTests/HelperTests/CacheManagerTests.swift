//
//  CacheManagerUnitTests.swift
//  FlickrDemoTests
//
//  Created by CH Kaan on 28/02/2023.
//

import XCTest
@testable import FlickrDemo

final class CacheManagerTests: XCTestCase {
    
    let cacheManager = CacheManager.shared
    
    func testGetObject() throws {
        let testObject = Data([0x12,0x06,0x08])
        let key = "testGetObject"
        cacheManager.putObject(object: testObject, key: key)
        let resultObject: Data? = cacheManager.getObject(key: key)
        XCTAssertEqual(resultObject, testObject, "Get object in cache test result in error")
    }
    
    func testPutObject() throws {
        let testObject = Data([0x12,0x06,0x08])
        let key = "testPutObject"
        cacheManager.putObject(object: testObject, key: key)
        let resultObject: Data? = cacheManager.getObject(key: key)
        XCTAssertEqual(resultObject, testObject, "Put object in cache test result in error")
    }
    
    func testPurgeCache() throws {
        let firstTestObject = Data([0x12,0x06,0x08])
        let secondTestObject = Data([0x12,0x06,0x08])
        let firstObjectKey = "testPutObject"
        let secondObjectKey = "testPutObject2"
        cacheManager.putObject(object: firstTestObject, key: firstObjectKey)
        cacheManager.putObject(object: secondTestObject, key: secondObjectKey)
        cacheManager.purgeCache()
        let firstResultObject : Data? = cacheManager.getObject(key: firstObjectKey)
        let secondResultObject : Data? = cacheManager.getObject(key: secondObjectKey)
        XCTAssertNil(firstResultObject, "Purge cache test failed in first object")
        XCTAssertNil(secondResultObject, "Purge cache test failed in second object")
    }
    
    func testMemoryWarningPurgeCache() throws {
        let firstTestObject = Data([0x12,0x06,0x08])
        let secondTestObject = Data([0x12,0x06,0x08])
        let firstObjectKey = "testPutObject"
        let secondObjectKey = "testPutObject2"
        cacheManager.putObject(object: firstTestObject, key: firstObjectKey)
        cacheManager.putObject(object: secondTestObject, key: secondObjectKey)
        
        NotificationCenter.default.post(Notification(name: UIApplication.didReceiveMemoryWarningNotification))
        
        let firstResultObject : Data? = cacheManager.getObject(key: firstObjectKey)
        let secondResultObject : Data? = cacheManager.getObject(key: secondObjectKey)
        XCTAssertNil(firstResultObject, "Purge cache test failed in first object")
        XCTAssertNil(secondResultObject, "Purge cache test failed in second object")
    }

}
