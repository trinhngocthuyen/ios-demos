import Orcam
import MacroCodableKit
import SwiftyBeaver
import SwiftUIX

@Init
struct Foo_Orcam {
  let x: Int
}

@AllOfCodable
struct Foo_MacroCodableKit {
  let x: Int
}

private struct Foo_SwiftUIX: View {
  var body: some View {
    ScrollView {}.dismissDisabled(false)
  }
}
