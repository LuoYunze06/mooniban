"""Enforce the compiler floor required by the September 2026 acceptance guide."""
from __future__ import annotations

import locale
import re
import subprocess
from typing import Tuple

MINIMUM_MOONC = (0, 10, 14)


def parse_moonc_version(output: str) -> Tuple[int, int, int]:
    match = re.search(r"(?m)^moonc v(\d+)\.(\d+)\.(\d+)(?:[+\s]|$)", output)
    if not match:
        raise ValueError("could not find moonc semantic version in `moon version --all`")
    return tuple(int(part) for part in match.groups())


def decode_output(data: bytes) -> str:
    for encoding in ("utf-8", locale.getpreferredencoding(False)):
        try:
            return data.decode(encoding)
        except UnicodeDecodeError:
            pass
    return data.decode("utf-8", errors="replace")


def main() -> None:
    result = subprocess.run(
        ["moon", "version", "--all"],
        check=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    output = decode_output(result.stdout)
    print(output, end="")
    actual = parse_moonc_version(output)
    if actual < MINIMUM_MOONC:
        required = ".".join(str(part) for part in MINIMUM_MOONC)
        found = ".".join(str(part) for part in actual)
        raise SystemExit(f"moonc {found} is below the required {required}")
    print("MoonBit compiler floor satisfied:", ".".join(str(part) for part in actual))


if __name__ == "__main__":
    main()
