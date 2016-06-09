//
//  Direct.swift
//  SimpleSwiftFRP
//
//  Created by doof nugget on 6/2/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

infix operator >-< { associativity left }

public func >-< <A>(

    s:      Source<A>,
    
    rhs:    ( o: Outlet
            , f: (A) -> () ) )

    ->      Source<A> {

    rhs.o.setOutputFunction {
    
        [ unowned s ] t in
        
        if let next = s.value {
            rhs.f(next(t))
        }
    }
    
    s.addListener(listener: rhs.o)
    return s
}

public func >-< <A>(

    s:      Source<A>,
    
    rhs:    ( o: Outlet
            , f: (A) -> ()
            , pred: (A) -> Bool ) )

    ->      Source<A> {

    rhs.o.setOutputFunction {
    
        [ unowned s ] t in
        
        if let next = s.value where rhs.pred(next(t) ) {
            
                rhs.f(next(t))
        }
    }
    
    s.addListener(listener: rhs.o)
    return s
}

public func >-< <A, B>(

    lhs:    ( s: Source<A>, b: Behavior<B> ),
    
    rhs:    ( o: Outlet
            , f: (A, B) -> () ) )
    
    ->      Source<A> {

    rhs.o.setOutputFunction {
    
        [ unowned s = lhs.s
        , unowned b = lhs.b ] t in
    
        if let next = s.value {
            rhs.f(
                  next(t)
                , b.f(t: t) )
        }
    }
    
    lhs.s.addListener(listener: rhs.o)
    return lhs.s
}

public func >-< <A, B>(

    lhs:    ( s: Source<A>, b: Behavior<B> ),
    rhs:    ( o: Outlet
            , f: (A, B) -> ()
            , pred: (A, B) -> Bool ) )
    
    ->      Source<A> {

    rhs.o.setOutputFunction {
    
        [ unowned s = lhs.s
        , unowned b = lhs.b ] t in
    
        if let next = s.value where rhs.pred(
              next(t)
            , b.f(t: t) ) {
            
                rhs.f(
                      next(t)
                    , b.f(t: t) )
        }
    }
    
    lhs.s.addListener(listener: rhs.o)
    return lhs.s
}

public func >-< <A, B, C>(

    lhs:    ( sa: Source<A>, bb: Behavior<B>
            , bc: Behavior<C> ),
    
    rhs:    ( o: Outlet
            , f: (A, B, C) -> () ) )
    
    ->      Source<A> {
    
    rhs.o.setOutputFunction {
    
        [ unowned sa = lhs.sa
        , unowned bb = lhs.bb
        , unowned bc = lhs.bc ] t in
        
        if let next = sa.value {
            rhs.f(
                  next(t)
                , bb.f(t: t)
                , bc.f(t: t) )
        }
    }
    
    lhs.sa.addListener(listener: rhs.o)
    return lhs.sa
}

public func >-< <A, B, C>(

    lhs:    ( sa: Source<A>, bb: Behavior<B>
            , bc: Behavior<C> ),
    
    rhs:    ( o: Outlet
            , f: (A, B, C) -> ()
            , pred: (A, B, C) -> Bool ) )
    
    ->      Source<A> {
    
    rhs.o.setOutputFunction {
    
        [ unowned sa = lhs.sa
        , unowned bb = lhs.bb
        , unowned bc = lhs.bc ] t in
        
        if let next = sa.value where rhs.pred(
              next(t)
            , bb.f(t: t)
            , bc.f(t: t) ) {
            
                rhs.f(
                      next(t)
                    , bb.f(t: t)
                    , bc.f(t: t) )
        }
    }
    
    lhs.sa.addListener(listener: rhs.o)
    return lhs.sa
}

public func >-< <A, B, C, D>(

    lhs:    ( sa: Source<A>, bb: Behavior<B>
            , bc: Behavior<C>, bd: Behavior<D> ),
    
    rhs:    ( o: Outlet
            , f: (A, B, C, D) -> () ) )
    
    ->      Source<A> {
    
    rhs.o.setOutputFunction {
    
        [ unowned sa = lhs.sa
        , unowned bb = lhs.bb
        , unowned bc = lhs.bc
        , unowned bd = lhs.bd ] t in
        
        if let next = sa.value {
            rhs.f(
                  next(t)
                , bb.f(t: t)
                , bc.f(t: t)
                , bd.f(t: t))
        }
    }
    
    lhs.sa.addListener(listener: rhs.o)
    return lhs.sa
}

public func >-< <A, B, C, D>(

    lhs:    ( sa: Source<A>, bb: Behavior<B>
            , bc: Behavior<C>, bd: Behavior<D>),
    
    rhs:    ( o: Outlet
            , f: (A, B, C, D) -> ()
            , pred: (A, B, C, D) -> Bool ) )
    
    ->      Source<A> {
    
    rhs.o.setOutputFunction {
    
        [ unowned sa = lhs.sa
        , unowned bb = lhs.bb
        , unowned bc = lhs.bc
        , unowned bd = lhs.bd ] t in
        
        if let next = sa.value where rhs.pred(
              next(t)
            , bb.f(t: t)
            , bc.f(t: t)
            , bd.f(t: t) ) {
            
                rhs.f(
                      next(t)
                    , bb.f(t: t)
                    , bc.f(t: t)
                    , bd.f(t: t) )
        }
    }
    
    lhs.sa.addListener(listener: rhs.o)
    return lhs.sa
}