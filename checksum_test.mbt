///|
test "iso 13616 remainder is 1 for public samples" {
  let samples = [
    "DE89 3704 0044 0532 0130 00", "GB82WEST12345698765432", "FR14 2004 1010 0505 0001 3M02 606",
    "NL91ABNA0417164300", "BE71 0961 2345 6769",
  ]
  for sample in samples {
    assert_eq(@mooniban.checksum_remainder(sample), Ok(1))
  }
}

///|
test "checksum rejects empty and charset errors" {
  assert_eq(@mooniban.checksum_remainder("   "), Err(EmptyInput))
  assert_eq(@mooniban.checksum_remainder("DE89*"), Err(InvalidCharset(4)))
}
