//
//  Accumulate.swift
//  SimpleSwiftFRP
//
//  Created by doof nugget on 5/30/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

infix operator --+ { associativity left }

public func --+ <A, B, C> (

    lhs:    ( ba: Behavior<A>, bb: Behavior<B> ),
    
    rhs:    ( bc: Behavior<C>
            , f: (A, B) -> C) )
    
    ->      Behavior<C> {
    
    return rhs.bc.setAddNewEvent {
    
        [ unowned ba = lhs.ba
        , unowned bb = lhs.bb
        , unowned bc = rhs.bc ] t in
        
        let newValue = rhs.f(
              ba.f(t)
            , bb.f(t) )
        
        bc.appendEvent(Event(t, newValue))
        
        return true
    }
        .listenTo(lhs.ba)
}

public func --+ <A, B, C> (

    lhs:    ( ba: Behavior<A>, bb: Behavior<B> ),
    
    rhs:    ( bc: Behavior<C>
            , f: (A, B) -> C
            , pred: C -> Bool ) )
    
    ->      Behavior<C> {
    
    return rhs.bc.setAddNewEvent {
    
        [ unowned ba = lhs.ba
        , unowned bb = lhs.bb
        , unowned bc = rhs.bc ] t in
        
        let newValue = rhs.f(
              ba.f(t)
            , bb.f(t) )
        
        if rhs.pred(newValue) {
        
            bc.appendEvent(Event(t, newValue))
            return true
            
        } else {
        
            return false
            
        }
    }
        .listenTo(lhs.ba)
}

public func --+ <A, B, C, D> (

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
              ba.f(t)
            , bb.f(t)
            , bc.f(t) )
        
        bd.appendEvent(Event(t, newValue))
        return true
    }
        .listenTo(lhs.ba)
}

public func --+ <A, B, C, D> (

    lhs:    ( ba: Behavior<A>, bb: Behavior<B>
            , bc: Behavior<C> ),
    
    rhs:    ( bd: Behavior<D>
            , f: (A, B, C) -> D
            , pred: D -> Bool ) )
    
    ->      Behavior<D> {
    
    return rhs.bd.setAddNewEvent {
    
        [ unowned ba = lhs.ba
        , unowned bb = lhs.bb
        , unowned bc = lhs.bc
        , unowned bd = rhs.bd ] t in
        
        let newValue = rhs.f(
              ba.f(t)
            , bb.f(t)
            , bc.f(t) )
        
        if rhs.pred(newValue) {
        
            bd.appendEvent(Event(t, newValue))
            return true
        
        } else {
        
            return false
        
        }
    }
        .listenTo(lhs.ba)
}

public func --+ <A, B, C, D, E> (

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
              ba.f(t)
            , bb.f(t)
            , bc.f(t)
            , bd.f(t) )
        
        be.appendEvent(Event(t, newValue))
        return true
    }
        .listenTo(lhs.ba)
}

public func --+ <A, B, C, D, E> (

    lhs:    ( ba: Behavior<A>, bb: Behavior<B>
            , bc: Behavior<C>, bd: Behavior<D> ),
    
    rhs:    ( be: Behavior<E>
            , f: (A, B, C, D) -> E
            , pred: E -> Bool ) )
    
    ->      Behavior<E> {
    
    return rhs.be.setAddNewEvent {
    
        [ unowned ba = lhs.ba
        , unowned bb = lhs.bb
        , unowned bc = lhs.bc
        , unowned bd = lhs.bd
        , unowned be = rhs.be ] t in
        
        let newValue = rhs.f(
              ba.f(t)
            , bb.f(t)
            , bc.f(t)
            , bd.f(t) )
        
        if rhs.pred(newValue) {
        
            be.appendEvent(Event(t, newValue))
            return true
        
        } else {
        
            return false
        
        }
    }
        .listenTo(lhs.ba)
}

