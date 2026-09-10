///|
test "generic length bounds and charset offsets" {
  match @mooniban.parse("DE893704004405320130000000000000000") {
    Err(TooLong(35)) => ()
    _ => fail("34 is the ISO maximum")
  }
  assert_eq(
    @mooniban.parse("DE89 3704 0044 0532 0130 0!"),
    Err(InvalidCharset(21)),
  )
  let min = @mooniban.parse("NO93 8601 1117 947").unwrap()
  assert_eq(min.compact.length(), 15)
  assert_eq(
    @mooniban.validate("IE29 AIBK 9311 5212 3456 78").unwrap().country,
    "IE",
  )
}

///|
test "error codes are stable" {
  assert_eq((EmptyInput : @mooniban.IbanError).code(), "IBAN001")
  assert_eq((InvalidCharset(4) : @mooniban.IbanError).code(), "IBAN002")
  assert_eq(
    (BadChecksum(2) : @mooniban.IbanError).format().has_prefix("IBAN008:"),
    true,
  )
}
