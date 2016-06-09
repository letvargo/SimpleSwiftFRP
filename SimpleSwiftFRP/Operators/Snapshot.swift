//
//  Snapshot.swift
//  SimpleSwiftFRP
//
//  Created by letvargo on 5/23/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

infix operator --% { associativity left }

public func --%<A, B, C>(

    lhs:    ( ba: Behavior<A>, bb: Behavior<B> ),
    
    rhs:    ( bc: Behavior<C>
            , f: (A, B) -> C ) )
    
    ->      Behavior<C> {
    
    return rhs.bc.setAddNewEvent {
    
        [ unowned ba = lhs.ba
        , unowned bb = lhs.bb
        , unowned bc = rhs.bc ] t in
    
        let newValue = rhs.f(
              ba.f(t: t)
            , bb.f(t: t) )
    
        _ = bc.appendEvent(
            event: Event(t, newValue)
        )
    
        return true
    }
        .listenTo(whisperer: lhs.ba)
}

public func --%<A, B, C>(

    lhs:    ( ba: Behavior<A>, bb: Behavior<B> ),
    
    rhs:    ( bc: Behavior<C>
            , f: (A, B) -> C
            , pred: (C) -> Bool ) )
    
    ->      Behavior<C> {
    
    return rhs.bc.setAddNewEvent {
    
        [ unowned ba = lhs.ba
        , unowned bb = lhs.bb
        , unowned bc = rhs.bc ] t in
    
        let newValue = rhs.f(
            ba.f(t: t)
            , bb.f(t: t) )
        
        if rhs.pred(newValue) {
        
            _ = bc.appendEvent(event: Event(t, newValue))
            return true
            
        } else {
            
            return false
        
        }
    }
        .listenTo(whisperer: lhs.ba)
}

public func --%<A, B, C, D>(

    lhs:    ( ba: Behavior<A>, bb: Behavior<B>
            , bc: Behavior<C> ),
    
    rhs:    ( bd: Behavior<D>
            , f: (A, B, C) -> D ) )
    
    ->      Behavior<D> {
    
    return rhs.bd.setAddNewEvent {
    
        [ unowned ba = lhs.ba
        , unowned bb = lhs.bb
        , unowned bc = lhs.bc
        , unowned bd = rhs.bd ] t in
    
        let newValue = rhs.f(
            ba.f(t: t)
            , bb.f(t: t)
            , bc.f(t: t) )
    
        _ = bd.appendEvent(
            event: Event(t, newValue)
        )
    
        return true
    }
        .listenTo(whisperer: lhs.ba)
}

public func --%<A, B, C, D>(

    lhs:    ( ba: Behavior<A>, bb: Behavior<B>
            , bc: Behavior<C>),
    
    rhs:    ( bd: Behavior<D>
            , f: (A, B, C) -> D
            , pred: (D) -> Bool ) )
    
    ->      Behavior<D> {
    
    return rhs.bd.setAddNewEvent {
    
        [ unowned ba = lhs.ba
        , unowned bb = lhs.bb
        , unowned bc = lhs.bc
        , unowned bd = rhs.bd ] t in
    
        let newValue = rhs.f(
              ba.f(t: t)
            , bb.f(t: t)
            , bc.f(t: t) )
        
        if rhs.pred(newValue) {
        
            _ = bd.appendEvent(event: Event(t, newValue))
            return true
            
        } else {
            
            return false
        
        }
    }
        .listenTo(whisperer: lhs.ba)
}

public func --%<A, B, C, D, E>(

    lhs:    ( ba: Behavior<A>, bb: Behavior<B>
            , bc: Behavior<C>, bd: Behavior<D> ),
    
    rhs:    ( be: Behavior<E>
            , f: (A, B, C, D) -> E ) )
    
    ->      Behavior<E> {
    
    return rhs.be.setAddNewEvent {
    
        [ unowned ba = lhs.ba
        , unowned bb = lhs.bb
        , unowned bc = lhs.bc
        , unowned bd = lhs.bd
        , unowned be = rhs.be ] t in
    
        let newValue = rhs.f(
            ba.f(t: t)
            , bb.f(t: t)
            , bc.f(t: t)
            , bd.f(t: t) )
    
        _ = be.appendEvent(
            event: Event(t, newValue)
        )
    
        return true
    }
        .listenTo(whisperer: lhs.ba)
}

public func --%<A, B, C, D, E>(

    lhs:    ( ba: Behavior<A>, bb: Behavior<B>
            , bc: Behavior<C>, bd: Behavior<D>),
    
    rhs:    ( be: Behavior<E>
            , f: (A, B, C, D) -> E
            , pred: (E) -> Bool ) )
    
    ->      Behavior<E> {
    
    return rhs.be.setAddNewEvent {
    
        [ unowned ba = lhs.ba
        , unowned bb = lhs.bb
        , unowned bc = lhs.bc
        , unowned bd = lhs.bd
        , unowned be = rhs.be ] t in
    
        let newValue = rhs.f(
            ba.f(t: t)
            , bb.f(t: t)
            , bc.f(t: t)
            , bd.f(t: t) )
        
        if rhs.pred(newValue) {
        
            _ = be.appendEvent(event: Event(t, newValue))
            return true
            
        } else {
            
            return false
        
        }
    }
        .listenTo(whisperer: lhs.ba)
}