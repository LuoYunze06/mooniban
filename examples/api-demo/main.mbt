///|
fn[T] require(result : Result[T, @mooniban.IbanError]) -> T {
  match result {
    Ok(value) => value
    Err(error) => abort(error.format())
  }
}

///|
fn main {
  let de = require(@mooniban.parse("DE89 3704 0044 0532 0130 00"))
  match (de.bank(), de.account()) {
    (Some(bank), Some(account)) => {
      if bank != "37040044" || account != "0532013000" {
        abort("checkout fields mismatch")
      }
      println("CHECKOUT: compact=\{de.compact} bank=\{bank}")
    }
    _ => abort("DE fields missing")
  }

  let gb = require(@mooniban.build("GB", "WEST12345698765432"))
  if gb.pretty() != "GB82 WEST 1234 5698 7654 32" {
    abort("treasury rebuild mismatch")
  }
  println("TREASURY: rebuilt=\{gb.pretty()}")

  match @mooniban.parse("DE88370400440532013000") {
    Err(err) => {
      if err.code() != "IBAN008" {
        abort("expected checksum rejection")
      }
      println("RISK: mutated DE IBAN rejected by mod-97")
    }
    Ok(_) => abort("mutated DE IBAN must fail")
  }
  println("MoonIBAN acceptance: 3 scenarios passed")
}
