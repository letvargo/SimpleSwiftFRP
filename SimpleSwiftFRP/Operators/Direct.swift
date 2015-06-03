//
//  Direct.swift
//  SimpleSwiftFRP
//
//  Created by doof nugget on 6/2/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

infix operator >-< { associativity left }

public func >-< <T>(

    s:      Source<T>,
    
    rhs:    ( o: Outlet<T>
            , f: T -> () ) )

    ->      Source<T> {

    rhs.o.setOutputFunction {
    
        [ unowned s ] time in
        
        if let next = s.nextEvent {
            rhs.f(next(time))
        }
    }
    
    s.addListener(rhs.o)
    return s
}

public func >-< <T>(

    s:      Source<T>,
    
    rhs:    ( o: Outlet<T>
            , f: T -> ()
            , pred: T -> Bool ) )

    ->      Source<T> {

    rhs.o.setOutputFunction {
    
        [ unowned s ] time in
        
        if let next = s.nextEvent where rhs.pred(next(time) ) {
            
                rhs.f(next(time))
        }
    }
    
    s.addListener(rhs.o)
    return s
}

public func >-< <A, B>(

    lhs:    ( s: Source<A>, b: Behavior<B> ),
    
    rhs:    ( o: Outlet<A>
            , f: (A, B) -> () ) )
    
    ->      Source<A> {

    rhs.o.setOutputFunction {
    
        [ unowned s = lhs.s
        , unowned b = lhs.b ] time in
    
        if let next = s.nextEvent {
            rhs.f(
                  next(time)
                , b.at(time) )
        }
    }
    
    lhs.s.addListener(rhs.o)
    return lhs.s
}

public func >-< <A, B>(

    lhs:    ( s: Source<A>, b: Behavior<B> ),
    rhs:    ( o: Outlet<A>
            , f: (A, B) -> ()
            , pred: (A, B) -> Bool ) )
    
    ->      Source<A> {

    rhs.o.setOutputFunction {
    
        [ unowned s = lhs.s
        , unowned b = lhs.b ] time in
    
        if let next = s.nextEvent where rhs.pred(
              next(time)
            , b.at(time) ) {
            
                rhs.f(
                      next(time)
                    , b.at(time) )
        }
    }
    
    lhs.s.addListener(rhs.o)
    return lhs.s
}

public func >-< <A, B, C>(

    lhs:    ( sa: Source<A>, bb: Behavior<B>
            , bc: Behavior<C> ),
    
    rhs:    ( o: Outlet<A>
            , f: (A, B, C) -> () ) )
    
    ->      Source<A> {
    
    rhs.o.setOutputFunction {
    
        [ unowned sa = lhs.sa
        , unowned bb = lhs.bb
        , unowned bc = lhs.bc ] time in
        
        if let next = sa.nextEvent {
            rhs.f(
                  next(time)
                , bb.at(time)
                , bc.at(time) )
        }
    }
    
    lhs.sa.addListener(rhs.o)
    return lhs.sa
}

public func >-< <A, B, C>(

    lhs:    ( sa: Source<A>, bb: Behavior<B>
            , bc: Behavior<C> ),
    
    rhs:    ( o: Outlet<A>
            , f: (A, B, C) -> ()
            , pred: (A, B, C) -> Bool ) )
    
    ->      Source<A> {
    
    rhs.o.setOutputFunction {
    
        [ unowned sa = lhs.sa
        , unowned bb = lhs.bb
        , unowned bc = lhs.bc ] time in
        
        if let next = sa.nextEvent where rhs.pred(
              next(time)
            , bb.at(time)
            , bc.at(time) ) {
            
                rhs.f(
                      next(time)
                    , bb.at(time)
                    , bc.at(time) )
        }
    }
    
    lhs.sa.addListener(rhs.o)
    return lhs.sa
}

public func >-< <A, B, C, D>(

    lhs:    ( sa: Source<A>, bb: Behavior<B>
            , bc: Behavior<C>, bd: Behavior<D> ),
    
    rhs:    ( o: Outlet<A>
            , f: (A, B, C, D) -> () ) )
    
    ->      Source<A> {
    
    rhs.o.setOutputFunction {
    
        [ unowned sa = lhs.sa
        , unowned bb = lhs.bb
        , unowned bc = lhs.bc
        , unowned bd = lhs.bd ] time in
        
        if let next = sa.nextEvent {
            rhs.f(
                  next(time)
                , bb.at(time)
                , bc.at(time)
                , bd.at(time))
        }
    }
    
    lhs.sa.addListener(rhs.o)
    return lhs.sa
}

