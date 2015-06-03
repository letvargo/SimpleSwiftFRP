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

public class Behavior<T>: Listener, Whisperer {

    typealias Value = T
    
    private let syncQueue =
        dispatch_queue_create(
              "com.letvargo.SyncCellQueue"
            , DISPATCH_QUEUE_SERIAL )
    
    private func synchronized(f: () -> ()) {
        dispatch_sync(syncQueue, f)
    }
    
    public var value: Value {
        get {
            dispatch_group_wait(
                  Up.notificationGroup
                , DISPATCH_TIME_FOREVER  )
            
            var v: T? = nil
            synchronized {
                v = self.at(now())
            }
            return v ?? events[0].f(now())
        }
    }
    
    private var listeners = ObserverSet<Command>()
    
    private var events: [Event<T>] = []
    
    private var count = 1
    
    private var addNewEvent: Time -> Bool = { _ in return true }
    
    public init(_ value: T) {
        self.events = [Event(value)]
    }
    
    public init(_ f: Time -> T) {
        self.events = [Event(f)]
    }
    
    func eventAt(time: Time) -> Event<T> {
            
        var i = self.count - 1
        while i > 0 {
            let e = self.events[i]
            if e.time <= time {
                return e
            } else {
                --i
            }
        }
        return self.events[0]
    }
    
    func at(time: Time) -> Value {
        return eventAt(time).f(time)
    }
    
    func appendEvent(event: Event<T>) {
        synchronized {
            self.events.append(event)
            self.count = self.count + 1
        }
    }
    
    func setAddNewEvent(f: Time -> Bool) -> Behavior<T> {
        self.addNewEvent = f
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
    
    func didReceiveCommand(command: Command) {
        switch command {
        case .NewEvent(let time):
            if addNewEvent(time) {
                listeners.notify(.NewEvent(time))
            }
        }
    }
    
    func addListener(listener: Listener) {
        listeners.add { listener.didReceiveCommand($0) }
    }
}