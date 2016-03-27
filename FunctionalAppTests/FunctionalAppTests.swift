//
//  FunctionalAppTests.swift
//  FunctionalAppTests
//
//  Created by Pyae Phyo Myint Soe on 25/3/16.
//  Copyright © 2016 PYAE PHYO MYINT SOE. All rights reserved.
//

import XCTest

class FunctionalAppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: 400,height: 500)
        UIScrollView().zoomOutWithCenterPoint(CGPointZero, forScale: 1, animated : true)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
