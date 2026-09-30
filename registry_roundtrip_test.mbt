///|
fn sample_bban(pattern : String) -> String {
  let mut out = ""
  let mut i = 0
  while i < pattern.length() {
    let mut count = 0
    while i < pattern.length() && pattern[i] >= '0' && pattern[i] <= '9' {
      count = count * 10 + (pattern[i].to_int() - 48)
      i += 1
    }
    let cls = pattern[i]
    i += 1
    let atom = if cls == 'n' { "0" } else { "A" }
    for _ in 0..<count {
      out += atom
    }
  }
  out
}

///|
test "every registered country builds and parses a conforming bban" {
  let countries = @mooniban.registered_countries()
  assert_eq(countries.length(), 72)
  for code in countries {
    let spec = @mooniban.country_spec(code).unwrap()
    let bban = sample_bban(spec.bban_pattern)
    assert_eq(bban.length() + 4, spec.length)
    let built = @mooniban.build(code, bban).unwrap()
    assert_eq(built.country, code)
    assert_eq(built.compact.length(), spec.length)
    assert_eq(@mooniban.checksum_remainder(built.compact), Ok(1))
    assert_eq(@mooniban.parse(built.pretty()), Ok(built))
  }
}

///|
test "every registry field layout stays inside its bban" {
  for code in @mooniban.registered_countries() {
    let spec = @mooniban.country_spec(code).unwrap()
    let bban_length = spec.length - 4
    assert_true(spec.bank >= 0)
    assert_true(spec.branch >= 0)
    assert_true(spec.account >= 0)
    assert_true(spec.bank + spec.branch + spec.account <= bban_length)
  }
}
