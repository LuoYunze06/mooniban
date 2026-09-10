///|
pub fn compact_text(input : String) -> String {
  let out = StringBuilder()
  for i in 0..<input.length() {
    let c = input[i]
    if c == ' ' || c == '\t' || c == '\n' || c == '\r' || c == '-' {
      continue
    }
    out.write_string(input[i:i + 1].to_owned())
  }
  out.to_string().to_upper()
}

///|
pub fn pretty_groups(compact : String) -> String {
  let out = StringBuilder()
  for i in 0..<compact.length() {
    if i > 0 && i % 4 == 0 {
      out.write_char(' ')
    }
    out.write_string(compact[i:i + 1].to_owned())
  }
  out.to_string()
}

///|
fn is_letter(c : UInt16) -> Bool {
  c >= 'A' && c <= 'Z'
}

///|
fn is_digit(c : UInt16) -> Bool {
  c >= '0' && c <= '9'
}

///|
fn is_alnum(c : UInt16) -> Bool {
  is_letter(c) || is_digit(c)
}

///|
fn charset_offset(compact : String) -> Int? {
  for i in 0..<compact.length() {
    if !is_alnum(compact[i]) {
      return Some(i)
    }
  }
  None
}
