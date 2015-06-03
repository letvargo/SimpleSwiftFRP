//
//  Command.swift
//  SimpleSwiftFRP
//
//  Created by letvargo on 5/26/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

// A struct used to send notifications to nodes in the event stream.

enum Command {
    case NewEvent(Time)
}