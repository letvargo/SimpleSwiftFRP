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
    return streamB.listenTo(streamA).setValueFunction { [unowned streamA] in
        streamA.f()>!<
    }
}

public func --!<T>(source: Source<T?>, stream: Stream<T>) -> Stream<T> {
    return stream.listenTo(source).setValueFunction { [unowned source] in
        source.f()>!<
    }
}

public func --!<T>(cell: Cell<T?>, stream: Stream<T>) -> Stream<T> {
    return stream.listenTo(cell).setValueFunction { [unowned cell] in
        cell.f()>!<
    }
}