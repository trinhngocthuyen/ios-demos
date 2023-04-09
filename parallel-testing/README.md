# Demo for Parallel Testing

Ref: https://engineering.grab.com/tackling-ui-test-execution-time-imbalance-for-xcode-parallel-testing

Disclaimer: The logic was broken in some recent Xcode/iOS releases.

To run the demo
```sh
make test
```

### Issues

`XCTestSuite.init(name:)` was not picked up by `XCTest` if we passed the unexpected test identifier in the `-only-testing` argument of the `xcodebuild` command.
