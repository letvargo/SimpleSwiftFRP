//
//  Outlet.swift
//  SimpleSwiftFRP
//
//  Created by letvargo on 2/20/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

public func out<T>(t: T.Type) -> Outlet<T> {
    return Outlet<T>()
}

final public class Outlet<T>: Listener {
    
    private var f: Time -> () = { _ in return }
    
    public init() { }
    
    func setOutputFunction(action: Time -> ()) {
        f = action
    }
    
    func receiveNotification(t: Time) {
        dispatch_async(dispatch_get_main_queue()) {
            self.f(t)
        }
    }
}