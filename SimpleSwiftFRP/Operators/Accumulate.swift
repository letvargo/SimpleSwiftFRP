//
//  Accumulate.swift
//  SimpleSwiftFRP
//
//  Created by doof nugget on 5/30/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

infix operator --+ { associativity left }

public func --+ <A, B> (

    ba:     Behavior<A>,
    
    rhs:    ( bb: Behavior<B>
            , f: (A, B) -> B) )
    
    ->      Behavior<B> {
    
    return rhs.bb.setAddNewEvent {
    
        [ unowned ba
        , unowned bb = rhs.bb ] t in
        
        let newValue = rhs.f(
              ba.f(t: t)
            , bb.f(t: t) )
        
        _ = bb.appendEvent(event: Event(t, newValue))
        
        return true
    }
        .listenTo(whisperer: ba)
}

public func --+ <A, B> (

    ba:     Behavior<A>,
    
    rhs:    ( bb: Behavior<B>
            , f: (A, B) -> B
            , pred: (B) -> Bool ) )
    
    ->      Behavior<B> {
    
    return rhs.bb.setAddNewEvent {
    
        [ unowned ba
        , unowned bb = rhs.bb ] t in
        
        let newValue = rhs.f(
              ba.f(t: t)
            , bb.f(t: t) )
        
        if rhs.pred(newValue) {
        
            _ = bb.appendEvent(event: Event(t, newValue))
            return true
            
        } else {
        
            return false
            
        }
    }
        .listenTo(whisperer: ba)
}

public func --+ <A, B, C> (

    lhs:    ( ba: Behavior<A>, bb: Behavior<B> ),
    
    rhs:    ( bc: Behavior<C>
            , f: (A, B, C) -> C ) )
    
    ->      Behavior<C> {
    
    return rhs.bc.setAddNewEvent {
    
        [ unowned ba = lhs.ba
        , unowned bb = lhs.bb
        , unowned bc = rhs.bc ] t in
        
        let newValue = rhs.f(
              ba.f(t: t)
            , bb.f(t: t)
            , bc.f(t: t) )
        
        _ = bc.appendEvent(event: Event(t, newValue))
        return true
    }
        .listenTo(whisperer: lhs.ba)
        .listenTo(whisperer: lhs.bb)
}

public func --+ <A, B, C> (

    lhs:    ( ba: Behavior<A>, bb: Behavior<B> ),
    
    rhs:    ( bc: Behavior<C>
            , f: (A, B, C) -> C
            , pred: (C) -> Bool ) )
    
    ->      Behavior<C> {
    
    return rhs.bc.setAddNewEvent {
    
        [ unowned ba = lhs.ba
        , unowned bb = lhs.bb
        , unowned bc = rhs.bc ] t in
        
        let newValue = rhs.f(
              ba.f(t: t)
            , bb.f(t: t)
            , bc.f(t: t) )
        
        guard
            rhs.pred(newValue)
        else { return false }
        
        return bc.appendEvent(event: Event(t, newValue))
        
    }
        .listenTo(whisperer: lhs.ba)
        .listenTo(whisperer: lhs.bb)
}