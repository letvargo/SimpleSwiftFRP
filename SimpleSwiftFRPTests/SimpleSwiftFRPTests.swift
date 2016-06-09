//
//  SimpleSwiftFRPTests.swift
//  SimpleSwiftFRPTests
//
//  Created by developer on 4/8/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

import Cocoa
import SimpleSwiftFRP
import XCTest

class SimpleSwiftFRPTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
//    func testExample() {
//        // This is an example of a functional test case.
//        let sourceA = Source<Int>()
//        let sourceB = Source<Int>()
//        let cellA = Cell<Int>(initialValue: 9)
//        let cellB = Cell<Int>(initialValue: 13)
//        let cellC = Cell<Int>(initialValue: 22)
//        let outlet = Outlet<Int>()
//        
//        sourceA
//            --^ (cellA, id)
//        sourceB
//            --^ (cellB, id)
//            (cellA, cellB)
//                --^ (cellC, { $0 + $1 })
//                --< (outlet, { println($0) })
//        
//        
//        XCTAssert(true, "Pass")
//    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
