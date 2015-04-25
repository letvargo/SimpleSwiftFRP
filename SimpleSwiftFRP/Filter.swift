//
//  Filter.swift
//  SimpleSwiftFRP
//
//  Created by developer on 4/22/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

/// The filter Operator
infix operator --| { associativity left }

public func --| <T>(stream: Stream<T>, args: (stream: Stream<T>, f: T -> Bool)) -> Stream<T> {
    return args.stream.setSources(stream.getSources()).setValueFunction { [unowned stream] in
        stream.f() >|< { args.f($0) }
    }
}

public func --| <T>(source: Source<T>, args: (stream: Stream<T>, f: T -> Bool)) -> Stream<T> {
    return args.stream.setSources(source.getSources()).setValueFunction { [unowned source] in
        source.f() >|< { args.f($0) }
    }
}

public func --| <T>(cell: Cell<T>, args: (stream: Stream<T>, f: T -> Bool)) -> Stream<T> {
    return args.stream.setSources(cell.getSources()).setValueFunction { [unowned cell] in
        cell.f() >|< { args.f($0) }
    }
}