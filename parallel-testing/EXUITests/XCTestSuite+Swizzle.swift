//
//  XCTestSuite+Swizzle.swift
//  EXUITests
//
//  Created by Thuyen Trinh on 09/04/2023.
//

import XCTest

func swizzle(cls: AnyClass, _ selector1: Selector, _ selector2: Selector, instanceMethod: Bool = true) {
  let fn = instanceMethod ? class_getInstanceMethod : class_getClassMethod
  guard let m1 = fn(cls, selector1), let m2 = fn(cls, selector2) else {
    fatalError("Cannot swizzle: \(selector1) <-> \(selector2)")
  }
  NSLog("Swizzle: \(selector1) <-> \(selector2)")
  method_exchangeImplementations(m1, m2)
}

class QuickSuite: XCTestSuite { }


extension XCTestSuite {
  @objc dynamic func swizzled_init(name masked: String) -> XCTestSuite {
    guard let testBaseName = masked.split(separator: "/").last else {
      return swizzled_init(name: masked)
    }
    let recoveredName = masked.replacingOccurrences(of: "_\(testBaseName)/", with: "/")
    NSLog("-> \(#function). test: \(masked) -> \(recoveredName)")
    return swizzled_init(name: recoveredName)
  }
  
  /// ---------------------------------------------------------
  
  @objc dynamic class func swizzled_init(forTestCaseWithName masked: String) -> XCTestSuite {
    guard let testBaseName = masked.split(separator: "/").last else {
      return swizzled_init(forTestCaseWithName: masked)
    }
    let recoveredName = masked.replacingOccurrences(of: "_\(testBaseName)/", with: "/")
    NSLog("-> \(#function). test: \(masked) -> \(recoveredName)")
    return swizzled_init(forTestCaseWithName: recoveredName)
  }
  
  /// ---------------------------------------------------------
  
  @objc class func loadSwizzlings() {
//    swizzle(
//      cls: XCTestSuite.self,
//      #selector(XCTestSuite.init(name:)),
//      #selector(XCTestSuite.swizzled_init(name:))
//    )
//    swizzle(
//      cls: XCTestSuite.self,
//      #selector(XCTestSuite.init(forTestCaseWithName:)),
//      #selector(XCTestSuite.swizzled_init(forTestCaseWithName:)),
//      instanceMethod: false
//    )

    
  }
}
