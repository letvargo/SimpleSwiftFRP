//
//  Cell.swift
//  SimpleSwiftFRP
//
//  Created by developer on 2/20/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

import Foundation

public class Cell<T>: Stream<T>, Listener, Whisperer {
    
    typealias Event = (time: Time, value: T)
    
    private let syncQueue = dispatch_queue_create("com.letvargo.SyncCellQueue", DISPATCH_QUEUE_SERIAL)
    
    func synchronized(f: () -> ()) {
        dispatch_sync(syncQueue, f)
    }
    
    public var value: T {
        get {
            var v: T!
            send_sync { [unowned self] in
                v = self.valueAt(now())
            }
            return v
        }
    }
    
    public var valueAt: Time -> T {
        get {
            return { [unowned self] time in
                var result = self.events[0].value
                self.synchronized {
                    var i = self.count - 1
                    whileLoop: while i > 0 {
                        let event = self.events[i]
                        switch event.time <= time {
                        case true:
                            result = event.value
                            break whileLoop
                        default:
                            --i
                        }
                    }
                }
                return result
            }
        }
    }
    
    private var outlets = ObserverSet<Command>()
    private var events: [Event] = []
    private var count = 1
    private var limit: Int = Int.max
    
    var addNewEvent: Time -> () = { _ in return }
    
    public init(limit: Int = Int.max) {
        super.init()
        self.limit = limit
    }
    
    public convenience init(constant: T, limit: Int = Int.max) {
        self.init(limit: limit)
        self.events = [(Up.time, constant)]
        self.f = { [unowned self] in
            >|self.valueAt(Up.time)
        }
        self.sources = [self]
    }
    
    public convenience init(initialValue: T, limit: Int = Int.max) {
        self.init(constant: initialValue, limit: limit)
        self.sources = []
    }
    
    convenience init<S>(stream: Stream<S>, initialValue: T, limit: Int = Int.max, g f: S -> T) {
        self.init(initialValue: initialValue, limit: limit)
        self.liftedFromOne(stream, f: f)
    }
    
    func liftedFromOne<S>(stream: Stream<S>, f g: S -> T) -> Cell<T> {
        self.addNewEvent = { [unowned self, unowned stream] time in
            switch stream.f() {
            case .Success(let value):
                self.synchronized {
                    let value = g(value)
                    self.addEventWithCountCheck(time, value: value, count: self.count, limit: self.limit)
                }
            case .Failure:
                break
            }
        }
        return self.withSources([stream.sources])
    }
    
    func liftedFromTwo<C1, C2>(a: Cell<C1>, _ b: Cell<C2>, _ g: (C1, C2) -> T) -> Cell<T> {
        self.events = [(Up.time, g(a.valueAt(Up.time), b.valueAt(Up.time)))]
        self.addNewEvent = { [unowned self, unowned a, unowned b] time in
            self.synchronized {
                let value = g(a.valueAt(time), b.valueAt(time))
                self.addEventWithCountCheck(time, value: value, count: self.count, limit: self.limit)
            }
        }
        return self.withSources([a.sources, b.sources])
    }
    
    func liftedFromThree<C1, C2, C3>(a: Cell<C1>, _ b: Cell<C2>, _ c: Cell<C3>, _ g: (C1, C2, C3) -> T) -> Cell<T>{
        let vals = (a.valueAt(Up.time), b.valueAt(Up.time), c.valueAt(Up.time))
        self.events = [(Up.time, g(vals))]
        self.addNewEvent = { [unowned self, unowned a, unowned b, unowned c] time in
            self.synchronized {
                let value = g(a.valueAt(time), b.valueAt(time), c.valueAt(time))
                self.addEventWithCountCheck(time, value: value, count: self.count, limit: self.limit)
            }
        }
        return self.withSources([a.sources, b.sources, c.sources])
    }
    
    func liftedFromFour<C1, C2, C3, C4>(a: Cell<C1>, _ b: Cell<C2>, _ c: Cell<C3>, _ d: Cell<C4>, _ g: (C1, C2, C3, C4) -> T) -> Cell<T> {
        let vals = (a.valueAt(Up.time), b.valueAt(Up.time), c.valueAt(Up.time), d.valueAt(Up.time))
        self.events = [(Up.time, g(vals))]
        self.addNewEvent = { [unowned self, unowned a, unowned b, unowned c, unowned d] time in
            self.synchronized {
                let value = g(a.valueAt(time), b.valueAt(time), c.valueAt(time), d.valueAt(time))
                self.addEventWithCountCheck(time, value: value, count: self.count, limit: self.limit)
            }
        }
        return self.withSources([a.sources, b.sources, c.sources, d.sources])
    }
    
