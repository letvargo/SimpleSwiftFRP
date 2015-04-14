//
//  Stream.swift
//  SimpleSwiftFRP
//
//  Created by developer on 2/19/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

import Foundation

public class Stream<T> {
    
    let notificationQueue = dispatch_queue_create("com.letvargo.NotificationQueue", DISPATCH_QUEUE_SERIAL)
    
    func send_async(f: () -> ()) {
        dispatch_async(notificationQueue, f)
    }
    
    func send_sync(f: () -> ()) {
        dispatch_sync(notificationQueue, f)
    }
    
    var f: () -> Result<T> = { .Failure }
    var sources: [Whisperer] = []
    
    public init() { }
    
    init<S>(stream: Stream<S>, g: S -> T) {
        self.sources = stream.sources
        self.f = { [unowned stream] in
            stream.f() >< { g($0) }
        }
    }
    
    init(stream: Stream<T>, g: T -> Bool) {
        self.sources = stream.sources
        self.f = { [unowned stream] in
            stream.f() >|< { g($0) }
        }
    }
    
    init(optionalStream: Stream<T?>) {
        self.sources = optionalStream.sources
        self.f = { [unowned optionalStream] in
            optionalStream.f()>!<
        }
    }
    
    public func map<U>(g: T -> U) -> Stream<U> {
        return Stream<U>(stream: self, g: g)
    }
    
    public func filter(g: T -> Bool) -> Stream<T> {
        return Stream<T>(stream: self, g: g)
    }
    
    public func filterNilFrom(optionalStream: Stream<T?>) -> Stream<T> {
        self.sources = optionalStream.sources
        self.f = { [unowned optionalStream] in
            optionalStream.f()>!<
        }
        return self
    }
    
    public func lift<U>(initialValue: U, f: T -> U) -> Cell<U> {
        return Cell(initialValue: initialValue).liftedFromOne(self, f: f)
    }
    
    public func liftWithCapacity<U>(initialValue: U, capacity: Int, f: T -> U) -> Cell<U> {
        return Cell(initialValue: initialValue, limit: capacity).liftedFromOne(self, f: f)
    }
    
    public class func merge<T, U>(streams: [Stream<T>], initialValue: U, f: T -> U) -> Cell<U> {
        return Cell(initialValue: initialValue).mergedFrom(streams, f: f)
    }
    
    public class func mergeWithCapacity<T, U>(streams: [Stream<T>], initialValue: U, capacity: Int, f: T -> U) -> Cell<U> {
        return Cell(initialValue: initialValue, limit: capacity).mergedFrom(streams, f: f)
    }
    
    func mapTo<U>(stream: Stream<U>, f: T -> U) -> Stream<U> {
        stream.sources = self.sources
        stream.f = { [unowned self] in
            self.f() >< { f($0) }
        }
        return stream
    }
    
    func filterTo(stream: Stream<T>, f: T -> Bool) -> Stream<T> {
        stream.sources = self.sources
        stream.f = { [unowned self] in
            self.f() >|< { f($0) }
        }
        return stream
    }
    
    func reduceSources(sources: [[Whisperer]]) -> [Whisperer] {
        return sources.reduce([Whisperer]()) { $0 + $1 }.reduce([Whisperer]()) { array, item in
            return array.filter({ i in i === item }).count == 0
                ? array + [item]
                : array
        }
    }
}