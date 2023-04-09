//
//  XCTestSuite+Swizzle.swift
//  EXUITests
//
//  Created by Thuyen Trinh on 09/04/2023.
//

import XCTest


extension XCTestSuite {
  /// For 'Selected tests' suite
  @objc dynamic func swizzled_init(name masked: String) -> XCTestSuite {
    /// Recover the original test name
    /// - masked: UITestCaseA_testA1/testA1              --> recovered: UITestCaseA/testA1
    /// - masked: Driver/UITestCaseA_testA1/testA1   --> recovered: Driver/UITestCaseA/testA1
    guard let testBaseName = masked.split(separator: "/").last else {
      return swizzled_init(name: masked)
    }
    let recoveredName = masked.replacingOccurrences(of: "_\(testBaseName)/", with: "/") // 👈 remove the token
    NSLog("-> Detokenize test: \(masked) -> \(recoveredName)")
    return swizzled_init(name: recoveredName) // 👈 call the original init
  }

  @objc class func loadSwizzlings() {
    func swizzle(_ selector1: Selector, _ selector2: Selector, instanceMethod: Bool = true) {
      let fn = instanceMethod ? class_getInstanceMethod : class_getClassMethod
      guard let m1 = fn(XCTestSuite.self, selector1), let m2 = fn(XCTestSuite.self, selector2) else {
        fatalError("Cannot swizzle: \(selector1) <-> \(selector2)")
      }
      NSLog("Swizzle: \(selector1) <-> \(selector2)")
      method_exchangeImplementations(m1, m2)
    }

    swizzle(
      #selector(XCTestSuite.init(name:)),
      #selector(XCTestSuite.swizzled_init(name:))
    )
  }
}
