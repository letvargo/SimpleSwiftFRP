//
//  Lift.swift
//  SimpleSwiftFRP
//
//  Created by letvargo on 2/20/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

infix operator --^ { associativity left }

public func --^<A, B>(

    ba:     Behavior<A>,
    
    rhs:    ( bb: Behavior<B>, f: (A) -> B ) )
    
    ->      Behavior<B> {
    
    return rhs.bb.setFirstEvent(
    
        event: Event {
            [ unowned ba
            , f = rhs.f ] time in
            
            f(ba.f(t: time))
        }
    )
        .listenTo(whisperer: ba)
}

public func --^<A, B>(

    ba:     Behavior<A>,
    
    rhs:    ( bb: Behavior<B>
            , f: (A) -> B
            , pred: (B) -> Bool ) )
    
    ->      Behavior<B> {
    
    return rhs.bb.setFirstEvent(
        event: Event {
            [ unowned ba
            , transform = rhs.f ] time in
            
            transform(ba.f(t: time))
        }
    ).setAddNewEvent {
        
        [ unowned ba
        , transform = rhs.f
        , pred = rhs.pred ] time in
        
        return pred(transform(ba.f(t: time)))
        
    }
        .listenTo(whisperer: ba)
}

public func --^<A, B, C>(

    lhs:    ( ba: Behavior<A>, bb: Behavior<B> ),
    
    rhs:    ( bc: Behavior<C>
            , f: (A, B) -> C ) )
    
    ->      Behavior<C> {
    
    return rhs.bc.setFirstEvent(
        event: Event {
            [ unowned ba = lhs.ba
            , unowned bb = lhs.bb ] time in
            
            rhs.f(
                  ba.f(t: time)
                , bb.f(t: time)
            )
        }
    )
        .listenTo(whisperer: lhs.ba)
        .listenTo(whisperer: lhs.bb)
}

public func --^<A, B, C>(

    lhs:    ( ba: Behavior<A>, bb: Behavior<B> ),
    
    rhs:    ( bc: Behavior<C>
            , f: (A, B) -> C
            , pred: (C) -> Bool ) )
    
    ->      Behavior<C> {
    
    return rhs.bc.setFirstEvent(
        event: Event {
            [ unowned ba = lhs.ba
            , unowned bb = lhs.bb ] t in
            
            rhs.f(
                  ba.f(t: t)
                , bb.f(t: t)
            )
        }
    ).setAddNewEvent {
        
        [ unowned ba = lhs.ba
        , unowned bb = lhs.bb ] t in
        
        let newValue = rhs.f(
            ba.f(t: t)
            , bb.f(t: t) )
        
        return rhs.pred(newValue)
    }
        .listenTo(whisperer: lhs.ba)
        .listenTo(whisperer: lhs.bb)
}

public func --^<A, B, C, D>(

    lhs:    ( ba: Behavior<A>, bb: Behavior<B>
            , bc: Behavior<C> ),
    
    rhs:    ( bd: Behavior<D>
            , f: (A, B, C) -> D ) )
    
    ->      Behavior<D> {
    
    return rhs.bd.setFirstEvent(
        event: Event {
            [ unowned ba = lhs.ba
            , unowned bb = lhs.bb
            , unowned bc = lhs.bc ] t in
            
            rhs.f(
                  ba.f(t: t)
                , bb.f(t: t)
                , bc.f(t: t) )
        }
    )
        .listenTo(whisperer: lhs.ba)
        .listenTo(whisperer: lhs.bb)
        .listenTo(whisperer: lhs.bc)
}

public func --^<A, B, C, D>(

    lhs:    ( ba: Behavior<A>, bb: Behavior<B>
            , bc: Behavior<C> ),
    
    rhs:    ( bd: Behavior<D>
            , f: (A, B, C) -> D
            , pred: (D) -> Bool ) )
    
    ->      Behavior<D> {
    
    return rhs.bd.setFirstEvent(
        event: Event {
            [ unowned ba = lhs.ba
            , unowned bb = lhs.bb
            , unowned bc = lhs.bc ] t in
            
            rhs.f(
                  ba.f(t: t)
                , bb.f(t: t)
                , bc.f(t: t) )
        }
    ).setAddNewEvent {
        
        [ unowned ba = lhs.ba
        , unowned bb = lhs.bb
        , unowned bc = lhs.bc ] t in
        
        let newValue = rhs.f(
            ba.f(t: t)
            , bb.f(t: t)
            , bc.f(t: t) )
        
        return rhs.pred(newValue)
    }
        .listenTo(whisperer: lhs.ba)
        .listenTo(whisperer: lhs.bb)
        .listenTo(whisperer: lhs.bc)
}

public func --^<A, B, C, D, E>(

    lhs:    ( ba: Behavior<A>, bb: Behavior<B>
            , bc: Behavior<C>, bd: Behavior<D> ),
    
    rhs:    ( be: Behavior<E>
            , f: (A, B, C, D) -> E ) )
    
    ->      Behavior<E> {
    
    return rhs.be.setFirstEvent(
        event: Event {
            [ unowned ba = lhs.ba
            , unowned bb = lhs.bb
            , unowned bc = lhs.bc
            , unowned bd = lhs.bd ] t in
            
            rhs.f(
                  ba.f(t: t)
                , bb.f(t: t)
                , bc.f(t: t)
                , bd.f(t: t) )
        }
    )
        .listenTo(whisperer: lhs.ba)
        .listenTo(whisperer: lhs.bb)
        .listenTo(whisperer: lhs.bc)
        .listenTo(whisperer: lhs.bd)
}

public func --^<A, B, C, D, E>(

    lhs:    ( ba: Behavior<A>, bb: Behavior<B>
            , bc: Behavior<C>, bd: Behavior<D> ),
    
    rhs:    ( be: Behavior<E>
            , f: (A, B, C, D) -> E
            , pred: (E) -> Bool ) )
    
    ->      Behavior<E> {
    
    return rhs.be.setFirstEvent(
        event: Event {
            [ unowned ba = lhs.ba
            , unowned bb = lhs.bb
            , unowned bc = lhs.bc
            , unowned bd = lhs.bd ] t in
            rhs.f(
                ba.f(t: t)
                , bb.f(t: t)
                , bc.f(t: t)
                , bd.f(t: t) )
        }
     ).setAddNewEvent {
        
        [ unowned ba = lhs.ba
        , unowned bb = lhs.bb
        , unowned bc = lhs.bc
        , unowned bd = lhs.bd ] t in
        
        let newValue = rhs.f(
              ba.f(t: t)
            , bb.f(t: t)
            , bc.f(t: t)
            , bd.f(t: t) )
        
        return rhs.pred(newValue)
    }
        .listenTo(whisperer: lhs.ba)
        .listenTo(whisperer: lhs.bb)
        .listenTo(whisperer: lhs.bc)
        .listenTo(whisperer: lhs.bd)
}