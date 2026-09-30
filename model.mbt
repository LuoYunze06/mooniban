///|
pub(all) struct Iban {
  country : String
  check_digits : String
  bban : String
  compact : String
} derive(Eq, Debug)

///|
pub extend Iban with Eq::{equal, not_equal}

///|
pub extend Iban with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub(all) enum IbanError {
  EmptyInput
  InvalidCharset(Int)
  TooShort(Int)
  TooLong(Int)
  InvalidCountry(String)
  UnknownCountry(String)
  LengthMismatch(String, Int, Int)
  BadChecksum(Int)
  BbanPattern(String, Int)
  MissingOperand(String)
  UnknownCommand(String)
} derive(Eq, Debug)

///|
pub extend IbanError with Eq::{equal, not_equal}

///|
pub extend IbanError with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub(all) struct CountrySpec {
  code : String
  length : Int
  bban_pattern : String
  bank : Int
  branch : Int
  account : Int
} derive(Eq, Debug)

///|
pub extend CountrySpec with Eq::{equal, not_equal}

///|
pub extend CountrySpec with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub fn Iban::pretty(self : Iban) -> String {
  pretty_groups(self.compact)
}

///|
pub fn IbanError::code(self : IbanError) -> String {
  match self {
    EmptyInput => "IBAN001"
    InvalidCharset(_) => "IBAN002"
    TooShort(_) => "IBAN003"
    TooLong(_) => "IBAN004"
    InvalidCountry(_) => "IBAN005"
    UnknownCountry(_) => "IBAN006"
    LengthMismatch(_) => "IBAN007"
    BadChecksum(_) => "IBAN008"
    BbanPattern(_) => "IBAN009"
    MissingOperand(_) => "IBAN010"
    UnknownCommand(_) => "IBAN011"
  }
}

///|
pub fn IbanError::message(self : IbanError) -> String {
  match self {
    EmptyInput => "IBAN input is empty"
    InvalidCharset(offset) =>
      "non-alphanumeric character at compact offset \{offset}"
    TooShort(n) => "IBAN length \{n} is shorter than 15"
    TooLong(n) => "IBAN length \{n} is longer than 34"
    InvalidCountry(code) => "country code \{code} is not two letters"
    UnknownCountry(code) => "country \{code} is not in the IBAN registry"
    LengthMismatch(code, expected, actual) =>
      "country \{code} expects length \{expected}, got \{actual}"
    BadChecksum(rem) => "ISO 13616 checksum remainder is \{rem}, expected 1"
    BbanPattern(code, offset) =>
      "BBAN for \{code} does not match the country pattern at offset \{offset}"
    MissingOperand(name) => "missing operand: \{name}"
    UnknownCommand(name) => "unknown command: \{name}"
  }
}
