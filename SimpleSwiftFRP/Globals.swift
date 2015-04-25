//
//  Globals.swift
//  SimpleSwiftFRP
//
//  Created by developer on 2/19/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

import Foundation
import QuartzCore

/// Time is used as a typealias for CFTimeInterval, which is a typealias for Double
///
/// Because it is a Double, basic arithmetic operations and comparisons can be 
/// used to add, subtract or compare Time values.
public typealias Time = CFTimeInterval

/// A struct used to store a base time value that can be used to initialize
/// all Cells at the time they are created.
struct Up {
    
    /// A static global constant that represents the time at which the application
    /// started.
    ///
    /// All newly created Cells are initialized with a single event
    /// that has a time value of Up.time
    static let time = CACurrentMediaTime()
}

/// now() returns a CFTimeInterval that represents the elpsaed time since the 
/// application started.
public let now: () -> CFTimeInterval = CACurrentMediaTime

/// A struct used to send notifications to nodes in the event stream.
///
/// :Cases:
/// * .NewEvent(Time)
/// * .Update(Time)
public enum Command {
    
    /// .NewEvent(Time) is sent by a Source to notify listeners that a new value
    /// entered the event stream at the associated time.
    case NewEvent(Time)
    
    /// .Update(Time) is sent by a Cell to notify its outlets that they should
    /// execute a new action for the Cells value at the associated time.
    case Update(Time)
}

 let notificationQueue = dispatch_queue_create("com.letvargo.NotificationQueue", DISPATCH_QUEUE_SERIAL)
