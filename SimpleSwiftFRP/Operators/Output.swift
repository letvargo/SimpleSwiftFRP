//
//  Output.swift
//  SimpleSwiftFRP
//
//  Created by letvargo on 4/25/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

/// The output Operator: --<
infix operator --< { associativity left }

public func --< <A>(

    ba:     Behavior<A>,
    
    rhs:    ( outlet: Outlet<A>
            , f: A -> () ) )
    
    -> Behavior<A> {
    
    rhs.outlet.setOutputFunction {
    
        [ unowned ba ] t in
        
        rhs.f(ba.f(t))
    }
    
    ba.addListener(rhs.outlet)
    
    return ba
}