# xl1-compat

JS-side cross-SDK test vector generator. The authoritative XYO JS SDKs
(`@xyo-network/*`) and the XL1 protocol model are the source of truth for
protocol behavior; this script samples their output and freezes it into
`jsCompatVectors.json`, which the Swift test suites assert against.

This is a faithful port of the Android SDK's `xl1-compat/generate-vectors.mjs`.

## Regenerating the vectors

```bash
cd xl1-compat
npm install
npm run generate
```

This writes the vector file to **both** Swift test resource bundles:

- `../Tests/XyoClientTests/Resources/jsCompatVectors.json`
- `../Tests/XyoChainProtocolTests/Resources/jsCompatVectors.json`

Both files are committed to the repo. Regenerating them is a deliberate act:
the vectors are a frozen contract between the JS and Swift SDKs at the pinned
package versions listed in `package.json`. When the output diverges, the Swift
side must be re-verified against the new vectors.

## Sections

- `accounts` — fixed private keys → public key / address / RFC6979-deterministic
  signatures over fixed message hashes.
- `hd_wallets` — BIP-44 Ethereum-style derivations from fixed mnemonics.
- `payload_hashes` — raw payload JSON → `data_hash` (`$` and `_` meta stripped)
  and `hash` (only `_` stripped).
- `bound_witnesses` — full BoundWitness round-trip: fields, `data_hash`,
  `signatures`, and `root_hash` (full hash including `$signatures`).
- `xl1_amounts` — XL1 denomination conversion arithmetic.
