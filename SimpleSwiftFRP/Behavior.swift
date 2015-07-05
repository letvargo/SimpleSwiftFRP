//
//  Behavior.swift
//  SimpleSwiftFRP
//
//  Created by letvargo on 2/20/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

prefix operator ^ { }

public prefix func ^<T>(value: T) -> Behavior<T> {
    return Behavior(value)
}

final public class Behavior<T>: Listener, Whisperer {
    
    private func synchronized(f: () -> ()) {
        dispatch_sync(Up.notificationQueue, f)
    }
    
    public var value: T {
        get {
            var v: T? = nil
            synchronized {
                let t = now()
                v = self.eventAt(t).f(t)
            }
            return v ?? events[0].f(now())
        }
    }

    private var listeners = ObserverSet<Time>()
    private var events: [Event<T>] = []
    private var count = 1
    private var addNewEvent: Time -> Bool = { _ in return true }
    
    public init(_ value: T) {
        events = [Event(value)]
    }
    
    public init(_ f: Time -> T) {
        events = [Event(f)]
    }
    
    func eventAt(t: Time) -> Event<T> {
            
        var i = count - 1
        while i > 0 {
            let e = events[i]
            if e.time <= t {
                return e
            } else {
                --i
            }
        }
        return events[0]
    }
    
    public func at(t: Time) -> T {
        var v: T? = nil
        synchronized {
            v = self.eventAt(t).f(t)
        }
        return v ?? events[0].f(t)
    }
    
    func f(t: Time) -> T {
        return eventAt(t).f(t)
    }
    
    func appendEvent(event: Event<T>) {
        events.append(event)
        count = count + 1
    }
    
    func setAddNewEvent(f: Time -> Bool) -> Behavior<T> {
        addNewEvent = f
        return self
    }
    
    func setFirstEvent(event: Event<T>) -> Behavior<T> {
        events = [event]
        return self
    }

    func listenTo(whisperer: Whisperer) -> Behavior<T> {
        whisperer.addListener(self)
        return self
    }
    
    func receiveNotification(t: Time) {
        if addNewEvent(t) {
            listeners.notify(t)
        }
    }
    
    func addListener(listener: Listener) {
        listeners.add { listener.receiveNotification($0) }
    }
}