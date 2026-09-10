///|
test "registry contains sepa cores and rejects unknown" {
  assert_eq(@mooniban.country_spec("de").unwrap().length, 22)
  assert_eq(@mooniban.country_spec("GB").unwrap().bban_pattern, "4a6n8n")
  assert_eq(@mooniban.country_spec("ZZ"), None)
  assert_true(@mooniban.registered_countries().length() >= 70)
}

///|
test "additional country samples parse" {
  let samples = [
    "AT611904300234573201", "CH9300762011623852957", "ES9121000418450200051332",
    "IT60X0542811101000000123456", "PT50000201231234567890154", "PL61109010140000071219812874",
    "SE4550000000058398257466", "NO9386011117947",
  ]
  for sample in samples {
    let iban = @mooniban.parse(sample).unwrap()
    assert_eq(iban.compact, sample)
  }
}
