"""Exercise real CLI/file IO, not mocks. Run from any directory."""
import argparse
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser()
parser.add_argument("--target", default="wasm-gc", choices=["wasm-gc", "wasm", "js", "native"])
args = parser.parse_args()


def run(operands, expected=None, fails=False):
    cmd = ["moon", "run", "cmd/mooniban", "--target", args.target, "--"] + list(operands)
    result = subprocess.run(cmd, cwd=str(ROOT), capture_output=True, text=True, encoding="utf-8")
    out = result.stdout.strip()
    if fails:
        assert result.returncode != 0 and out.startswith("error:"), (cmd, result.returncode, out, result.stderr)
    else:
        assert result.returncode == 0, (cmd, out, result.stderr)
        if expected is not None:
            assert out == expected, (cmd, out, expected)
    print(" ".join(operands), "PASS")
    return out


run(["validate", "DE89 3704 0044 0532 0130 00"], expected="valid DE89 3704 0044 0532 0130 00")
run(["format", "gb82west12345698765432"], expected="GB82 WEST 1234 5698 7654 32")
run(["build", "NL", "ABNA0417164300"], expected="NL91 ABNA 0417 1643 00")
run(["checksum", "FR1420041010050500013M02606"], expected="remainder=1")
parsed = run(["parse", "DE89 3704 0044 0532 0130 00"])
assert "bank=37040044" in parsed and "account=0532013000" in parsed
explained = run(["explain", "DE88370400440532013000"])
assert "IBAN008" in explained and explained.startswith("invalid compact=")
countries = run(["countries"])
assert "DE" in countries.split(",") and "GB" in countries.split(",")
run(["validate", "DE88370400440532013000"], fails=True)
run(["validate", "--file", "examples/sample-ibans.txt"], expected="valid DE89 3704 0044 0532 0130 00")
with tempfile.TemporaryDirectory(prefix="mooniban-smoke-") as folder:
    missing = Path(folder) / "missing.txt"
    run(["validate", "--file", str(missing)], fails=True)
    empty = Path(folder) / "empty.txt"
    empty.write_text("# only comments\n\n", encoding="utf-8")
    run(["validate", "--file", str(empty)], fails=True)
print("All scenario and invalid-input checks passed:", args.target)
