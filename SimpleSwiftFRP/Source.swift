//
//  Source.swift
//  SimpleSwiftFRP
//
//  Created by developer on 2/20/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

import Foundation

/// A subclass of Stream that is capable of emitting values into
/// the event stream and notifying its listeners that they need to
/// update their stored values accordingly.
public class Source<T>: Whisperer {
    
    private let syncQueue = dispatch_queue_create("com.letvargo.SyncSourceQueue", DISPATCH_QUEUE_SERIAL)
    
    private func synchronized(f: () -> ()) {
        dispatch_sync(syncQueue, f)
    }
    
    private func send_async(f: () -> ()) {
        dispatch_async(notificationQueue, f)
    }
    
    private var listeners: ObserverSet<Command> = ObserverSet<Command>()
    private var _f: () -> Result<T> = { _ in .Failure }
    
    public init() { }

    public func send(value: T) -> Source<T> {
        send_async {
            let time = now()
            self.synchronized { [unowned self] in
                self._f = { >|value }
            }
            self.listeners.notify(.NewEvent(time))
        }
        return self
    }
    
    public func send_main(value: T) {
        dispatch_async(dispatch_get_main_queue()) {
            let time = now()
            self.synchronized { [unowned self] in
                self._f = { >|value }
            }
            self.listeners.notify(.NewEvent(time))
        }
    }
    
    public func send(value: T, callback: () -> ()) -> Source<T> {
        send(value)
        callback()
        return self
    }
    
    func addListener(listener: Listener) {
        listeners.add { listener.didReceiveCommand($0) }
    }
    
    func f() -> Result<T> {
        return _f()
    }
}