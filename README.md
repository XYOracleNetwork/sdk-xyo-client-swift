[![logo][]](https://xyo.network)

# sdk-xyo-client-swift

[![main-build][]][main-build-link]
[![codacy-badge][]][codacy-link]
[![codeclimate-badge][]][codeclimate-link]

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

## Instructions

### Add Package
```swift
dependencies: [
.package(url: "https://github.com/XYOracleNetwork/sdk-xyo-client-swift.git", .upToNextMajor(from: "2.0.3")),
],
```

### Configure Api
```swift
let panel = XyoPanel(archive: 'test', apiDomain: "https://api.archivist.xyo.network", witnesses: [XyoSystemInfoWitness()])
```

### Generate BoundWitness report
```swift
panel.report(nil, nil)
```

## Maintainers

-   Arie Trouw

## License

See the [LICENSE](LICENSE) file for license details

## Credits

Made with 🔥 and ❄️ by [XYO](https://xyo.network)

[logo]: https://cdn.xy.company/img/brand/XYO_full_colored.png

[main-build]: https://github.com/XYOracleNetwork/sdk-xyo-client-swift/actions/workflows/build-main.yml/badge.svg
[main-build-link]: https://github.com/XYOracleNetwork/sdk-xyo-client-swift/actions/workflows/build-main.yml

[codacy-badge]: https://app.codacy.com/project/badge/Grade/c0ba3913b706492f99077eb5e6b4760c
[codacy-link]: https://www.codacy.com/gh/XYOracleNetwork/sdk-xyo-client-swift/dashboard?utm_source=github.com&utm_medium=referral&utm_content=XYOracleNetwork/sdk-xyo-client-swift&utm_campaign=Badge_Grade

[codeclimate-badge]: https://api.codeclimate.com/v1/badges/d051b36c73cd52e4030a/maintainability
[codeclimate-link]: https://codeclimate.com/github/XYOracleNetwork/sdk-xyo-client-swift/maintainability
