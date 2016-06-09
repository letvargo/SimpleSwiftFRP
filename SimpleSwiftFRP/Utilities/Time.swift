//
//  Time.swift
//  SimpleSwiftFRP
//
//  Created by letvargo on 5/23/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

import CoreMedia
import Foundation

public typealias Time = Double

public let tScale: Int32 = 1440000

extension CMTime {
    
    public var isValid: Bool {
        return flags.rawValue & CMTimeFlags.valid.rawValue != 0
    }
    
    public var isInvalid: Bool {
        return !isValid
    }
    
    public var isNegativeInfinity: Bool {
        return flags.rawValue & CMTimeFlags.negativeInfinity.rawValue != 0
    }
    
    public var isPositiveInfinity: Bool {
        return flags.rawValue & CMTimeFlags.positiveInfinity.rawValue != 0
    }
    
    public var isIndefinite: Bool {
        return isValid && (flags.rawValue & CMTimeFlags.indefinite.rawValue != 0)
    }
    
    public var isNumeric: Bool {
        return (flags.rawValue & (CMTimeFlags.valid.rawValue | CMTimeFlags.impliedValueFlagsMask.rawValue)) == CMTimeFlags.valid.rawValue
    }
    
    public var hasBeenRounded: Bool {
        return isNumeric && (flags.rawValue & CMTimeFlags.hasBeenRounded.rawValue) != 0
    }
    
    public var timeSince: CMTime {
        return CMTimeSubtract(CMTimeMakeWithSeconds(CACurrentMediaTime(), self.timescale), self)
    }
    
    public var inSeconds: Double {
        return CMTimeGetSeconds(self)
    }
}

public let now: () -> Time = NSDate.timeIntervalSinceReferenceDate

public func ==(lhs: CMTime, rhs: CMTime) -> Bool {
    return CMTimeCompare(lhs, rhs) == 0
}

public func <(lhs: CMTime, rhs: CMTime) -> Bool {
    return CMTimeCompare(lhs, rhs) == -1
}

public func -(lhs: CMTime, rhs: CMTime) -> CMTime {
    return CMTimeSubtract(lhs, rhs)
}

public func +(lhs: CMTime, rhs: CMTime) -> CMTime {
    return CMTimeAdd(lhs, rhs)
}