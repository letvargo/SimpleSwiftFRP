//
//  Event.swift
//  SimpleSwiftFRP
//
//  Created by letvargo on 5/26/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

struct Event<T> {

    let time: Time
    
    let f: Time -> T

    init(_ value: T) {
        time = Up.time
        f = { _ in value }
    }

    init(_ t: Time, _ value: T) {
        time = t
        f = { _ in value }
    }
    
    init(_ f: Time -> T) {
        time = Up.time
        self.f = f
    }
    
    init(_ t: Time, _ f: Time -> T) {
        time = t
        self.f = f
    }
}