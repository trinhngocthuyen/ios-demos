# Demo for Swift Testing With xcodebuild

This is a demo for blog post: [Swift Testing and the Compatibility With xcodebuild](https://trinhngocthuyen.com/posts/tech/swift-testing-and-the-compatibility-with-xcodebuild)

## Running the Demo

Build the project
```sh
make build
```

Run tests
```sh
make test
```

## Highlights

Patch: [XCTestConfiguration_Swizzlings.m](/swift-testing-with-xcodebuild/LocalPods/SwiftTestingSupport/Sources/XCTestConfiguration_Swizzlings.m#L20-L32)
- Swizzle `XCTestConfiguration.activeTestConfiguration`
- Loop `testsToRun`, add a new identifier with `()` appended if not exist
- Update `testsToRun` with the added indentifiers

NOTE: This patch is using some XCTest's private headers, from https://github.com/facebook/idb/tree/27fadda/PrivateHeaders/XCTestPrivate
