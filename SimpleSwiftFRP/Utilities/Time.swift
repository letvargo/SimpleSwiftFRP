//
//  Time.swift
//  SimpleSwiftFRP
//
//  Created by letvargo on 5/23/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

import CoreMedia

public typealias Time = CMTime

public let tScale: Int32 = 1440000

extension Time: Comparable {
    
    public var isValid: Bool {
        return (self.flags & CMTimeFlags.Valid).rawValue != 0
    }
    
    public var isInvalid: Bool {
        return !self.isValid
    }
    
    public var isNegativeInfinity: Bool {
        return (self.flags & CMTimeFlags.NegativeInfinity).rawValue != 0
    }
    
    public var isPositiveInfinity: Bool {
        return (self.flags & CMTimeFlags.PositiveInfinity).rawValue != 0
    }
    
    public var isIndefinite: Bool {
        return self.isValid && (self.flags & CMTimeFlags.Indefinite).rawValue != 0
    }
    
    public var isNumeric: Bool {
        return (self.flags & (CMTimeFlags.Valid | CMTimeFlags.ImpliedValueFlagsMask)) == CMTimeFlags.Valid
    }
    
    public var hasBeenRounded: Bool {
        return self.isNumeric && (self.flags & CMTimeFlags.HasBeenRounded).rawValue != 0
    }
    
    public var timeSince: Time {
        return CMTimeSubtract(CMTimeMakeWithSeconds(CACurrentMediaTime(), self.timescale), self)
    }
    
    public var inSeconds: Double {
        return CMTimeGetSeconds(self)
    }
    
    public init() {
        let t0 = CMTimeMakeWithSeconds(CACurrentMediaTime(), tScale)
        self.value = t0.value
        self.timescale = t0.timescale
        self.epoch = t0.epoch
        self.flags = t0.flags
    }
}

public func now() -> Time {
    return CMTimeMakeWithSeconds(CACurrentMediaTime(), tScale)
}

public func ==(lhs: Time, rhs: Time) -> Bool {
    return CMTimeCompare(lhs, rhs) == 0
}

public func <(lhs: Time, rhs: Time) -> Bool {
    return CMTimeCompare(lhs, rhs) == -1
}

public func -(lhs: Time, rhs: Time) -> Time {
    return CMTimeSubtract(lhs, rhs)
}

public func +(lhs: Time, rhs: Time) -> Time {
    return CMTimeAdd(lhs, rhs)
}