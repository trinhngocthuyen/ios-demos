import Testing
import XCTest


final class LegacyTestCase: XCTestCase {
  func testFoo() { }
  func testBar() { }
}

@Test private func check() { }

struct NewTestCase {
  @Test func foo() { }
  @Test func bar() { }

  @Test(arguments: [(1, 1), (2, 1), (3, 2), (4, 3), (5, 5)])
  func fib(n: Int, expected: Int) { }
}
