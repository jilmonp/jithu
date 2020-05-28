//
//  UserProfile.swift
//  ProfileApp
//
//  Created by jithin varghese on 28/05/20.
//  Copyright © 2020 celo. All rights reserved.
//

import XCTest

@testable import ProfileApp

class UserProfileTest: XCTestCase {

    var nameStr: Name!
    
    override func setUp() {
        super.setUp()
        nameStr = Name(title: "test1", first: "test2", last: "test3")
    }

    override func tearDown() {
        super.tearDown()
        nameStr = nil
    }
    func testNameTitle() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual("test1", nameStr.title)
    }

}
