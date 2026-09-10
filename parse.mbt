///|
fn match_bban_pattern(bban : String, pattern : String) -> Int? {
  let mut pi = 0
  let mut bi = 0
  while pi < pattern.length() {
    let mut count = 0
    let mut saw_digit = false
    while pi < pattern.length() && is_digit(pattern[pi]) {
      saw_digit = true
      count = count * 10 + (pattern[pi].to_int() - 48)
      pi += 1
    }
    if !saw_digit || count <= 0 || pi >= pattern.length() {
      return Some(bi)
    }
    let cls = pattern[pi]
    pi += 1
    for _ in 0..<count {
      if bi >= bban.length() {
        return Some(bi)
      }
      let c = bban[bi]
      let ok = match cls {
        'n' => is_digit(c)
        'a' => is_letter(c)
        'c' => is_alnum(c)
        _ => false
      }
      if !ok {
        return Some(bi)
      }
      bi += 1
    }
  }
  if bi != bban.length() {
    return Some(bi)
  }
  None
}

///|
fn country_code_ok(compact : String) -> Bool {
  compact.length() >= 2 && is_letter(compact[0]) && is_letter(compact[1])
}

///|
pub fn parse(input : String) -> Result[Iban, IbanError] {
  let compact = compact_text(input)
  if compact.length() == 0 {
    return Err(EmptyInput)
  }
  match charset_offset(compact) {
    Some(offset) => return Err(InvalidCharset(offset))
    None => ()
  }
  if compact.length() < 15 {
    return Err(TooShort(compact.length()))
  }
  if compact.length() > 34 {
    return Err(TooLong(compact.length()))
  }
  if !country_code_ok(compact) {
    return Err(InvalidCountry(compact[0:2].to_owned()))
  }
  if compact.length() < 4 || !is_digit(compact[2]) || !is_digit(compact[3]) {
    return Err(InvalidCharset(2))
  }
  let country = compact[0:2].to_owned()
  match country_spec(country) {
    None => Err(UnknownCountry(country))
    Some(spec) => {
      if compact.length() != spec.length {
        return Err(LengthMismatch(country, spec.length, compact.length()))
      }
      let bban = compact[4:].to_owned()
      match match_bban_pattern(bban, spec.bban_pattern) {
        Some(offset) => Err(BbanPattern(country, offset))
        None => {
          let rem = remainder97(compact)
          if rem != 1 {
            Err(BadChecksum(rem))
          } else {
            Ok({ country, check_digits: compact[2:4].to_owned(), bban, compact })
          }
        }
      }
    }
  }
}

///|
pub fn validate(input : String) -> Result[Iban, IbanError] {
  parse(input)
}
