public class Logger {
  public static let shared = Logger()

  public var id: String {
    String(unsafeBitCast(self, to: Int.self))
  }
}
