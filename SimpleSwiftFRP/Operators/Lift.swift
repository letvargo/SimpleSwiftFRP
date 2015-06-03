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
    
    rhs:    ( bb: Behavior<B>, f: A -> B ) )
    
    ->      Behavior<B> {
    
    return rhs.bb.setFirstEvent(
        Event {
            [ unowned ba ] time in
            
            rhs.f(ba.at(time))
        }
    )
        .listenTo(ba)
}

public func --^<A, B>(

    ba:     Behavior<A>,
    
    rhs:    ( bb: Behavior<B>
            , f: A -> B
            , pred: B -> Bool ) )
    
    ->      Behavior<B> {
    
    return rhs.bb.setFirstEvent(
        Event {
            [ unowned ba ] time in
            
            rhs.f(ba.at(time))
        }
    ).setAddNewEvent {
        
        [ unowned ba ] time in
        
        let newValue = rhs.f(ba.at(time))
        
        return rhs.pred(newValue)
    }
        .listenTo(ba)
}

public func --^<A, B, C>(

    lhs:    ( ba: Behavior<A>, bb: Behavior<B> ),
    
    rhs:    ( bc: Behavior<C>
            , f: (A, B) -> C ) )
    
    ->      Behavior<C> {
    
    return rhs.bc.setFirstEvent(
        Event {
            [ unowned ba = lhs.ba
            , unowned bb = lhs.bb ] time in
            
            rhs.f(
                  ba.at(time)
                , bb.at(time)
            )
        }
    )
        .listenTo(lhs.ba)
        .listenTo(lhs.bb)
}

public func --^<A, B, C>(

    lhs:    ( ba: Behavior<A>, bb: Behavior<B> ),
    
    rhs:    ( bc: Behavior<C>
            , f: (A, B) -> C
            , pred: C -> Bool ) )
    
    ->      Behavior<C> {
    
    return rhs.bc.setFirstEvent(
        Event {
            [ unowned ba = lhs.ba
            , unowned bb = lhs.bb ] time in
            
            rhs.f(
                  ba.at(time)
                , bb.at(time)
            )
        }
    ).setAddNewEvent {
        
        [ unowned ba = lhs.ba
        , unowned bb = lhs.bb ] time in
        
        let newValue = rhs.f(
              ba.at(time)
            , bb.at(time) )
        
        return rhs.pred(newValue)
    }
        .listenTo(lhs.ba)
        .listenTo(lhs.bb)
}

public func --^<A, B, C, D>(

    lhs:    ( ba: Behavior<A>, bb: Behavior<B>
            , bc: Behavior<C> ),
    
    rhs:    ( bd: Behavior<D>
            , f: (A, B, C) -> D ) )
    
    ->      Behavior<D> {
    
    return rhs.bd.setFirstEvent(
        Event {
            [ unowned ba = lhs.ba
            , unowned bb = lhs.bb
            , unowned bc = lhs.bc ] time in
            
            rhs.f(
                  ba.at(time)
                , bb.at(time)
                , bc.at(time) )
        }
    )
        .listenTo(lhs.ba)
        .listenTo(lhs.bb)
        .listenTo(lhs.bc)
}

public func --^<A, B, C, D>(

    lhs:    ( ba: Behavior<A>, bb: Behavior<B>
            , bc: Behavior<C> ),
    
    rhs:    ( bd: Behavior<D>
            , f: (A, B, C) -> D
            , pred: D -> Bool ) )
    
    ->      Behavior<D> {
    
    return rhs.bd.setFirstEvent(
        Event {
            [ unowned ba = lhs.ba
            , unowned bb = lhs.bb
            , unowned bc = lhs.bc ] time in
            
            rhs.f(
                  ba.at(time)
                , bb.at(time)
                , bc.at(time) )
        }
    ).setAddNewEvent {
        
        [ unowned ba = lhs.ba
        , unowned bb = lhs.bb
        , unowned bc = lhs.bc ] time in
        
        let newValue = rhs.f(
              ba.at(time)
            , bb.at(time)
            , bc.at(time) )
        
        return rhs.pred(newValue)
    }
        .listenTo(lhs.ba)
        .listenTo(lhs.bb)
        .listenTo(lhs.bc)
}

public func --^<A, B, C, D, E>(

    lhs:    ( ba: Behavior<A>, bb: Behavior<B>
            , bc: Behavior<C>, bd: Behavior<D> ),
    
    rhs:    ( be: Behavior<E>
            , f: (A, B, C, D) -> E ) )
    
    ->      Behavior<E> {
    
    return rhs.be.setFirstEvent(
        Event {
            [ unowned ba = lhs.ba
            , unowned bb = lhs.bb
            , unowned bc = lhs.bc
            , unowned bd = lhs.bd ] time in
            
            rhs.f(
                  ba.at(time)
                , bb.at(time)
                , bc.at(time)
                , bd.at(time) )
        }
    )
        .listenTo(lhs.ba)
        .listenTo(lhs.bb)
        .listenTo(lhs.bc)
        .listenTo(lhs.bd)
}

public func --^<A, B, C, D, E>(

    lhs:    ( ba: Behavior<A>, bb: Behavior<B>
            , bc: Behavior<C>, bd: Behavior<D> ),
    
    rhs:    ( be: Behavior<E>
            , f: (A, B, C, D) -> E
            , pred: E -> Bool ) )
    
    ->      Behavior<E> {
    
    return rhs.be.setFirstEvent(
        Event {
            [ unowned ba = lhs.ba
            , unowned bb = lhs.bb
            , unowned bc = lhs.bc
            , unowned bd = lhs.bd ] time in
            rhs.f(
                ba.at(time)
              , bb.at(time)
              , bc.at(time)
              , bd.at(time) )
        }
     ).setAddNewEvent {
        
        [ unowned ba = lhs.ba
        , unowned bb = lhs.bb
        , unowned bc = lhs.bc
        , unowned bd = lhs.bd ] time in
        
        let newValue = rhs.f(
              ba.at(time)
            , bb.at(time)
            , bc.at(time)
            , bd.at(time) )
        
        return rhs.pred(newValue)
    }
        .listenTo(lhs.ba)
        .listenTo(lhs.bb)
        .listenTo(lhs.bc)
        .listenTo(lhs.bd)
}

