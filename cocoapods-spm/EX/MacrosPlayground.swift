import Orcam
import MacroCodableKit
import SwiftyBeaver

@Init
struct Foo_Orcam {
  let x: Int
}

@AllOfCodable
struct Foo_MacroCodableKit {
  let x: Int
}
