//
//  Protocols.swift
//  SimpleSwiftFRP
//
//  Created by developer on 2/19/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

import Cocoa

protocol Whisperer: class {
    func addListener(listener: Listener)
}

protocol Listener: class {
    func didReceiveCommand(command: Command)
}