public func --+ <A, B, C, D, E, F> (

    lhs:    ( ba: Behavior<A>, bb: Behavior<B>, bc: Behavior<C>
            , bd: Behavior<D>, be: Behavior<E> ),
    
    rhs:    ( bf: Behavior<F>
            , f: (A, B, C, D, E) -> F ) )
    
    ->      Behavior<F> {
    
    return rhs.bf.setAddNewEvent {
    
        [ unowned ba = lhs.ba
        , unowned bb = lhs.bb
        , unowned bc = lhs.bc
        , unowned bd = lhs.bd
        , unowned be = lhs.be
        , unowned bf = rhs.bf ] t in
        
        let newValue = rhs.f(
              ba.f(t)
            , bb.f(t)
            , bc.f(t)
            , bd.f(t)
            , be.f(t) )
        
        bf.appendEvent(Event(t, newValue))
        return true
    }
        .listenTo(lhs.ba)
}

public func --+ <A, B, C, D, E, F> (

    lhs:    ( ba: Behavior<A>, bb: Behavior<B>, bc: Behavior<C>
            , bd: Behavior<D>, be: Behavior<E> ),
    
    rhs:    ( bf: Behavior<F>
            , f: (A, B, C, D, E) -> F
            , pred: F -> Bool ) )
    
    ->      Behavior<F> {
    
    return rhs.bf.setAddNewEvent {
    
        [ unowned ba = lhs.ba
        , unowned bb = lhs.bb
        , unowned bc = lhs.bc
        , unowned bd = lhs.bd
        , unowned be = lhs.be
        , unowned bf = rhs.bf ] t in
        
        let newValue = rhs.f(
              ba.f(t)
            , bb.f(t)
            , bc.f(t)
            , bd.f(t)
            , be.f(t) )
        
        if rhs.pred(newValue) {
        
            bf.appendEvent(Event(t, newValue))
            return true
        
        } else {
        
            return false
        
        }
    }
        .listenTo(lhs.ba)
}

public func --+ <A, B, C, D, E, F, G> (

    lhs:    ( ba: Behavior<A>, bb: Behavior<B>, bc: Behavior<C>
            , bd: Behavior<D>, be: Behavior<E>, bf: Behavior<F> ),
    
    rhs:    ( bg: Behavior<G>
            , f: (A, B, C, D, E, F) -> G ) )
    
    ->      Behavior<G> {
    
    return rhs.bg.setAddNewEvent {
    
        [ unowned ba = lhs.ba
        , unowned bb = lhs.bb
        , unowned bc = lhs.bc
        , unowned bd = lhs.bd
        , unowned be = lhs.be
        , unowned bf = lhs.bf
        , unowned bg = rhs.bg ] t in
        
        let newValue = rhs.f(
              ba.f(t)
            , bb.f(t)
            , bc.f(t)
            , bd.f(t)
            , be.f(t)
            , bf.f(t) )
        
        bg.appendEvent(Event(t, newValue))
        return true
    }
        .listenTo(lhs.ba)
}

public func --+ <A, B, C, D, E, F, G> (

    lhs:    ( ba: Behavior<A>, bb: Behavior<B>, bc: Behavior<C>
            , bd: Behavior<D>, be: Behavior<E>, bf: Behavior<F> ),
    
    rhs:    ( bg: Behavior<G>
            , f: (A, B, C, D, E, F) -> G
            , pred: G -> Bool ) )
    
    ->      Behavior<G> {
    
    return rhs.bg.setAddNewEvent {
    
        [ unowned ba = lhs.ba
        , unowned bb = lhs.bb
        , unowned bc = lhs.bc
        , unowned bd = lhs.bd
        , unowned be = lhs.be
        , unowned bf = lhs.bf
        , unowned bg = rhs.bg ] t in
        
        let newValue = rhs.f(
              ba.f(t)
            , bb.f(t)
            , bc.f(t)
            , bd.f(t)
            , be.f(t)
            , bf.f(t) )
        
        if rhs.pred(newValue) {
        
            bg.appendEvent(Event(t, newValue))
            return true
        
        } else {
        
            return false
        
        }
    }
        .listenTo(lhs.ba)
}