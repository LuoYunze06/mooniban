"""Build and inspect the actual MoonCakes ZIP without logging in or publishing."""
from pathlib import Path, PurePosixPath
import re
import stat
import subprocess
import zipfile

ROOT = Path(__file__).resolve().parents[1]
REQUIRED = {
    "moon.mod",
    "moon.pkg",
    "mooniban.mbt",
    "model.mbt",
    "parse.mbt",
    "checksum.mbt",
    "registry.mbt",
    "pkg.generated.mbti",
    "README.md",
    "LICENSE",
    "THIRD_PARTY.md",
    "AI_USAGE.md",
    "cmd/mooniban/main.mbt",
    "cmd/mooniban/moon.pkg",
    "examples/api-demo/main.mbt",
    "examples/sample-ibans.txt",
}
BLOCKED_PARTS = {".git", ".moon", ".mooncakes", "_build", "node_modules", "__pycache__"}
BLOCKED_NAMES = {"credentials.json", "automation.toml", "id_rsa", "id_ed25519"}
EXPECTED_NAME = "LuoYunze06/mooniban"
EXPECTED_REPO = "https://github.com/LuoYunze06/mooniban"


def validate_entries(entries):
    """Reject unsafe paths, duplicate names and private/build artifacts."""
    seen = set()
    for entry in entries:
        name = entry.filename
        path = PurePosixPath(name)
        if (
            "\\" in name
            or ":" in name
            or path.is_absolute()
            or any(part in {".", "..", ""} for part in name.rstrip("/").split("/"))
        ):
            raise ValueError("unsafe archive path: " + name)
        key = name.rstrip("/").casefold()
        if key in seen:
            raise ValueError("duplicate archive path: " + name)
        seen.add(key)
        if stat.S_ISLNK(entry.external_attr >> 16):
            raise ValueError("symlink not allowed: " + name)
        parts = {part.casefold() for part in path.parts}
        filename = path.name.casefold()
        if (
            parts & BLOCKED_PARTS
            or filename in BLOCKED_NAMES
            or filename.startswith(".env")
            or filename.endswith((".bundle", ".pem", ".key"))
            or "application" in filename
            or "申报" in filename
        ):
            raise ValueError("private or generated artifact: " + name)
    missing = REQUIRED - {e.filename for e in entries if not e.is_dir()}
    if missing:
        raise ValueError("missing package files: " + ", ".join(sorted(missing)))


def manifest_value(text, key):
    found = re.findall(r"^" + re.escape(key) + r"\s*=\s*\"([^\"\n]*)\"\s*$", text, re.M)
    if len(found) != 1:
        raise ValueError("expected exactly one manifest field: " + key)
    return found[0]


def main():
    manifest = (ROOT / "moon.mod").read_text(encoding="utf-8")
    name = manifest_value(manifest, "name")
    version = manifest_value(manifest, "version")
    if name != EXPECTED_NAME:
        raise ValueError("unexpected module ownership: " + name)
    if not name or not version:
        raise ValueError("empty name or version")
    repository = manifest_value(manifest, "repository")
    if repository not in ("", EXPECTED_REPO):
        raise ValueError("unexpected source repository: " + repository)
    subprocess.run(["moon", "package"], cwd=str(ROOT), check=True)
    archive = ROOT / "_build" / "publish" / (name.replace("/", "-") + "-" + version + ".zip")
    with zipfile.ZipFile(archive) as package:
        validate_entries(package.infolist())
        if package.testzip() is not None:
            raise ValueError("corrupt package CRC")
        for filename in REQUIRED:
            if package.read(filename) != (ROOT / filename).read_bytes():
                raise ValueError("package differs from working tree: " + filename)
        print(
            "Package audit passed:",
            name + "@" + version,
            "(" + str(len(package.infolist())) + " entries; no publication performed)",
        )


if __name__ == "__main__":
    main()
