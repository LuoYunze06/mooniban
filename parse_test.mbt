///|
test "parse accepts valid european samples" {
  let de = @mooniban.parse("DE89 3704 0044 0532 0130 00").unwrap()
  assert_eq(de.country, "DE")
  assert_eq(de.check_digits, "89")
  assert_eq(de.bban, "370400440532013000")
  assert_eq(de.compact, "DE89370400440532013000")
  assert_eq(
    @mooniban.parse("GB82 WEST 1234 5698 7654 32").unwrap().country,
    "GB",
  )
  assert_eq(
    @mooniban.parse("FR1420041010050500013M02606").unwrap().compact.length(),
    27,
  )
}

///|
test "parse rejects length checksum and unknown country" {
  assert_eq(@mooniban.parse(""), Err(EmptyInput))
  assert_eq(@mooniban.parse("DE89"), Err(TooShort(4)))
  assert_eq(
    @mooniban.parse("DE8937040044053201300"),
    Err(LengthMismatch("DE", 22, 21)),
  )
  match @mooniban.parse("DE88370400440532013000") {
    Err(BadChecksum(_)) => ()
    _ => fail("expected bad checksum")
  }
  assert_eq(
    @mooniban.parse("ZZ89370400440532013000"),
    Err(UnknownCountry("ZZ")),
  )
}
