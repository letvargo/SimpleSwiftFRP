//
//  Globals.swift
//  SimpleSwiftFRP
//
//  Created by letvargo on 2/19/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

import CoreMedia

struct Up {
    static let time = CMTimeMakeWithSeconds(CACurrentMediaTime(), tScale)
    static let notificationQueue = dispatch_queue_create("com.letvargo.NotificationQueue", DISPATCH_QUEUE_SERIAL)
}

public func id<T>(t: T.Type)(value: T) -> T {
    return value
}