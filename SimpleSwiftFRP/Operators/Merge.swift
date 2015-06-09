//
//  Merge.swift
//  SimpleSwiftFRP
//
//  Created by letvargo on 4/23/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

/// The merge Operator
infix operator --& { associativity left }

public func --& <A, B>(

    bas:    [ Behavior<A> ],
    
    rhs:    ( bb: Behavior<B>
            , f: A -> B ) )
    
    -> Behavior<B> {
        
    return bas.reduce(rhs.bb) { $0.listenTo($1) }
        
        .setAddNewEvent {
    
            [ unowned bb = rhs.bb ] t in
        
            let latest = reduce(1..<bas.count, bas[0], { b, index in
        
            return bas[index].eventAt(t).time >= b.eventAt(t).time
                ? bas[index]
                : b
            }
        )
    
        let newValue = rhs.f(latest.f(t))
        
        bb.appendEvent(Event(t, newValue))
        
        return true
    }
}

public func --& <A, B>(

    bas:    [ Behavior<A> ],
    
    rhs:    ( bb: Behavior<B>
            , f: A -> B
            , pred: B -> Bool ) )
    
    -> Behavior<B> {
        
    return bas.reduce(rhs.bb) { $0.listenTo($1) }
    
        .setAddNewEvent {
    
        [ unowned bb = rhs.bb ] t in
        
            let latest = reduce(1..<bas.count, bas[0], { b, index in
        
            return bas[index].eventAt(t).time >= b.eventAt(t).time
                ? bas[index]
                : b
            }
        )
    
        let newValue = rhs.f(latest.f(t))
        
        if rhs.pred(newValue) {
        
            bb.appendEvent(Event(t, newValue))
            
            return true
            
        } else {
        
            return false
        }
    }
}