//
//  EXUITests.swift
//  EXUITests
//
//  Created by Thuyen Trinh on 09/04/2023.
//

import XCTest

class BaseTestCase: XCTestCase {
  func waitABit() {
    sleep(UInt32.random(in: 1..<10))
  }
}

final class TestCaseA: BaseTestCase {
  func testA1() { waitABit() }
  func testA2() { waitABit() }
  func testA3() { waitABit() }
}

final class TestCaseB: BaseTestCase {
  func testB1() { waitABit() }
  func testB2() { waitABit() }
  func testB3() { waitABit() }
}

final class TestCaseC: BaseTestCase {
  func testC1() { waitABit() }
  func testC2() { waitABit() }
  func testC3() { waitABit() }
}
