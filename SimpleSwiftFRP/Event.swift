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
        self.time = Up.time
        self.f = { _ in value }
    }

    init(_ time: Time, _ value: Value) {
        self.time = time
        self.f = { _ in value }
    }
    
    init(_ f: Time -> Value) {
        self.time = Up.time
        self.f = f
    }
    
    init(_ time: Time, _ f: Time -> Value) {
        self.time = time
        self.f = f
    }
}