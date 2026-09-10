///|
fn remainder97(compact : String) -> Int {
  let mut rem = 0
  let n = compact.length()
  for k in 0..<n {
    let i = if k < n - 4 { k + 4 } else { k - (n - 4) }
    let c = compact[i]
    if is_letter(c) {
      rem = (rem * 100 + (c.to_int() - 55)) % 97
    } else {
      rem = (rem * 10 + (c.to_int() - 48)) % 97
    }
  }
  rem
}

///|
pub fn checksum_remainder(input : String) -> Result[Int, IbanError] {
  let compact = compact_text(input)
  if compact.length() == 0 {
    return Err(EmptyInput)
  }
  match charset_offset(compact) {
    Some(offset) => Err(InvalidCharset(offset))
    None =>
      if compact.length() < 5 {
        Err(TooShort(compact.length()))
      } else {
        Ok(remainder97(compact))
      }
  }
}

///|
fn check_digits_from_remainder(rem : Int) -> String {
  let value = 98 - rem
  let hi = value / 10
  let lo = value % 10
  let out = StringBuilder()
  out.write_char((48 + hi).unsafe_to_char())
  out.write_char((48 + lo).unsafe_to_char())
  out.to_string()
}
