//
//  Cache.swift
//  TMDBTableView
//
//  Created by qbuser on 13/10/22.
//

import Foundation

// Based on https://www.swiftbysundell.com/articles/caching-in-swift/

/*
 Cache is generic over any Hashable key type.
 A date producing function is injected as a dependency as part of our initializer for invalidating stale data.
 We’ll also add an entryLifetime property, with a default value of 12 hours
 */
final class NSCacher<Key: Hashable, Value> {
    private let wrapped = NSCache<WrappedKey, Entry>()
    private let dateProvider: () -> Date
    private let entryLifetime: TimeInterval
    private let keyTracker = KeyTracker()
    
    init(dateProvider: @escaping () -> Date = Date.init,
         entryLifetime: TimeInterval =  60 * 60,  maximumEntryCount: Int = 60) {
        self.dateProvider = dateProvider
        self.entryLifetime = entryLifetime
        wrapped.countLimit = maximumEntryCount
        wrapped.delegate = keyTracker
    }
    
    func insert(_ value: Value, forKey key: Key) {
        // Adds the expiration time interval to the current initialized time.
        let date = dateProvider().addingTimeInterval(entryLifetime)
        let entry = Entry(key: key, value: value, expirationDate: date)
        wrapped.setObject(entry, forKey: WrappedKey(key))
        keyTracker.keys.insert(key)
    }
    
    func value(forKey key: Key) -> Value? {
        guard let entry = wrapped.object(forKey: WrappedKey(key)) else {
            return nil
        }
        
        // Checks whether the entry is still in  its expirationDate or not and if it is not the entry is removed from the cache.
        guard dateProvider() < entry.expirationDate else {
            // Discard values that have expired
            removeValue(forKey: key)
            return nil
        }
        
        return entry.value
    }
    
    func removeValue(forKey key: Key) {
        wrapped.removeObject(forKey: WrappedKey(key))
    }
    
    func clear() {
        keyTracker.keys.forEach { removeValue(forKey: $0) }
    }
    
    deinit {
        print("NSCacher is deinitialized")
    }
}

// MARK: - WrappedKey
/*
 Wrapped key wraps our public facing Key.
 In order to make them NSCache compatible we subclass NSObject and implement hash and isEqual methods.
 Since that’s what Objective-C uses to determine whether two instances are equal
 */
extension NSCacher {
    final class WrappedKey: NSObject {
        let key: Key
        
        init(_ key: Key) {
            self.key = key
        }
        
        override var hash: Int { return key.hashValue }
        
        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else {
                return false
            }
            return value.key == key
        }
    }
}

// MARK: - Entry
/*
 When it comes to Entry type, the only requirement is that it needs to be a class
 (it doesn’t need to subclass NSObject), which means that we can simply make it store a Value instance.
 Here to avoid stale data we provide an exporationDate for the Entry class, to be able to keep track of the remaining lifetime for each entry.
 For Data persistence which can be an optional feature we have also added the key for which the entry is created,
 So that we’ll both be able to persist each entry directly, and to be able to remove unused keys
 */
private extension NSCacher {
    final class Entry {
        let key: Key
        let value: Value
        let expirationDate: Date
        
        init(key: Key, value: Value, expirationDate: Date) {
            self.key = key
            self.value = value
            self.expirationDate = expirationDate
        }
    }
}

// MARK: - Subscript
extension NSCacher {
    subscript(key: Key) -> Value? {
        get { return value(forKey: key) }
        set {
            guard let value = newValue else {
                // If nil was assigned using our subscript,
                // then we remove any value for that key:
                removeValue(forKey: key)
                return
            }
            
            insert(value, forKey: key)
        }
    }
}

//MARK: - Key Tracker
/*
 To keep track of what keys that our cache contains entries for which are inserted and removed, since NSCache doesn’t expose that information.
 For that we’ll add a dedicated KeyTracker type, which will become the delegate of our underlying NSCache,
 in order to get notified whenever an entry was removed.
 */
private extension NSCacher {
    final class KeyTracker: NSObject, NSCacheDelegate {
        var keys = Set<Key>()
        
        func cache(_ cache: NSCache<AnyObject, AnyObject>,
                   willEvictObject object: Any) {
            guard let entry = object as? Entry else {
                return
            }
            keys.remove(entry.key)
        }
    }
}
