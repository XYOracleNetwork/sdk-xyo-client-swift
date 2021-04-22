[![logo][]](https://xyo.network)

# sdk-xyo-client-swift

[![npm-badge]][npm-link]
[![bch-badge]][bch-link]
[![codacy-badge]][codacy-link]
[![codeclimate-badge]][codeclimate-link]
[![snyk-badge]][snyk-link]

> The XYO Foundation provides this source code available in our efforts to advance the understanding of the XYO Procotol and its possible uses. We continue to maintain this software in the interest of developer education. Usage of this source code is not intended for production.

## Table of Contents

-   [Title](#sdk-xyo-client-swift)
-   [Description](#description)
-   [Instructions](#instructions)
-   [Maintainers](#maintainers)
-   [License](#license)
-   [Credits](#credits)

## Description

Primary SDK for using the XYO Protocol 2.0 from Swift.  Designed to work in both Mac OS and iOS.

## Maintainers

-   Arie Trouw

## License

See the [LICENSE](LICENSE) file for license details

## Credits

Made with 🔥and ❄️ by [XYO](https://xyo.network)

[logo]: https://cdn.xy.company/img/brand/XYO_full_colored.png

[bch-badge]: https://bettercodehub.com/edge/badge/XYOracleNetwork/sdk-xyo-client-swift?branch=master
[bch-link]: https://bettercodehub.com/results/XYOracleNetwork/sdk-xyo-client-swift

[codacy-badge]: https://app.codacy.com/project/badge/Grade/c0ba3913b706492f99077eb5e6b4760c
[codacy-link]: https://www.codacy.com/gh/XYOracleNetwork/sdk-xyo-client-js/dashboard?utm_source=github.com&utm_medium=referral&utm_content=XYOracleNetwork/sdk-xyo-client-swift&utm_campaign=Badge_Grade

[codeclimate-badge]: https://api.codeclimate.com/v1/badges/d051b36c73cd52e4030a/maintainability
[codeclimate-link]: https://codeclimate.com/github/XYOracleNetwork/sdk-xyo-client-swift/maintainability

## Instructions

### Configure Api
```swift
let config = XyoArchivistApiConfig("test", "http://localhost:3030/dev")
let api = XyoArchivistApi.get( XyoArchivistApiConfig("main", "https://archivist.xyo.network"))
```
### Create Bound Witness
```swift
let bw = try BoundWitnessBuilder().payload(<schema>, <payload>).witness("<address>").build()
```
### Send BoundWitness
```swift
try api.postBoundWitness(<bw>) { count, error in
  print("\(count) bound witnesses sent")
}
```

### Send BoundWitnessBatch
```swift
try api.postBoundWitnesses([<bw>]) { count, error in
  print("\(count) bound witnesses sent")
}
```
