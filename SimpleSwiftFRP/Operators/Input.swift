//
//  Input.swift
//  SimpleSwiftFRP
//
//  Created by letvargo on 4/22/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

infix operator >-- { associativity left }

public func >-- <A>(

    sa:     Source<A>,
    
    ba:     Behavior<A> )
    
    ->      Behavior<A> {
        
    return ba.setAddNewEvent {
    
        [ unowned sa
        , unowned ba ] time in
        
        guard
            let value = sa.value
        else { return false }
        
        return ba.appendEvent( event: Event(time, value) )
        
    }
        .listenTo(whisperer: sa)
}

public func >-- <A>(

    sa:     Source<A>,
    
    rhs:    ( ba: Behavior<A>
            , pred: (A) -> Bool ) )
    
    ->      Behavior<A> {

    return rhs.ba.setAddNewEvent {
    
        [ unowned sa
        , unowned ba = rhs.ba
        , pred = rhs.pred ]
        
        time in
        
        guard
            let value = sa.value where pred(value(time))
        else { return false }
        
        return ba.appendEvent( event: Event(time, value) )
        
    }
        .listenTo(whisperer: sa)
}

public func >-- <A, B>(
    
    sa:      Source<A>,
    
    rhs:    ( bb: Behavior<B>
            , f: (A) -> B ) )
    
    ->      Behavior<B> {
        
    return rhs.bb.setAddNewEvent {
    
        [ unowned sa
        , unowned bb = rhs.bb
        , f = rhs.f ] time in
        
        guard
            let value = sa.value
        else { return false }
            
        return bb.appendEvent( event: Event(time, f(value(time))) )
            
    }
        .listenTo(whisperer: sa)
}

public func >-- <A, B>(
    
    sa:      Source<A>,
    
    rhs:    ( bb: Behavior<B>
            , pred: (B) -> Bool
            , f: (A) -> B ) )
    
    ->      Behavior<B> {
        
    return rhs.bb.setAddNewEvent {
            
        [ unowned sa
        , unowned bb = rhs.bb
        , pred = rhs.pred
        , f = rhs.f ] time in
            
        guard
            let value = sa.value where pred(f(value(time)))
        else { return false }
        
        return bb.appendEvent( event: Event(time, f(value(time))) )
        
    }
        .listenTo(whisperer: sa)
}