//
//  Event.swift
//  SimpleSwiftFRP
//
//  Created by letvargo on 5/26/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

struct Occurrence<Value>: Comparable {

    let time: Time
    let value: Value

    init(_ value: Value) {
        self.time = Up.time
        self.value = value
    }
}

func == <Value> (lhs: Occurrence<Value>, rhs: Occurrence<Value>) -> Bool {
    return lhs.time == rhs.time
}

func < <Value> (lhs: Occurrence<Value>, rhs: Occurrence<Value>) -> Bool {
    return lhs.time < rhs.time
}