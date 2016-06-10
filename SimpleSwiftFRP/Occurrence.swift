//
//  Occurrence.swift
//  SimpleSwiftFRP
//
//  Created by letvargo on 5/26/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//


/// A time-value pair that represents a single occurrence of a discrete event.
public struct Occurrence<Value> {

    /// The time of the occurrence.
    public let time: Time
    
    /// The value associated with the occurrence.
    public let value: Value
    
    /// Initialize an Occurrence.
    public init(_ time: Time, _ value: Value) {
        self.time = time
        self.value = value
    }
    
    /// Initialize an Occurrence.
    ///
    /// The time of the Occurrence will be set to `now()`.
    public init(_ value: Value) {
        self.init(now(), value)
    }
}

// MARK: Conform Occurrence to Equatable

extension Occurrence: Equatable { }

/// Compare the times of two Occurrences for equality.
///
/// Note that the value is irrelevant.
public func == <A, B> (lhs: Occurrence<A>, rhs: Occurrence<B>) -> Bool {
    return lhs.time == rhs.time
}

// MARK: Conform Occurrence to Comparable

extension Occurrence: Comparable { }

/// Compare the times of two Occurrences.
///
/// Note that the value is irrelevant.
public func < <A, B> (lhs: Occurrence<A>, rhs: Occurrence<B>) -> Bool {
    return lhs.time < rhs.time
}

// MARK: Conform Occurrence to CustomStringConvertible

extension Occurrence: CustomStringConvertible {
    
    public var description: String {
        return "(\(self.time), \(self.value))"
    }
}