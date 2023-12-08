import Orcam
import MacroCodableKit

@Init
struct Foo_Orcam {
  let x: Int
}

@AllOfCodable
struct Foo_MacroCodableKit {
  let x: Int
}
