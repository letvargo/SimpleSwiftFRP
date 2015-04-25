//
//  Lift.swift
//  SimpleSwiftFRP
//
//  Created by developer on 2/20/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

/// The lift Operator
infix operator --^ { associativity left }

public func --^<T, U>(stream: Stream<T>, args: (cell: Cell<U>, f: T -> U)) -> Cell<U> {
    return args.cell.liftedFromOne(stream, f: args.f)
}

public func --^<T>(stream: Stream<T>, cell: Cell<T>) -> Cell<T> {
    return cell.liftedFromOne(stream, f: id)
}

public func --^<T, U>(source: Source<T>, args: (cell: Cell<U>, f: T -> U)) -> Cell<U> {
    return args.cell.liftedFromOne(source, f: args.f)
}

public func --^<T>(source: Source<T>, cell: Cell<T>) -> Cell<T> {
    return cell.liftedFromOne(source, f: id)
}

public func --^<T, U>(cell: Cell<T>, args: (cell: Cell<U>, f: T -> U)) -> Cell<U> {
    return args.cell.liftedFromOne(cell, f: args.f)
}

public func --^<T>(cellA: Cell<T>, cellB: Cell<T>) -> Cell<T> {
    return cellB.liftedFromOne(cellA, f: id)
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