import XCTest
import Logger

final class EXTests: XCTestCase {
  func testExample() throws {
    // If Logger is statically linked, then Logger.shared.id in EXTests is different with the one in EXTests
    NSLog("[test] Logger.shared.id = \(Logger.shared.id)")
  }
}
