//
//  Merge.swift
//  SimpleSwiftFRP
//
//  Created by developer on 4/23/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

/// The merge Operator
infix operator --& { associativity left }

public func --& <T, U>(streams: [Stream<T>], args: (cell: Cell<U>, f: T -> U)) -> Cell<U> {
    return args.cell.mergedFrom(streams, f: args.f)
}

public func --&<T>(streams: [Stream<T>], cell: Cell<T>) -> Cell<T> {
    return cell.mergedFrom(streams, f: id)
}