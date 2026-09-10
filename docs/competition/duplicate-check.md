# MoonIBAN duplication check

- Check date: 2026-09-10
- Recheck date: 2026-09-10
- Candidate: MoonIBAN — original MoonBit library for ISO 13616 International Bank Account Number normalization, charset/length checking, mod-97 checksums, BBAN character-class validation, check-digit generation, and bank/branch/account field extraction
- Official assistant: invoked local $osc2026-guide (https://github.com/Milky2018/osc2026-guide/). The bundled research guide requires `moon search <keyword>`. This toolchain is moon 0.1.20260713 / moonc v0.10.4+2cc641edf and **does not provide moon search** (`Error: no such subcommand: search`; `moon-search` is not on PATH). The limitation is preserved; no fabricated moon search output is claimed.
- MoonCakes evidence source: local index `%USERPROFILE%\.moon\registry\index\user` plus package URLs under https://mooncakes.io/docs/<package>
- GitHub evidence source: `gh api search/repositories` and `gh api search/code`

## Search terms

iban, IBAN, bban, BBAN, ISO 13616, iso13616, mod 97, mod97, checksum, bank account, SEPA account, SWIFT account number, json patch, json pointer, RFC 6901, RFC 6902, RFC 7386, merge patch, structured field, RFC 9651, open location code, plus code, geohash

## osc2026-guide / MoonCakes results

moon search unavailable. Index grep and documentation URLs:

| Package | URL | Overlap |
| --- | --- | --- |
| Freesia666/moonjsonpath | https://mooncakes.io/docs/Freesia666/moonjsonpath | JSON Pointer + JSONPath + Pointer Patch. Direct collision with a JSON Patch candidate; **not** IBAN. |
| tiye/recollect | https://mooncakes.io/docs/tiye/recollect | Structural JSON diff/patch PatchOp sequences. Blocks JSON Patch; not IBAN. |
| moonbit-community/jsondiff | https://github.com/moonbit-community/jsondiff | Structural JSON diff rendering. |
| caassien/jsonpath | https://mooncakes.io/docs/caassien/jsonpath | JSONPath query engine. |
| ppyj663/moon-jsonpath | https://mooncakes.io/docs/ppyj663/moon-jsonpath | RFC 9535 JSONPath subset. |
| bobzhang/moonjq | https://mooncakes.io/docs/bobzhang/moonjq | jq query language. |
| 6P66006/moon-sfv | https://mooncakes.io/docs/6P66006/moon-sfv | RFC 9651 Structured Field Values. Blocks that backup topic. |
| lwmvr/moonbit-fixedincome | https://mooncakes.io/docs/lwmvr/moonbit-fixedincome | Bond cash-flow generation/pricing. Finance-adjacent, different core loop. |
| NBB2006/routeweave | https://mooncakes.io/docs/NBB2006/routeweave | GeoJSON/route encoding. Adjacent only to unused OLC backup. |
| fan-ere/moonbarcode | MoonCakes index | EAN/UPC/GTIN barcodes, not IBAN. |
| IBAN / BBAN / ISO 13616 / mod-97 | local index | **No matching package name or description.** |

## GitHub / MoonBit repositories

- No repository named mooniban / moon-iban / iban-moonbit with an IBAN library description.
- Code search `iban language:MoonBit` hits SekibanWasmRuntime (CQRS framework name) and generated Win32 bindings, not ISO 13616.
- xubowen1234/moonledger is double-entry journals and trial balances (registry original MoonLedger).
- Freesia666/moonjsonpath README confirms Pointer Patch operations and explicitly does not claim full RFC 6902; still occupies JSON document mutation-by-pointer.

## Registry originals compared

MoonLedger reserved identity is journal posting and trial-balance reporting. MoonEDI is ANSI X12 envelopes. MoonWire is length-prefixed frames. MoonCookie/MoonINI/MoonPetri are unrelated. None reserve IBAN checksums or BBAN country structures.

## Overlap judgment

- MoonJsonPatch: **high overlap**, rejected.
- MoonOLC: low direct overlap; unused backup.
- MoonIBAN: **no directly overlapping mature MoonBit IBAN project**. Adjacent finance packages do not validate IBANs.

## Differentiation

MoonIBAN accepts compact or grouped IBAN text, rearranges country/check digits for ISO 13616 mod-97, checks country length and BBAN n/a/c patterns, and can rebuild check digits. It does not post ledgers, price bonds, speak SWIFT FIN, or call banks.

## Decision

Select **MoonIBAN** as an original ISO 13616 implementation. Not a source port of a specific IBAN library. Country lengths/patterns are independently encoded public identifier facts, not a copy of the SWIFT IBAN Registry publication. Do not publish to mooncakes.io in this workflow.

## Final decision

Proceed with local implementation in `C:\Users\42673\Desktop\工作区\随用随清\mooniban`. GitHub owner/contributor is LuoYunze06 after local readiness.
