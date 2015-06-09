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

final public class Source<T>: Whisperer {

    var nextEvent: (Time -> T)? {
        return self._nextEvent
    }
    
    private var listeners = ObserverSet<Time>()
    private var _nextEvent: (Time -> T)?
    
    public init() { }
    
    func setNextEvent(nextEvent: Time -> T) -> Source<T> {
        _nextEvent = nextEvent
        return self
    }
    
    func notify(t: Time) -> Source<T> {
        self.listeners.notify(t)
        return self
    }
    
    func addListener(listener: Listener) {
        listeners.add { listener.receiveNotification($0) }
    }
}