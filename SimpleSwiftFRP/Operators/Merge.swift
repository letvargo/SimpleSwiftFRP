//
//  Merge.swift
//  SimpleSwiftFRP
//
//  Created by letvargo on 4/23/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

/// The merge Operator
infix operator --& { associativity left }

public func --& <A, B>(

    bas:    [ Behavior<A> ],
    
    rhs:    ( bb: Behavior<B>
            , f: (A) -> B ) )
    
    -> Behavior<B> {
        
        bas.forEach {
            _ = rhs.bb.listenTo(whisperer: $0)
        }
        
    return rhs.bb.setAddNewEvent {
    
            [ unowned bb = rhs.bb ] t in
        
            let latest = (1..<bas.count).reduce(bas[0], combine: { b, index in
        
                return bas[index].eventAt(t: t).time >= b.eventAt(t: t).time
                ? bas[index]
                : b
            }
        )
    
        let newValue = rhs.f(latest.f(t: t))
        
        _ = bb.appendEvent(event: Event(t, newValue))
        
        return true
    }
}

//public func --& <A, B>(
//
//    bas:    [ Behavior<A> ],
//    
//    rhs:    ( bb: Behavior<B>
//            , f: (A) -> B
//            , pred: (B) -> Bool ) )
//    
//    -> Behavior<B> {
//        
//    return bas.reduce(rhs.bb) {
//        (bb: Behavior<B>, ba: Behavior<A>) -> Behavior<B> in
//        bb.listenTo(whisperer: ba) }
//    
//        .setAddNewEvent {
//    
//        [ unowned bb = rhs.bb ] t in
//        
//            let latest = (1..<bas.count).reduce(bas[0], combine: { b, index in
//        
//                return bas[index].eventAt(t: t).time >= b.eventAt(t).time
//                ? bas[index]
//                : b
//            }
//        )
//    
//        let newValue = rhs.f(latest.f(t))
//        
//        if rhs.pred(newValue) {
//        
//            _ = bb.appendEvent(event: Event(t, newValue))
//            
//            return true
//            
//        } else {
//        
//            return false
//        }
//    }
//}