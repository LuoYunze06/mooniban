///|
test "extracts bank branch and account slices" {
  let de = @mooniban.parse("DE89370400440532013000").unwrap()
  assert_eq(de.bank(), Some("37040044"))
  assert_eq(de.branch(), None)
  assert_eq(de.account(), Some("0532013000"))
  let gb = @mooniban.parse("GB82WEST12345698765432").unwrap()
  assert_eq(gb.bank(), Some("WEST"))
  assert_eq(gb.branch(), Some("123456"))
  assert_eq(gb.account(), Some("98765432"))
  let nl = @mooniban.parse("NL91ABNA0417164300").unwrap()
  assert_eq(nl.bank(), Some("ABNA"))
  assert_eq(nl.account(), Some("0417164300"))
}
