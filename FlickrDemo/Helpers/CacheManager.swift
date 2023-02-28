//
//  CacheManager.swift
//  FlickrDemo
//
//  Created by CH Kaan on 27/02/2023.
//

import Foundation
import UIKit
import Combine

class CacheManager {
    
    static let shared = CacheManager()
    
    var cancellables = Set<AnyCancellable>()
    
    // 50Mb local cache
    private let cache : NSCache<NSString,AnyObject> = {
        let cache = NSCache<NSString,AnyObject>()
        cache.countLimit = Configurations.Cache.countLimit
        cache.totalCostLimit = Configurations.Cache.memoryLimit
        return cache
    }()
    
    //For thread safety
    private let lock = NSLock()
    
    // In case we receive memory warning purge cache to free up space
    private init(){
        let notification = UIApplication.didReceiveMemoryWarningNotification
        NotificationCenter.default.publisher(for: notification).sink { [weak self] _ in
            self?.purgeCache()
        }.store(in: &cancellables)
    }
    
    func getObject<T>(key : String) -> T? {
        lock.lock()
        let resultObject = cache.object(forKey: key as NSString) as? T
        lock.unlock()
        return resultObject
    }
    
    func putObject<T>(object : T, key : String) {
        lock.lock()
        cache.setObject(object as AnyObject , forKey: key as NSString)
        lock.unlock()
    }
    
    func purgeCache(){
        lock.lock()
        cache.removeAllObjects()
        lock.unlock()
    }
    
}
