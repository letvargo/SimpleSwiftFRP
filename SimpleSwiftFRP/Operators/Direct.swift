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
    
        [ unowned s ] t in
        
        if let next = s.nextEvent {
            rhs.f(next(t))
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
    
        [ unowned s ] t in
        
        if let next = s.nextEvent where rhs.pred(next(t) ) {
            
                rhs.f(next(t))
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
        , unowned b = lhs.b ] t in
    
        if let next = s.nextEvent {
            rhs.f(
                  next(t)
                , b.f(t) )
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
        , unowned b = lhs.b ] t in
    
        if let next = s.nextEvent where rhs.pred(
              next(t)
            , b.f(t) ) {
            
                rhs.f(
                      next(t)
                    , b.f(t) )
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
        , unowned bc = lhs.bc ] t in
        
        if let next = sa.nextEvent {
            rhs.f(
                  next(t)
                , bb.f(t)
                , bc.f(t) )
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
        , unowned bc = lhs.bc ] t in
        
        if let next = sa.nextEvent where rhs.pred(
              next(t)
            , bb.f(t)
            , bc.f(t) ) {
            
                rhs.f(
                      next(t)
                    , bb.f(t)
                    , bc.f(t) )
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
        , unowned bd = lhs.bd ] t in
        
        if let next = sa.nextEvent {
            rhs.f(
                  next(t)
                , bb.f(t)
                , bc.f(t)
                , bd.f(t))
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
        , unowned bd = lhs.bd ] t in
        
        if let next = sa.nextEvent where rhs.pred(
              next(t)
            , bb.f(t)
            , bc.f(t)
            , bd.f(t) ) {
            
                rhs.f(
                      next(t)
                    , bb.f(t)
                    , bc.f(t)
                    , bd.f(t) )
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
        , unowned be = lhs.be ] t in
        
        if let next = sa.nextEvent {
            rhs.f(
                  next(t)
                , bb.f(t)
                , bc.f(t)
                , bd.f(t)
                , be.f(t) )
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
        , unowned be = lhs.be ] t in
        
        if let next = sa.nextEvent where rhs.pred(
              next(t)
            , bb.f(t)
            , bc.f(t)
            , bd.f(t)
            , be.f(t) ) {
            
                rhs.f(
                      next(t)
                    , bb.f(t)
                    , bc.f(t)
                    , bd.f(t)
                    , be.f(t) )
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
        , unowned bf = lhs.bf ] t in
        
        if let next = sa.nextEvent {
            rhs.f(
                  next(t)
                , bb.f(t)
                , bc.f(t)
                , bd.f(t)
                , be.f(t)
                , bf.f(t) )
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
        , unowned bf = lhs.bf ] t in
        
        if let next = sa.nextEvent where rhs.pred(
              next(t)
            , bb.f(t)
            , bc.f(t)
            , bd.f(t)
            , be.f(t)
            , bf.f(t) ) {
            
                rhs.f(
                      next(t)
                    , bb.f(t)
                    , bc.f(t)
                    , bd.f(t)
                    , be.f(t)
                    , bf.f(t) )
        }
    }
    
    lhs.sa.addListener(rhs.o)
    return lhs.sa
}