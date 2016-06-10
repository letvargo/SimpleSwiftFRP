//
//  Event.swift
//  SimpleSwiftFRP
//
//  Created by doof nugget on 6/9/16.
//  Copyright © 2016 letvargo. All rights reserved.
//

final public class Event<Value> {

    private var occs: [Occurrence<Value>]
    private var listeners: ObserverSet<Time>
    
    public convenience init() {
        self.init(occs: [], listeners: ObserverSet())
    }
    
    public init(occs: [Occurrence<Value>], listeners: ObserverSet<Time>) {
        self.occs = occs
        self.listeners = listeners
    }
    
    public func send(value: Value) {
        let t0 = now()
        let occ = Occurrence(t0, value)
        occs.append(occ)
        listeners.notify(parameters: t0)
    }
}