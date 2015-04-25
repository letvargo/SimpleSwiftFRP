//
//  Output.swift
//  SimpleSwiftFRP
//
//  Created by developer on 4/25/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

/// The output Operator: --<
infix operator --< { associativity left }

public func --< <T>(cell: Cell<T>, args: (outlet: Outlet<T>, f: T -> ())) -> Cell<T> {
    return cell.addOutlet(args.outlet, action: args.f)
}