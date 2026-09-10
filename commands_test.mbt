///|
test "cli commands format parse and reject" {
  assert_eq(
    @mooniban.run_command(["validate", "DE89 3704 0044 0532 0130 00"]),
    Ok("valid DE89 3704 0044 0532 0130 00"),
  )
  assert_eq(
    @mooniban.run_command(["format", "gb82west12345698765432"]),
    Ok("GB82 WEST 1234 5698 7654 32"),
  )
  assert_eq(
    @mooniban.run_command(["build", "NL", "ABNA0417164300"]),
    Ok("NL91 ABNA 0417 1643 00"),
  )
  match @mooniban.run_command(["validate", "DE88370400440532013000"]) {
    Err(BadChecksum(_)) => ()
    _ => fail("checksum must fail")
  }
  assert_eq(@mooniban.run_command(["nope"]), Err(UnknownCommand("nope")))
  assert_eq(@mooniban.run_command(["validate"]), Err(MissingOperand("iban")))
}

///|
test "explain reports valid fields and invalid remainder" {
  let text = @mooniban.explain("NL91 ABNA 0417 1643 00")
  assert_true(text.contains("valid compact=NL91ABNA0417164300"))
  assert_true(text.contains("bank=ABNA"))
  let bad = @mooniban.explain("DE88370400440532013000")
  assert_true(bad.contains("IBAN008"))
}

///|
test "checksum and countries commands" {
  assert_eq(
    @mooniban.run_command(["checksum", "NL91ABNA0417164300"]),
    Ok("remainder=1"),
  )
  let countries = @mooniban.run_command(["countries"]).unwrap()
  assert_true(countries.contains("DE"))
  assert_true(countries.contains("NO"))
  assert_eq(
    @mooniban.run_command(["parse", "DE89 3704 0044 0532 0130 00"])
    .unwrap()
    .contains("bank=37040044"),
    true,
  )
}
