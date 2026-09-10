///|
fn usage() -> String {
  "usage: mooniban <validate|format|parse|explain|build|checksum|countries> [operands]\n       mooniban validate --file PATH"
}

///|
fn first_payload_line(text : String) -> Result[String, @iban.IbanError] {
  let mut start = 0
  let n = text.length()
  let mut i = 0
  while i <= n {
    if i == n || text[i] == '\n' || text[i] == '\r' {
      let raw = text[start:i].to_owned()
      let mut j = 0
      while j < raw.length() && (raw[j] == ' ' || raw[j] == '\t') {
        j += 1
      }
      if j < raw.length() && raw[j] != '#' {
        return Ok(raw)
      }
      if i < n && text[i] == '\r' && i + 1 < n && text[i + 1] == '\n' {
        i += 2
      } else {
        i += 1
      }
      start = i
      continue
    }
    i += 1
  }
  Err(@iban.EmptyInput)
}

///|
fn fail(err : @iban.IbanError) -> Unit {
  println("error: \{err.format()}")
  @sys.exit(2)
}

///|
fn dispatch(args : Array[String]) -> Unit {
  let mut command = args
  if command.length() >= 3 && command[0] == "validate" && command[1] == "--file" {
    let text = @fs.read_file_to_string(command[2]) catch {
      _ => {
        println("error: unable to read input file")
        @sys.exit(2)
        return
      }
    }
    match first_payload_line(text) {
      Ok(iban) => command = ["validate", iban]
      Err(err) => {
        fail(err)
        return
      }
    }
  }
  match @iban.run_command(command) {
    Ok(text) => println(text)
    Err(err) => fail(err)
  }
}

///|
fn main {
  let args = command_args()
  if args.length() < 2 {
    println(usage())
    @sys.exit(2)
    return
  }
  let rest : Array[String] = []
  for i in 1..<args.length() {
    rest.push(args[i])
  }
  dispatch(rest)
}

///|
#cfg(target="js")
fn command_args() -> Array[String] {
  @env.args()[1:].to_owned()
}

///|
#cfg(not(target="js"))
fn command_args() -> Array[String] {
  @env.args()
}
