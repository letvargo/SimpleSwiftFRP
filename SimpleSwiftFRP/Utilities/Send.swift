//
//  Send.swift
//  SimpleSwiftFRP
//
//  Created by letvargo on 5/26/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

public func send<T>(src: Source<T>, value: T, callback: (() -> ())? = nil) {
    let t = now()
    dispatch_async(Up.notificationQueue) {
        src.setNextEvent( { _ in value }).notify(t)
        callback?()
    }
}

public func send<T>(src: Source<T>, f: Time -> T, callback: (() -> ())? = nil) {
    let t = now()
    dispatch_async(Up.notificationQueue) {
        src.setNextEvent(f).notify(t)
        callback?()
    }
}