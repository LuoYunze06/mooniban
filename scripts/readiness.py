"""Reproduce the engineering gate; skipping native runtime is explicit, never a pass."""
import argparse
import locale
from pathlib import Path
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser()
parser.add_argument(
    "--skip-native-runtime",
    action="store_true",
    help="Still check native, but do not build/test/run it (no C compiler).",
)
args = parser.parse_args()


def run(*command, tests=False):
    print("+", " ".join(command), flush=True)
    result = subprocess.run(
        command,
        cwd=str(ROOT),
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    output = None
    for encoding in ("utf-8", locale.getpreferredencoding(False), "gbk"):
        try:
            output = result.stdout.decode(encoding)
            break
        except UnicodeDecodeError:
            pass
    if output is None:
        output = result.stdout.decode("utf-8", errors="replace")
    print(output, end="", flush=True)
    if result.returncode:
        raise SystemExit(result.returncode)
    if tests:
        match = re.search(r"Total tests: (\d+), passed: (\d+), failed: (\d+)", output)
        if not match or int(match.group(1)) == 0 or match.group(1) != match.group(2) or match.group(3) != "0":
            raise SystemExit("Test runner must execute a nonzero passing suite")


def interfaces():
    data = {}
    for path in ROOT.rglob("*.mbti"):
        if any(part in ["_build", ".mooncakes"] for part in path.parts):
            continue
        data[str(path.relative_to(ROOT))] = path.read_bytes()
    return data


run(sys.executable, "scripts/check_toolchain.py")
run("moon", "fmt", "--check")
for target in ["wasm-gc", "wasm", "js", "native"]:
    run("moon", "check", "--target", target, "--deny-warn")
    if target == "native" and args.skip_native_runtime:
        print("SKIPPED native build/test/CLI: explicitly requested; not a successful native runtime check")
        continue
    run("moon", "build", "--target", target)
    run("moon", "test", "--target", target, "--deny-warn", tests=True)
    run(sys.executable, "scripts/smoke.py", "--target", target)
    run("moon", "run", "examples/api-demo", "--target", target)
before = interfaces()
run("moon", "info")
if before != interfaces():
    raise SystemExit("Generated interfaces changed; review and commit them before retrying")
run(sys.executable, "-m", "unittest", "discover", "-s", "scripts", "-p", "*_test.py")
run(sys.executable, "scripts/package_check.py")
suffix = " (native runtime explicitly skipped)" if args.skip_native_runtime else " on all four targets"
print("Engineering gate passed" + suffix)
