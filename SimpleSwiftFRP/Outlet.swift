//
//  Outlet.swift
//  SimpleSwiftFRP
//
//  Created by developer on 2/20/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

import Foundation

public class Outlet<T>: Listener {
    
    private var f: Time -> ()
    private let sync: Bool
    
    public init(sync: Bool = false) {
        self.f = { _ in return }
        self.sync = sync
    }
    
    init(a: Cell<T>, action: T -> ()) {
        self.f = { action(a.valueAt($0)) }
        self.sync = false
    }
    
    init(a: Cell<T>, sync: Bool, action: T -> ()) {
        self.f = { action(a.valueAt($0)) }
        self.sync = sync
    }
    
    func configure(a: Cell<T>, action: T -> ()) {
        self.f = { action(a.valueAt($0)) }
    }
    
    func didReceiveCommand(command: Command) {
        switch command {
        case .Update(let time):
            switch self.sync {
            case false:
                dispatch_async(dispatch_get_main_queue()) { self.f(time) }
            default:
                dispatch_sync(dispatch_get_main_queue()) { self.f(time) }
            }
        default:
            return
        }
    }
}