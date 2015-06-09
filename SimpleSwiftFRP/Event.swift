//
//  Event.swift
//  SimpleSwiftFRP
//
//  Created by letvargo on 5/26/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

public struct Event<T> {

    typealias Value = T

    let time: Time
    
    let f: Time -> T

    init(_ value: Value) {
        time = Up.time
        f = { _ in value }
    }

    init(_ t: Time, _ value: Value) {
        time = t
        f = { _ in value }
    }
    
    init(_ f: Time -> Value) {
        time = Up.time
        self.f = f
    }
    
    init(_ t: Time, _ f: Time -> Value) {
        time = t
        self.f = f
    }
}