//
//  Outlet.swift
//  SimpleSwiftFRP
//
//  Created by developer on 2/20/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

import Foundation

public class Outlet<T>: Listener {
    
    private var f: Time -> () = { _ in return }
    
    public init() { }
    
    func setOutputFunction(a: Cell<T>, action: T -> ()) {
        self.f = { action(a.valueAt($0)) }
    }
    
    func didReceiveCommand(command: Command) {
        switch command {
        case .NewEvent(let time):
            dispatch_async(dispatch_get_main_queue()) { self.f(time) }
        default:
            return
        }
    }
}