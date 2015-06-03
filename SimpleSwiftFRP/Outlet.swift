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

public class Outlet<T>: Listener {
    
    private var f: Time -> () = { _ in return }
    
    public init() { }
    
    func setOutputFunction(action: Time -> ()) {
        self.f = action
    }
    
    func didReceiveCommand(command: Command) {
        switch command {
        case .NewEvent(let time):
            dispatch_async( dispatch_get_main_queue()) {
                self.f(time)
            }
        }
    }
}