    func liftedFromFive<C1, C2, C3, C4, C5>(a: Cell<C1>, _ b: Cell<C2>, _ c: Cell<C3>, _ d: Cell<C4>, _ e: Cell<C5>, _ g: (C1, C2, C3, C4, C5) -> T) -> Cell<T> {
        let vals = (a.valueAt(Up.time), b.valueAt(Up.time), c.valueAt(Up.time), d.valueAt(Up.time), e.valueAt(Up.time))
        self.events = [(Up.time, g(vals))]
        self.addNewEvent = { [unowned self, unowned a, unowned b, unowned c, unowned d, unowned e] time in
            self.synchronized {
                let value = g(a.valueAt(time), b.valueAt(time), c.valueAt(time), d.valueAt(time), e.valueAt(time))
                self.addEventWithCountCheck(time, value: value, count: self.count, limit: self.limit)
            }
        }
        return self.withSources([a.sources, b.sources, c.sources, d.sources, e.sources])
    }
    
    func liftedFromSix<C1, C2, C3, C4, C5, C6>(a: Cell<C1>, _ b: Cell<C2>, _ c: Cell<C3>, _ d: Cell<C4>, _ e: Cell<C5>, _ f: Cell<C6>, _ g: (C1, C2, C3, C4, C5, C6) -> T) -> Cell<T> {
        let vals = (a.valueAt(Up.time), b.valueAt(Up.time), c.valueAt(Up.time), d.valueAt(Up.time), e.valueAt(Up.time), f.valueAt(Up.time))
        self.events = [(Up.time, g(vals))]
        self.addNewEvent = { [unowned self, unowned a, unowned b, unowned c, unowned d, unowned e, unowned f] time in
            self.synchronized {
                let value = g(a.valueAt(time), b.valueAt(time), c.valueAt(time), d.valueAt(time), e.valueAt(time), f.valueAt(time))
                self.addEventWithCountCheck(time, value: value, count: self.count, limit: self.limit)
            }
        }
        return self.withSources([a.sources, b.sources, c.sources, d.sources, e.sources, f.sources])
    }
    
    func liftedFromSeven<C1, C2, C3, C4, C5, C6, C7>(a: Cell<C1>, _ b: Cell<C2>, _ c: Cell<C3>, _ d: Cell<C4>, _ e: Cell<C5>, _ f: Cell<C6>, _ g: Cell<C7>, h: (C1, C2, C3, C4, C5, C6, C7) -> T) -> Cell<T> {
        let vals = (a.valueAt(Up.time), b.valueAt(Up.time), c.valueAt(Up.time), d.valueAt(Up.time), e.valueAt(Up.time), f.valueAt(Up.time), g.valueAt(Up.time))
        self.events = [(Up.time, h(vals))]
        self.addNewEvent = { [unowned self, unowned a, unowned b, unowned c, unowned d, unowned e, unowned f, unowned g] time in
            self.synchronized {
                let value = h(a.valueAt(time), b.valueAt(time), c.valueAt(time), d.valueAt(time), e.valueAt(time), f.valueAt(time), g.valueAt(time))
                self.addEventWithCountCheck(time, value: value, count: self.count, limit: self.limit)
            }
        }
        return self.withSources([a.sources, b.sources, c.sources, d.sources, e.sources, f.sources, g.sources])
    }
    
    public func send() {
        outlets.notify(.Update(now()))
    }
    
    func didReceiveCommand(command: Command) {
        switch command {
        case .NewEvent(let time):
            self.addNewEvent(time)
            self.outlets.notify(.Update(time))
        default:
            return
        }
    }
    
    func addListener(listener: Listener) {
        self.outlets.add { listener.didReceiveCommand($0) }
    }
    
    func withSources(sources: [[Whisperer]]) -> Cell<T> {
        self.sources = reduceSources(sources)
        self.sources.reduce(()) { $1.addListener(self) }
        return self
    }
    
    func mergedFrom<S>(streams: [Stream<S>], f g: S -> T) -> Cell<T> {
        let subCells = streams.map { $0.lift(self.valueAt(Up.time), f: { val in return g(val) }) }
        self.addNewEvent = { [unowned self] time in
            let latest = subCells.reduce(self.valueAt(Up.time)) {
                let lastEvent = $1.events[$1.count - 1]
                return lastEvent.time == time
                    ? lastEvent.value
                    : $0
            }
            self.synchronized {
                self.addEventWithCountCheck(time, value: latest, count: self.count, limit: self.limit)
            }
        }
        return self.withSources(streams.map { $0.sources })
    }
    
    private func addEventWithCountCheck(time: Time, value: T, count: Int, limit: Int) {
        switch count + 1 == limit {
        case true:
            self.events.removeAtIndex(1)
        default:
            self.count += 1
        }
        self.events.append((time, value))
        self.f = { [unowned self] in
            >|self.valueAt(time)
        }
    }
    
    public func out(action: T -> ()) -> Outlet<T> {
        let outlet = Outlet<T>(a: self, action: action)
        self.outlets.add { outlet.didReceiveCommand($0) }
        return outlet
    }
    
    func addOutlet(outlet: Outlet<T>, action: T -> ()) -> Cell<T> {
        outlet.configure(self, action: action)
        self.outlets.add { outlet.didReceiveCommand($0) }
        return self
    }
}