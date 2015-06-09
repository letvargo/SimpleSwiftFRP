//
//  Input.swift
//  SimpleSwiftFRP
//
//  Created by letvargo on 4/22/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

infix operator >-- { associativity left }

public func >-- <T>(

    s:      Source<T>,
    
    b:      Behavior<T> )
    
    ->      Behavior<T> {

    return b.setAddNewEvent {
    
        [ unowned s
        , unowned b ] t in
        
        if let next = s.nextEvent {
        
            b.appendEvent(Event(t, next))
            return true
        
        } else {
        
            return false
        
        }
    }
        .listenTo(s)
}

public func >-- <T>(

    s:      Source<T>,
    
    rhs:    ( b: Behavior<T>
            , pred: T -> Bool ) )
    
    ->      Behavior<T> {

    return rhs.b.setAddNewEvent {
    
        [ unowned s
        , unowned b = rhs.b ] t in
        
        if let next = s.nextEvent
            where rhs.pred(next(t)) {
        
            b.appendEvent(Event(t, next))
            return true
            
        } else {
        
            return false
        
        }
    }
        .listenTo(s)
}