///|
test "compact strips separators and lower case" {
  assert_eq(
    @mooniban.compact_text(" gb82 west-1234 5698 7654 32 \n"),
    "GB82WEST12345698765432",
  )
  assert_eq(
    @mooniban.pretty_groups("GB82WEST12345698765432"),
    "GB82 WEST 1234 5698 7654 32",
  )
  assert_eq(@mooniban.pretty_groups("NO9386011117947"), "NO93 8601 1117 947")
}
