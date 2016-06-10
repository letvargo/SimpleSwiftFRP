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

public class ObserverSetEntry<Parameters> {
    
    private weak var object: AnyObject?
    private let f: (AnyObject) -> (Parameters) -> Void
    
    private init(object: AnyObject, _ f: (AnyObject) -> (Parameters) -> Void) {
        self.object = object
        self.f = f
    } 
}

public class ObserverSet<Parameters> {
    
    private let queue: dispatch_queue_t = dispatch_queue_create("com.letvargo.ObserverSet", nil)
    private var entries: [ObserverSetEntry<Parameters>] = []
    
    public init() { }
    
    private func synchronized(f: (Void) -> Void) {
        dispatch_sync(queue, f)
    }
    
    public func add<T: AnyObject>(object: T, _ f: (T) -> (Parameters) -> Void) -> ObserverSetEntry<Parameters> {
        let entry = ObserverSetEntry<Parameters>(object: object, { f($0 as! T) })
        synchronized { self.entries.append(entry) }
        return entry
    }
    
    public func add(f: (Parameters) -> Void) -> ObserverSetEntry<Parameters> {
        return self.add(object: self, { ignored in f })
    }
    
    public func remove(entry: ObserverSetEntry<Parameters>) {
        synchronized {
            self.entries = self.entries.filter { $0 !== entry }
        }
    }
    
    public func notify(parameters: Parameters) {
        var toCall: [(Parameters) -> Void] = []
        synchronized {
            self.entries.forEach {
                if let obj: AnyObject = $0.object {
                    toCall.append($0.f(obj))
                }
            }
            self.entries = self.entries.filter { $0 != nil }
        }
        
        toCall.forEach { $0(parameters) }
    }
    
    public func merge(observerSet: ObserverSet<Parameters>) -> ObserverSet<Parameters> {
    
        observerSet.entries.forEach { otherEntry in
        
            if !self.entries.contains({ entry in
            
                    entry.object === otherEntry.object
                
                }) {
                self.entries.append(otherEntry)
            }
        }
        return self
    }
}