public func >-< <A, B, C, D>(

    lhs:    ( sa: Source<A>, bb: Behavior<B>
            , bc: Behavior<C>, bd: Behavior<D>),
    
    rhs:    ( o: Outlet<A>
            , f: (A, B, C, D) -> ()
            , pred: (A, B, C, D) -> Bool ) )
    
    ->      Source<A> {
    
    rhs.o.setOutputFunction {
    
        [ unowned sa = lhs.sa
        , unowned bb = lhs.bb
        , unowned bc = lhs.bc
        , unowned bd = lhs.bd ] time in
        
        if let next = sa.nextEvent where rhs.pred(
              next(time)
            , bb.at(time)
            , bc.at(time)
            , bd.at(time) ) {
            
                rhs.f(
                      next(time)
                    , bb.at(time)
                    , bc.at(time)
                    , bd.at(time) )
        }
    }
    
    lhs.sa.addListener(rhs.o)
    return lhs.sa
}

public func >-< <A, B, C, D, E>(

    lhs:    ( sa: Source<A>, bb: Behavior<B>, bc: Behavior<C>
            , bd: Behavior<D>, be: Behavior<E>),
    
    rhs:    ( o: Outlet<A>
            , f: (A, B, C, D, E) -> () ) )
    
    ->      Source<A> {
    
    rhs.o.setOutputFunction {
    
        [ unowned sa = lhs.sa
        , unowned bb = lhs.bb
        , unowned bc = lhs.bc
        , unowned bd = lhs.bd
        , unowned be = lhs.be ] time in
        
        if let next = sa.nextEvent {
            rhs.f(
                  next(time)
                , bb.at(time)
                , bc.at(time)
                , bd.at(time)
                , be.at(time) )
        }
    }
    
    lhs.sa.addListener(rhs.o)
    return lhs.sa
}

public func >-< <A, B, C, D, E>(

    lhs:    ( sa: Source<A>, bb: Behavior<B>, bc: Behavior<C>
            , bd: Behavior<D>, be: Behavior<E>),
    
    rhs:    ( o: Outlet<A>
            , f: (A, B, C, D, E) -> ()
            , pred: (A, B, C, D, E) -> Bool ) )
    
    ->      Source<A> {
    
    rhs.o.setOutputFunction {
    
        [ unowned sa = lhs.sa
        , unowned bb = lhs.bb
        , unowned bc = lhs.bc
        , unowned bd = lhs.bd
        , unowned be = lhs.be ] time in
        
        if let next = sa.nextEvent where rhs.pred(
              next(time)
            , bb.at(time)
            , bc.at(time)
            , bd.at(time)
            , be.at(time) ) {
            
                rhs.f(
                      next(time)
                    , bb.at(time)
                    , bc.at(time)
                    , bd.at(time)
                    , be.at(time) )
        }
    }
    
    lhs.sa.addListener(rhs.o)
    return lhs.sa
}

public func >-< <A, B, C, D, E, F>(

    lhs:    ( sa: Source<A>, bb: Behavior<B>, bc: Behavior<C>
            , bd: Behavior<D>, be: Behavior<E>, bf: Behavior<F> ),
    
    rhs:    ( o: Outlet<A>
            , f: (A, B, C, D, E, F) -> () ) )
    
    ->      Source<A> {
    
    rhs.o.setOutputFunction {
    
        [ unowned sa = lhs.sa
        , unowned bb = lhs.bb
        , unowned bc = lhs.bc
        , unowned bd = lhs.bd
        , unowned be = lhs.be
        , unowned bf = lhs.bf ] time in
        
        if let next = sa.nextEvent {
            rhs.f(
                  next(time)
                , bb.at(time)
                , bc.at(time)
                , bd.at(time)
                , be.at(time)
                , bf.at(time) )
        }
    }
    
    lhs.sa.addListener(rhs.o)
    return lhs.sa
}

public func >-< <A, B, C, D, E, F>(

    lhs:    ( sa: Source<A>, bb: Behavior<B>, bc: Behavior<C>
            , bd: Behavior<D>, be: Behavior<E>, bf: Behavior<F> ),
    
    rhs:    ( o: Outlet<A>
            , f: (A, B, C, D, E, F) -> ()
            , pred: (A, B, C, D, E, F) -> Bool ) )
    
    ->      Source<A> {
    
    rhs.o.setOutputFunction {
    
        [ unowned sa = lhs.sa
        , unowned bb = lhs.bb
        , unowned bc = lhs.bc
        , unowned bd = lhs.bd
        , unowned be = lhs.be
        , unowned bf = lhs.bf ] time in
        
        if let next = sa.nextEvent where rhs.pred(
              next(time)
            , bb.at(time)
            , bc.at(time)
            , bd.at(time)
            , be.at(time)
            , bf.at(time) ) {
            
                rhs.f(
                      next(time)
                    , bb.at(time)
                    , bc.at(time)
                    , bd.at(time)
                    , be.at(time)
                    , bf.at(time) )
        }
    }
    
    lhs.sa.addListener(rhs.o)
    return lhs.sa
}