import SwiftUI
import Logger

@main
struct EXApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .onAppear {
          NSLog("[app] Logger.shared.id = \(Logger.shared.id)")
        }
    }
  }
}
