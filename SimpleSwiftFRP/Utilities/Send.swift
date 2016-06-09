//
//  Send.swift
//  SimpleSwiftFRP
//
//  Created by letvargo on 5/26/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

public func send<T>(
      src: Source<T>
    , value: T
    , onQueue queue: dispatch_queue_t = Up.notificationQueue
    , callback: (() -> ())? = nil ) -> Time {
    
    let t = now()
    dispatch_async(queue) {
        src.notify(value: { _ in value }, time: t)
        callback?()
    }
    
    return t
}

public func send<T>(
    src: Source<T>
    , f: (Time) -> T
    , onQueue queue: dispatch_queue_t = Up.notificationQueue
    , callback: (() -> ())? = nil ) -> Time {
        
    let t = now()
    dispatch_async(queue) {
        src.notify(value: f, time: t)
        callback?()
    }
    
    return t
}