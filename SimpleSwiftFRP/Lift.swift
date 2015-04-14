//
//  Lift.swift
//  SimpleSwiftFRP
//
//  Created by developer on 2/20/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

import Foundation

public class Lift {
    
    public class func two<C1, C2, T>(cellA a: Cell<C1>, cellB b: Cell<C2>, g: (C1, C2) -> T) -> Cell<T> {
        return Cell().liftedFromTwo(a, b, g)
    }
    
    public class func twoWithCapacity<C1, C2, T>(cellA a: Cell<C1>, cellB b: Cell<C2>, capacity: Int, g: (C1, C2) -> T) -> Cell<T> {
        return Cell(limit: capacity)
    }
    
    public class func three<C1, C2, C3, T>(cellA a: Cell<C1>, cellB b: Cell<C2>, cellC c: Cell<C3>, transform g: (C1, C2, C3) -> T) -> Cell<T> {
        return Cell().liftedFromThree(a, b, c, g)
    }
    
    public class func threeWithCapacity<C1, C2, C3, T>(cellA a: Cell<C1>, cellB b: Cell<C2>, cellC c: Cell<C3>, capacity: Int, transform g: (C1, C2, C3) -> T) -> Cell<T> {
        return Cell(limit: capacity).liftedFromThree(a, b, c, g)
    }
    
    public class func four<C1, C2, C3, C4, T>(cellA a: Cell<C1>, cellB b: Cell<C2>, cellC c: Cell<C3>, cellD d: Cell<C4>, transform g: (C1, C2, C3, C4) -> T) -> Cell<T> {
        return Cell().liftedFromFour(a, b, c, d, g)
    }
    
    public class func fourWithCapacity<C1, C2, C3, C4, T>(cellA a: Cell<C1>, cellB b: Cell<C2>, cellC c: Cell<C3>, cellD d: Cell<C4>, capacity: Int, transform g: (C1, C2, C3, C4) -> T) -> Cell<T> {
        return Cell(limit: capacity).liftedFromFour(a, b, c, d, g)
    }
    
    public class func five<C1, C2, C3, C4, C5, T>(cellA a: Cell<C1>, cellB b: Cell<C2>, cellC c: Cell<C3>, cellD d: Cell<C4>, cellE e: Cell<C5>, transform g: (C1, C2, C3, C4, C5) -> T) -> Cell<T> {
        return Cell().liftedFromFive(a, b, c, d, e, g)
    }
    
    public class func fiveWithCapacity<C1, C2, C3, C4, C5, T>(cellA a: Cell<C1>, cellB b: Cell<C2>, cellC c: Cell<C3>, cellD d: Cell<C4>, cellE e: Cell<C5>, capacity: Int, transform g: (C1, C2, C3, C4, C5) -> T) -> Cell<T> {
        return Cell(limit: capacity).liftedFromFive(a, b, c, d, e, g)
    }
    
    public class func six<C1, C2, C3, C4, C5, T>(cellA a: Cell<C1>, cellB b: Cell<C2>, cellC c: Cell<C3>, cellD d: Cell<C4>, cellE e: Cell<C5>, transform g: (C1, C2, C3, C4, C5) -> T) -> Cell<T> {
        return Cell().liftedFromFive(a, b, c, d, e, g)
    }
    
    public class func sixWithCapacity<C1, C2, C3, C4, C5, C6, T>(cellA a: Cell<C1>, cellB b: Cell<C2>, cellC c: Cell<C3>, cellD d: Cell<C4>, cellE e: Cell<C5>, cellF f: Cell<C6>, capacity: Int, transform g: (C1, C2, C3, C4, C5, C6) -> T) -> Cell<T> {
        return Cell(limit: capacity).liftedFromSix(a, b, c, d, e, f, g)
    }
}