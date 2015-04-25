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
    return args.stream.setSources(stream.getSources()).setValueFunction { [unowned stream] in
        stream.f() >< { args.f($0) }
    }
}

public func >-- <T>(streamA: Stream<T>, streamB: Stream<T>) -> Stream<T> {
    return streamB.setSources(streamA.getSources()).setValueFunction { [unowned streamA] in
        streamA.f() >< id
    }
}

public func >-- <T, U>(source: Source<T>, args: (stream: Stream<U>, f: T -> U)) -> Stream<U> {
    return args.stream.setSources(source.getSources()).setValueFunction { [unowned source] in
        source.f() >< { args.f($0) }
    }
}

public func >-- <T>(source: Source<T>, stream: Stream<T>) -> Stream<T> {
    return stream.setSources(source.getSources()).setValueFunction { [unowned source] in
        source.f() >< id
    }
}

public func >-- <T, U>(cell: Cell<T>, args: (stream: Stream<U>, f: T -> U)) -> Stream<U> {
    return args.stream.setSources(cell.getSources()).setValueFunction { [unowned cell] in
        cell.f() >< { args.f($0) }
    }
}

public func >-- <T>(cell: Cell<T>, stream: Stream<T>) -> Stream<T> {
    return stream.setSources(cell.getSources()).setValueFunction { [unowned cell] in
        cell.f() >< id
    }
}