///|
test "rebuilds public check digits from country and bban" {
  assert_eq(@mooniban.check_digits_for("DE", "370400440532013000"), Ok("89"))
  assert_eq(@mooniban.check_digits_for("GB", "WEST12345698765432"), Ok("82"))
  assert_eq(@mooniban.check_digits_for("NL", "ABNA0417164300"), Ok("91"))
  let rebuilt = @mooniban.build("fr", "20041010050500013M02606").unwrap()
  assert_eq(rebuilt.compact, "FR1420041010050500013M02606")
  assert_eq(rebuilt.pretty(), "FR14 2004 1010 0505 0001 3M02 606")
}

///|
test "build rejects pattern and length errors" {
  match @mooniban.build("GB", "123412345698765432") {
    Err(BbanPattern("GB", 0)) => ()
    _ => fail("GB bank letters required")
  }
  match @mooniban.build("DE", "37040044053201300") {
    Err(LengthMismatch("DE", 22, 21)) => ()
    _ => fail("DE length required")
  }
}
