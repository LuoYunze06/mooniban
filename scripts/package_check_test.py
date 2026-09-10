"""Regression cases for the pre-publication archive guard."""
import stat
import unittest
import zipfile
from package_check import REQUIRED, manifest_value, validate_entries


def entries(extra=()):
    return [zipfile.ZipInfo(name) for name in sorted(REQUIRED)] + list(extra)


class PackageAuditTests(unittest.TestCase):
    def test_valid_payload(self):
        validate_entries(entries())

    def test_path_traversal_and_absolute_paths(self):
        for path in ["../secret", "/secret", "C:/secret", "a\\secret", "a/./b", "a//b"]:
            with self.subTest(path=path), self.assertRaises(ValueError):
                entry = zipfile.ZipInfo("placeholder")
                entry.filename = path
                validate_entries(entries([entry]))

    def test_private_and_generated_files(self):
        for path in [
            ".git/config",
            ".moon/credentials.json",
            ".env",
            "id_rsa",
            "submission/application.md",
            "project-申报书.md",
            "old.bundle",
            "_build/output.wasm",
            "key.pem",
            "docs/credentials.json",
        ]:
            with self.subTest(path=path), self.assertRaises(ValueError):
                validate_entries(entries([zipfile.ZipInfo(path)]))

    def test_duplicate_paths(self):
        with self.assertRaises(ValueError):
            validate_entries(entries([zipfile.ZipInfo("readme.md")]))

    def test_symlinks(self):
        link = zipfile.ZipInfo("alias")
        link.external_attr = (stat.S_IFLNK | 0o777) << 16
        with self.assertRaises(ValueError):
            validate_entries(entries([link]))

    def test_missing_readme(self):
        with self.assertRaises(ValueError):
            validate_entries([entry for entry in entries() if entry.filename != "README.md"])

    def test_manifest_field_uniqueness(self):
        self.assertEqual(manifest_value('name = "owner/module"\n', "name"), "owner/module")
        for text in ["", 'name = "a"\nname = "b"\n']:
            with self.assertRaises(ValueError):
                manifest_value(text, "name")


if __name__ == "__main__":
    unittest.main()
