[![logo][]](https://xyo.network)

# sdk-xyo-client-swift

[![main-build][]][main-build-link]
[![codacy-badge][]][codacy-link]
[![codeclimate-badge][]][codeclimate-link]

> The XYO Foundation provides this source code available in our efforts to advance the understanding of the XYO Protocol and its possible uses. We continue to maintain this software in the interest of developer education. Usage of this source code is not intended for production.

## Table of Contents

- [sdk-xyo-client-swift](#sdk-xyo-client-swift)
  - [Table of Contents](#table-of-contents)
  - [Description](#description)
  - [Instructions](#instructions)
    - [Add Package](#add-package)
    - [Configure API](#configure-api)
    - [Configure Witnesses](#configure-witnesses)
    - [Configure Panel](#configure-panel)
    - [Generate BoundWitness report](#generate-boundwitness-report)
  - [Maintainers](#maintainers)
  - [License](#license)
  - [Credits](#credits)

## Description

Primary SDK for using the XYO Protocol 2.0 from Swift. Designed to work in both Mac OS and iOS.

## Instructions

### Add Package

```swift
dependencies: [
.package(url: "https://github.com/XYOracleNetwork/app-ios-witness-demo-swiftui.git", .upToNextMajor(from: "3.0.0")),
],
```

### Configure API

Setup which network you'd like to write to by configuring the Domain & Archivist Module Name

```swift
let apiDomain = "https://beta.api.archivist.xyo.network"
let archive = "Archivist"
```

### Configure Witnesses

Configure your desired witnesses (Basic, System Info, Location, etc.)

```swift
let basicWitness = BasicWitness {
    Payload("network.xyo.basic")
}
let systemInfoWitness = SystemInfoWitness(allowPathMonitor: true)
let locationWitness = LocationWitness()
```

### Configure Panel

Use the Witnesses & Archivist config to create a Panel

```swift
let panel = XyoPanel(
    account: self.panelAccount,
    witnesses: [
        basicWitness,
        systemInfoWitness,
        locationWitness
    ],
    apiDomain: apiDomain,
    apiModule: apiModule
)
```

### Generate BoundWitness report

Call `.report()` to return the witnessed Payloads

```swift
let payloads =  await panel.report()
```

or, for more detailed information, call `.reportQuery()` to return a `ModuleQuery` result containing the `BoundWitness`, `Payloads`, & any `Errors` (if present)

```swift
let result =  await panel.reportQuery()
let bw = result.bw
let payloads = result.payloads
let errors = result.errors
```

## Maintainers

- [Arie Trouw](https://arietrouw.com/)
- [Joel Carter](https://joelbcarter.com)

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
