//
//  FilterNil.swift
//  SimpleSwiftFRP
//
//  Created by developer on 4/22/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

/// The filterNil Operator
infix operator --! { associativity left }

public func --!<T>(streamA: Stream<T?>, streamB: Stream<T>) -> Stream<T> {
    return streamB.setSources(streamA.getSources()).setValueFunction { [unowned streamA] in
        streamA.f()>!<
    }
}

public func --!<T>(source: Source<T?>, stream: Stream<T>) -> Stream<T> {
    return stream.setSources(source.getSources()).setValueFunction { [unowned source] in
        source.f()>!<
    }
}

public func --!<T>(cell: Cell<T?>, stream: Stream<T>) -> Stream<T> {
    return stream.setSources(cell.getSources()).setValueFunction { [unowned cell] in
        cell.f()>!<
    }
}