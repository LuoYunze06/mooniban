///|
pub fn run_command(args : Array[String]) -> Result[String, IbanError] {
  if args.is_empty() {
    return Err(MissingOperand("command"))
  }
  match args[0] {
    "validate" =>
      if args.length() < 2 {
        Err(MissingOperand("iban"))
      } else {
        match parse(args[1]) {
          Ok(iban) => Ok("valid \{iban.pretty()}")
          Err(err) => Err(err)
        }
      }
    "format" =>
      if args.length() < 2 {
        Err(MissingOperand("iban"))
      } else {
        match parse(args[1]) {
          Ok(iban) => Ok(iban.pretty())
          Err(err) => Err(err)
        }
      }
    "parse" =>
      if args.length() < 2 {
        Err(MissingOperand("iban"))
      } else {
        match parse(args[1]) {
          Ok(_) => Ok(explain(args[1]))
          Err(err) => Err(err)
        }
      }
    "explain" =>
      if args.length() < 2 {
        Err(MissingOperand("iban"))
      } else {
        Ok(explain(args[1]))
      }
    "build" =>
      if args.length() < 3 {
        Err(MissingOperand("country-and-bban"))
      } else {
        match build(args[1], args[2]) {
          Ok(iban) => Ok(iban.pretty())
          Err(err) => Err(err)
        }
      }
    "checksum" =>
      if args.length() < 2 {
        Err(MissingOperand("iban"))
      } else {
        match checksum_remainder(args[1]) {
          Ok(rem) => Ok("remainder=\{rem}")
          Err(err) => Err(err)
        }
      }
    "countries" => Ok(registered_countries().join(","))
    other => Err(UnknownCommand(other))
  }
}
