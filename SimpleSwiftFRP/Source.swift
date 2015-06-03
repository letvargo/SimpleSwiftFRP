//
//  Source.swift
//  SimpleSwiftFRP
//
//  Created by letvargo on 2/20/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

public func src<T>(t: T.Type) -> Source<T> {
    return Source<T>()
}

public class Source<T>: Whisperer {
    
    private let syncQueue = dispatch_queue_create("com.letvargo.SyncSourceQueue", DISPATCH_QUEUE_SERIAL)
    
    private func synchronized(f: () -> ()) {
        dispatch_sync(syncQueue, f)
    }

    var nextEvent: (Time -> T)? {
        return self._nextEvent
    }
    
    private var listeners: ObserverSet<Command> = ObserverSet<Command>()
    private var _nextEvent: (Time -> T)?
    
    public init() { }
    
    func setNextEvent(nextEvent: Time -> T) -> Source<T> {
        synchronized {
            self._nextEvent = nextEvent
        }
        return self
    }
    
    func notify(t: Time) -> Source<T> {
        self.listeners.notify(.NewEvent(t))
        return self
    }
    
    func addListener(listener: Listener) {
        listeners.add { listener.didReceiveCommand($0) }
    }
}