public func --^<A, B, C, D, E, F>(

    lhs:    ( ba: Behavior<A>, bb: Behavior<B>, bc: Behavior<C>
            , bd: Behavior<D>, be: Behavior<E> ),
    
    rhs:    ( bf: Behavior<F>
            , f: (A, B, C, D, E) -> F ) )
    
    ->      Behavior<F> {
    
    return rhs.bf.setFirstEvent(
        Event {
            [ unowned ba = lhs.ba
            , unowned bb = lhs.bb
            , unowned bc = lhs.bc
            , unowned bd = lhs.bd
            , unowned be = lhs.be ] time in
            
            rhs.f(
                  ba.at(time)
                , bb.at(time)
                , bc.at(time)
                , bd.at(time)
                , be.at(time) )
        }
    )
        .listenTo(lhs.ba)
        .listenTo(lhs.bb)
        .listenTo(lhs.bc)
        .listenTo(lhs.bd)
        .listenTo(lhs.be)
}

public func --^<A, B, C, D, E, F>(

    lhs:    ( ba: Behavior<A>, bb: Behavior<B>, bc: Behavior<C>
            , bd: Behavior<D>, be: Behavior<E> ),
    
    rhs:    ( bf: Behavior<F>
            , f: (A, B, C, D, E) -> F
            , pred: F -> Bool ) )
    
    ->      Behavior<F> {
    
    return rhs.bf.setFirstEvent(
        Event {
            [ unowned ba = lhs.ba
            , unowned bb = lhs.bb
            , unowned bc = lhs.bc
            , unowned bd = lhs.bd
            , unowned be = lhs.be ] time in
            
            rhs.f(
                ba.at(time)
              , bb.at(time)
              , bc.at(time)
              , bd.at(time)
              , be.at(time) )
        }
     ).setAddNewEvent {
        
        [ unowned ba = lhs.ba
        , unowned bb = lhs.bb
        , unowned bc = lhs.bc
        , unowned bd = lhs.bd
        , unowned be = lhs.be ] time in
        
        let newValue = rhs.f(
              ba.at(time)
            , bb.at(time)
            , bc.at(time)
            , bd.at(time)
            , be.at(time) )
        
        return rhs.pred(newValue)
    }
        .listenTo(lhs.ba)
        .listenTo(lhs.bb)
        .listenTo(lhs.bc)
        .listenTo(lhs.bd)
        .listenTo(lhs.be)
}

public func --^<A, B, C, D, E, F, G>(

    lhs:    ( ba: Behavior<A>, bb: Behavior<B>, bc: Behavior<C>
            , bd: Behavior<D>, be: Behavior<E>, bf: Behavior<F> ),
    
    rhs:    ( bg: Behavior<G>
            , f: (A, B, C, D, E, F) -> G ) )
    
    ->      Behavior<G> {
    
    return rhs.bg.setFirstEvent(
        Event {
            [ unowned ba = lhs.ba
            , unowned bb = lhs.bb
            , unowned bc = lhs.bc
            , unowned bd = lhs.bd
            , unowned be = lhs.be
            , unowned bf = lhs.bf ] time in
            
            rhs.f(
                  ba.at(time)
                , bb.at(time)
                , bc.at(time)
                , bd.at(time)
                , be.at(time)
                , bf.at(time) )
        }
    )
        .listenTo(lhs.ba)
        .listenTo(lhs.bb)
        .listenTo(lhs.bc)
        .listenTo(lhs.bd)
        .listenTo(lhs.be)
        .listenTo(lhs.bf)
}

public func --^<A, B, C, D, E, F, G>(

    lhs:    ( ba: Behavior<A>, bb: Behavior<B>, bc: Behavior<C>
            , bd: Behavior<D>, be: Behavior<E>, bf: Behavior<F> ),
    
    rhs:    ( bg: Behavior<G>
            , f: (A, B, C, D, E, F) -> G
            , pred: G -> Bool ) )
    
    ->      Behavior<G> {
    
    return rhs.bg.setFirstEvent(
        Event {
            [ unowned ba = lhs.ba
            , unowned bb = lhs.bb
            , unowned bc = lhs.bc
            , unowned bd = lhs.bd
            , unowned be = lhs.be
            , unowned bf = lhs.bf ] time in
            
            rhs.f(
                ba.at(time)
              , bb.at(time)
              , bc.at(time)
              , bd.at(time)
              , be.at(time)
              , bf.at(time) )
        }
     ).setAddNewEvent {
        
        [ unowned ba = lhs.ba
        , unowned bb = lhs.bb
        , unowned bc = lhs.bc
        , unowned bd = lhs.bd
        , unowned be = lhs.be
        , unowned bf = lhs.bf ] time in
        
        let newValue = rhs.f(
              ba.at(time)
            , bb.at(time)
            , bc.at(time)
            , bd.at(time)
            , be.at(time)
            , bf.at(time) )
        
        return rhs.pred(newValue)
    }
        .listenTo(lhs.ba)
        .listenTo(lhs.bb)
        .listenTo(lhs.bc)
        .listenTo(lhs.bd)
        .listenTo(lhs.be)
        .listenTo(lhs.bf)
}