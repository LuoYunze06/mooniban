///|
pub fn build(country : String, bban : String) -> Result[Iban, IbanError] {
  let cc = compact_text(country)
  let bb = compact_text(bban)
  if cc.length() != 2 || !is_letter(cc[0]) || !is_letter(cc[1]) {
    return Err(InvalidCountry(cc))
  }
  match charset_offset(bb) {
    Some(offset) => return Err(InvalidCharset(offset))
    None => ()
  }
  match country_spec(cc) {
    None => Err(UnknownCountry(cc))
    Some(spec) => {
      let total = 4 + bb.length()
      if total != spec.length {
        return Err(LengthMismatch(cc, spec.length, total))
      }
      match match_bban_pattern(bb, spec.bban_pattern) {
        Some(offset) => Err(BbanPattern(cc, offset))
        None => {
          let probe = cc + "00" + bb
          let digits = check_digits_from_remainder(remainder97(probe))
          parse(cc + digits + bb)
        }
      }
    }
  }
}

///|
pub fn check_digits_for(
  country : String,
  bban : String,
) -> Result[String, IbanError] {
  match build(country, bban) {
    Ok(iban) => Ok(iban.check_digits)
    Err(err) => Err(err)
  }
}
