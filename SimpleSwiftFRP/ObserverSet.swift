//
//  ObserverSet.swift
//  SwiftFRP
//
//  Created by letvargo on 2/8/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

// This code is from Mike Ash's excellent blog post "Let's Build Swift Notifications"
// which can be found at https://mikeash.com/pyblog/friday-qa-2015-01-23-lets-build-swift-notifications.html
// It is amazingly useful.

import Foundation

public class ObserverSetEntry<Parameters> {
    
    private weak var object: AnyObject?
    private let f: AnyObject -> Parameters -> Void
    
    private init(object: AnyObject, _ f: AnyObject -> Parameters -> Void) {
        self.object = object
        self.f = f
    }
}

public class ObserverSet<Parameters> {
    
    private let queue = dispatch_queue_create("com.letvargo.ObserverSet", nil)
    private var entries: [ObserverSetEntry<Parameters>] = []
    
    public init() { }
    
    private func synchronized(f: Void -> Void) {
        dispatch_sync(queue, f)
    }
    
    public func add<T: AnyObject>(object: T, _ f: T -> Parameters -> Void) -> ObserverSetEntry<Parameters> {
        let entry = ObserverSetEntry<Parameters>(object: object, { f($0 as! T) })
        synchronized { self.entries.append(entry) }
        return entry
    }
    
    public func add(f: Parameters -> Void) -> ObserverSetEntry<Parameters> {
        return self.add(self, { ignored in f })
    }
    
    public func remove(entry: ObserverSetEntry<Parameters>) {
        synchronized {
            self.entries = self.entries.filter { $0 !== entry }
        }
    }
    
    public func notify(parameters: Parameters) {
        var toCall: [Parameters -> Void] = []
        synchronized {
            self.entries.reduce(()) {
                if let obj: AnyObject = $1.object {
                    toCall.append($1.f(obj))
                }
            }
            self.entries = self.entries.filter { $0 != nil }
        }
        toCall.reduce(()) { $1(parameters) }
    }
}