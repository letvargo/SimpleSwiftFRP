//
//  Stream.swift
//  SimpleSwiftFRP
//
//  Created by developer on 2/19/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

import Foundation

public class Stream<T> {
    
    private var _f: () -> Result<T> = { .Failure }
    private var sources: [Whisperer] = []
    
    public init() { }
    
    func getSources() -> [Whisperer] {
        return sources
    }
    
    func setSources(sources: [Whisperer]) -> Stream<T> {
        self.sources = sources
        return self
    }
    
    func setValueFunction(f: () -> Result<T>) -> Stream<T> {
        self._f = f
        return self
    }
    
    func f() -> Result<T> {
        return _f()
    }
}

func reduceSources(sources: [[Whisperer]]) -> [Whisperer] {
    let flatSources = sources.reduce([Whisperer]()) { $0 + $1 }
    return flatSources.reduce([Whisperer]()) { array, item in
        return array.filter({ i in i === item }).isEmpty
            ? array + [item]
            : array
    }
}