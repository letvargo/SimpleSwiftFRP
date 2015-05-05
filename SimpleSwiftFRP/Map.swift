//
//  Map.swift
//  SimpleSwiftFRP
//
//  Created by developer on 4/22/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

/// The map Operator: >--
infix operator >-- { associativity left }

public func >-- <T, U>(stream: Stream<T>, args: (stream: Stream<U>, f: T -> U)) -> Stream<U> {
    return args.stream.listenTo(stream).setValueFunction { [unowned stream] in
        stream.f() >< { args.f($0) }
    }
}

public func >-- <T>(streamA: Stream<T>, streamB: Stream<T>) -> Stream<T> {
    return streamB.listenTo(streamA).setValueFunction { [unowned streamA] in
        streamA.f() >< id
    }
}

public func >-- <T, U>(source: Source<T>, args: (stream: Stream<U>, f: T -> U)) -> Stream<U> {
    return args.stream.listenTo(source).setValueFunction { [unowned source] in
        source.f() >< { args.f($0) }
    }
}

public func >-- <T>(source: Source<T>, stream: Stream<T>) -> Stream<T> {
    return stream.listenTo(source).setValueFunction { [unowned source] in
        source.f() >< id
    }
}

public func >-- <T, U>(cell: Cell<T>, args: (stream: Stream<U>, f: T -> U)) -> Stream<U> {
    return args.stream.listenTo(cell).setValueFunction { [unowned cell] in
        cell.f() >< { args.f($0) }
    }
}

public func >-- <T>(cell: Cell<T>, stream: Stream<T>) -> Stream<T> {
    return stream.listenTo(cell).setValueFunction { [unowned cell] in
        cell.f() >< id
    }
}