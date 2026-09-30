///|
test "build rejects invalid country charset and unknown country" {
  assert_eq(
    @mooniban.build("D", "370400440532013000"),
    Err(InvalidCountry("D")),
  )
  assert_eq(
    @mooniban.build("DE", "37040044053201300!"),
    Err(InvalidCharset(17)),
  )
  assert_eq(
    @mooniban.build("ZZ", "370400440532013000"),
    Err(UnknownCountry("ZZ")),
  )
  assert_eq(
    @mooniban.check_digits_for("D", "370400440532013000"),
    Err(InvalidCountry("D")),
  )
}

///|
test "parse and checksum reject malformed headers and short values" {
  assert_eq(@mooniban.checksum_remainder("DE8"), Err(TooShort(3)))
  assert_eq(
    @mooniban.parse("1E89370400440532013000"),
    Err(InvalidCountry("1E")),
  )
  assert_eq(@mooniban.parse("DEAA370400440532013000"), Err(InvalidCharset(2)))
  assert_eq(
    @mooniban.parse("GB82123412345698765432"),
    Err(BbanPattern("GB", 0)),
  )
}

///|
test "every public diagnostic variant has a stable code and message" {
  let errors : Array[@mooniban.IbanError] = [
    EmptyInput,
    InvalidCharset(4),
    TooShort(3),
    TooLong(35),
    InvalidCountry("1E"),
    UnknownCountry("ZZ"),
    LengthMismatch("DE", 22, 21),
    BadChecksum(2),
    BbanPattern("GB", 0),
    MissingOperand("iban"),
    UnknownCommand("nope"),
  ]
  let codes = [
    "IBAN001", "IBAN002", "IBAN003", "IBAN004", "IBAN005", "IBAN006", "IBAN007",
    "IBAN008", "IBAN009", "IBAN010", "IBAN011",
  ]
  for i, err in errors {
    let expected = codes[i]
    assert_eq(err.code(), expected)
    assert_true(err.message().length() > 0)
    assert_true(err.format().has_prefix(expected + ": "))
  }
}

///|
test "command dispatcher reports every missing operand family" {
  assert_eq(@mooniban.run_command([]), Err(MissingOperand("command")))
  assert_eq(@mooniban.run_command(["format"]), Err(MissingOperand("iban")))
  assert_eq(@mooniban.run_command(["parse"]), Err(MissingOperand("iban")))
  assert_eq(@mooniban.run_command(["explain"]), Err(MissingOperand("iban")))
  assert_eq(
    @mooniban.run_command(["build", "DE"]),
    Err(MissingOperand("country-and-bban")),
  )
  assert_eq(@mooniban.run_command(["checksum"]), Err(MissingOperand("iban")))
}

///|
test "field accessors are safe for manually constructed unknown values" {
  let fake : @mooniban.Iban = {
    country: "ZZ",
    check_digits: "00",
    bban: "1234",
    compact: "ZZ001234",
  }
  assert_eq(fake.bank(), None)
  assert_eq(fake.branch(), None)
  assert_eq(fake.account(), None)
  assert_eq(fake.spec(), None)
}
