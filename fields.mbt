///|
fn slice_bban(bban : String, start : Int, len : Int) -> String? {
  if len <= 0 || start < 0 || start + len > bban.length() {
    None
  } else {
    Some(bban[start:start + len].to_owned())
  }
}

///|
pub fn Iban::bank(self : Iban) -> String? {
  match country_spec(self.country) {
    None => None
    Some(spec) => slice_bban(self.bban, 0, spec.bank)
  }
}

///|
pub fn Iban::branch(self : Iban) -> String? {
  match country_spec(self.country) {
    None => None
    Some(spec) => slice_bban(self.bban, spec.bank, spec.branch)
  }
}

///|
pub fn Iban::account(self : Iban) -> String? {
  match country_spec(self.country) {
    None => None
    Some(spec) => {
      let start = spec.bank + spec.branch
      slice_bban(self.bban, start, spec.account)
    }
  }
}

///|
pub fn Iban::spec(self : Iban) -> CountrySpec? {
  country_spec(self.country)
}
