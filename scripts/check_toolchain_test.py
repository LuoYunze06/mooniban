import unittest

from check_toolchain import MINIMUM_MOONC, parse_moonc_version


class ToolchainVersionTests(unittest.TestCase):
    def test_parses_release_with_commit_suffix(self):
        output = "moon 0.1.20260920\nmoonc v0.10.14+7d59c7ec9 (2026-09-18)\n"
        self.assertEqual(parse_moonc_version(output), (0, 10, 14))

    def test_rejects_output_without_moonc(self):
        with self.assertRaisesRegex(ValueError, "could not find moonc"):
            parse_moonc_version("moon 0.1.20260920\n")

    def test_floor_matches_acceptance_guide(self):
        self.assertEqual(MINIMUM_MOONC, (0, 10, 14))


if __name__ == "__main__":
    unittest.main()
