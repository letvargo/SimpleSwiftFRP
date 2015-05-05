//
//  Stream.swift
//  SimpleSwiftFRP
//
//  Created by developer on 2/19/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

import Foundation

public class Stream<T>: Whisperer, Listener {
    
    private var _f: () -> Result<T> = { .Failure }
    private var listeners: ObserverSet<Command> = ObserverSet<Command>()
    
    public init() { }
    
    func setValueFunction(f: () -> Result<T>) -> Stream<T> {
        self._f = f
        return self
    }
    
    func f() -> Result<T> {
        return _f()
    }
    
    func didReceiveCommand(command: Command) {
        switch command {
        case .NewEvent(let time):
            switch _f() {
            case .Success(_):
                listeners.notify(.NewEvent(time))
            default:
                return
            }
        default:
            return
        }
    }
    
    func addListener(listener: Listener) {
        listeners.add { listener.didReceiveCommand($0) }
    }
    
    func listenTo(whisperer: Whisperer) -> Stream<T> {
        whisperer.addListener(self)
        return self
    }
}