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
public class Source<T>: Stream<T>, Whisperer {
    
    private let syncQueue = dispatch_queue_create("com.letvargo.SyncSourceQueue", DISPATCH_QUEUE_SERIAL)
    
    private func synchronized(f: () -> ()) {
        dispatch_sync(syncQueue, f)
    }
    
    var listeners: ObserverSet<Command> = ObserverSet<Command>()
    
    public override init() {
        super.init()
        self.sources = [self]
    }

    public func send(value: T) {
        send_async {
            let time = now()
            self.synchronized { [unowned self] in
                self.f = { >|value }
            }
            self.listeners.notify(.NewEvent(time))
        }
    }
    
    public func send(value: T, callback: () -> ()) {
        self.send(value)
        callback()
    }
    
    func addListener(listener: Listener) {
        self.listeners.add { listener.didReceiveCommand($0) }
    }
}