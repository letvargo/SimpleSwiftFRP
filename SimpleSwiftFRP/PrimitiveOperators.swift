//
//  PrimitiveOperators.swift
//  SimpleSwiftFRP
//
//  Created by developer on 4/4/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

/// The map Operator: >--
infix operator >-- { associativity left }

public func >-- <T, U>(stream: Stream<T>, args: (stream: Stream<U>, f: T -> U)) -> Stream<U> {
    return stream.mapTo(args.stream, f: args.f)
}

public func >-- <T>(streamA: Stream<T>, streamB: Stream<T>) -> Stream<T> {
    return streamA.mapTo(streamB, f: id)
}

/// The filter Operator
infix operator --| { associativity left }

public func --| <T>(stream: Stream<T>, args: (stream: Stream<T>, f: T -> Bool)) -> Stream<T> {
    return stream.filterTo(args.stream, f: args.f)
}

/// The filterNil Operator
infix operator --! { associativity left }

public func --!<T>(lhs: Stream<T?>, rhs: Stream<T>) -> Stream<T> {
    return rhs.filterNilFrom(lhs)
}

/// The merge Operator
infix operator --& { associativity left }

public func --& <T, U>(streams: [Stream<T>], args: (cell: Cell<U>, f: T -> U)) -> Cell<U> {
    return args.cell.mergedFrom(streams, f: args.f)
}

public func --&<T>(streams: [Stream<T>], cell: Cell<T>) -> Cell<T> {
    return cell.mergedFrom(streams, f: id)
}

/// The lift Operator
infix operator --^ { associativity left }

public func --^<T, U>(stream: Stream<T>, args: (cell: Cell<U>, f: T -> U)) -> Cell<U> {
    return args.cell.liftedFromOne(stream, f: args.f)
}

public func --^<T>(stream: Stream<T>, cell: Cell<T>) -> Cell<T> {
    return cell.liftedFromOne(stream, f: id)
}

public func --^<C1, C2, T>(cells: (Cell<C1>, Cell<C2>), args: (cell: Cell<T>, f: (C1, C2) -> T)) -> Cell<T> {
    return args.cell.liftedFromTwo(cells.0, cells.1, args.f)
}

public func --^<C1, C2, C3, T>(cells: (Cell<C1>, Cell<C2>, Cell<C3>), args: (cell: Cell<T>, f: (C1, C2, C3) -> T)) -> Cell<T> {
    return args.cell.liftedFromThree(cells.0, cells.1, cells.2, args.f)
}

public func --^<C1, C2, C3, C4, T>(cells: (Cell<C1>, Cell<C2>, Cell<C3>, Cell<C4>), args: (cell: Cell<T>, f: (C1, C2, C3, C4) -> T)) -> Cell<T> {
    return args.cell.liftedFromFour(cells.0, cells.1, cells.2, cells.3, args.f)
}

public func --^<C1, C2, C3, C4, C5, T>(cells: (Cell<C1>, Cell<C2>, Cell<C3>, Cell<C4>, Cell<C5>), args: (cell: Cell<T>, f: (C1, C2, C3, C4, C5) -> T)) -> Cell<T> {
    return args.cell.liftedFromFive(cells.0, cells.1, cells.2, cells.3, cells.4, args.f)
}

public func --^<C1, C2, C3, C4, C5, C6, T>(cells: (Cell<C1>, Cell<C2>, Cell<C3>, Cell<C4>, Cell<C5>, Cell<C6>), args: (cell: Cell<T>, f: (C1, C2, C3, C4, C5, C6) -> T)) -> Cell<T> {
    return args.cell.liftedFromSix(cells.0, cells.1, cells.2, cells.3, cells.4, cells.5, args.f)
}

public func --^<C1, C2, C3, C4, C5, C6, C7, T>(cells: (Cell<C1>, Cell<C2>, Cell<C3>, Cell<C4>, Cell<C5>, Cell<C6>, Cell<C7>), args: (cell: Cell<T>, f: (C1, C2, C3, C4, C5, C6, C7) -> T)) -> Cell<T> {
    return args.cell.liftedFromSeven(cells.0, cells.1, cells.2, cells.3, cells.4, cells.5, cells.6, h: args.f)
}

/// The output Operator: --<
infix operator --< { associativity left }

public func --< <T>(cell: Cell<T>, args: (outlet: Outlet<T>, f: T -> ())) -> Cell<T> {
    return cell.addOutlet(args.outlet, action: args.f)
}