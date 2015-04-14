//
//  Result.swift
//  SimpleSwiftFRP
//
//  Created by developer on 4/14/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

import Foundation
/// A struct used to pass values through the event stream.
///
/// :Cases:
/// * .Success(T)
/// * .Failure
enum Result<T> {
    case Success(T)
    
    /// .Failure represents no value at all.
    ///
    /// .Failure is returned in three situations:
    ///
    /// 1. It is the default return value for any Source that has never sent a value
    ///
    /// 2. When a Stream applies a filter to a value, if the predicate returns false the Stream will return .Failure
    ///
    /// 3. A Stream will return .Failure if its input Stream's f() parameter returns .Failure - i.e, Streams pass .Failures along when they are received
    case Failure
}

prefix operator >| { }

infix operator >< {
associativity left
precedence 200
}

infix operator >|< {
associativity left
precedence 200
}

func >|<<T>(lhs: Result<T>, filter: T -> Bool) -> Result<T> {
    switch lhs {
    case .Success(let value):
        switch filter(value) {
        case true:
            return .Success(value)
        default:
            return .Failure
        }
    case .Failure:
        return .Failure
    }
}

postfix operator >!< { }

postfix func >!<<T>(lhs: Result<T?>) -> Result<T> {
    switch lhs {
    case .Success(let optional):
        switch optional {
        case .Some(let value):
            return >|value
        case .None:
            return .Failure
        }
    case .Failure:
        return .Failure
    }
}

func ><<T, R>(lhs: Result<T>, rhs: T -> R) -> Result<R> {
    switch lhs {
    case .Success(let value):
        return .Success(rhs(value))
    case .Failure:
        return .Failure
    }
}

/// A custom prefix operator used to wrap a value in a .Success(T) instance of the Result<T> enum.
///
/// :param: value The value that needs to be wrapped
/// :returns: Result.Success(value)
prefix func >|<T>(value: T) -> Result<T> {
    return .Success(value)
}

public func id<T>(x: T) -> T {
    return x
}
