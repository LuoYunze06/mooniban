///|
pub fn IbanError::format(self : IbanError) -> String {
  "\{self.code()}: \{self.message()}"
}

///|
pub fn explain(input : String) -> String {
  let compact = compact_text(input)
  match parse(input) {
    Ok(iban) => {
      let bank = match iban.bank() {
        Some(v) => v
        None => "-"
      }
      let branch = match iban.branch() {
        Some(v) => v
        None => "-"
      }
      let account = match iban.account() {
        Some(v) => v
        None => "-"
      }
      "valid compact=\{iban.compact} pretty=\{iban.pretty()} country=\{iban.country} check=\{iban.check_digits} bban=\{iban.bban} bank=\{bank} branch=\{branch} account=\{account}"
    }
    Err(err) => "invalid compact=\{compact} \{err.format()}"
  }
}
