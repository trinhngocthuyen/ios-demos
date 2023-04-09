#!/bin/bash
set -e

mkdir -p .artifacts

install_tools() {
    which xcparse &> /dev/null || (echo "Installing xcparse" && brew install chargepoint/xcparse/xcparse)
}

install_tools

rm -rf DerivedData/Logs/Test tmp/logs
mkdir -p .artifacts tmp/logs

ONLY_TESTING=(
    -only-testing:EXUITests/TestCaseA_testA1/testA1
    # -only-testing:EXUITests/TestCaseA_testA1/testA1
    # -only-testing:EXUITests/TestCaseA_testA2/testA2
    # -only-testing:EXUITests/TestCaseA_testA3/testA3
    # -only-testing:EXUITests/TestCaseB_testB1/testB1
    # -only-testing:EXUITests/TestCaseB_testB2/testB2
    # -only-testing:EXUITests/TestCaseB_testB3/testB3
    # -only-testing:EXUITests/TestCaseC_testC1/testC1
    # -only-testing:EXUITests/TestCaseC_testC2/testC2
    # -only-testing:EXUITests/TestCaseC_testC3/testC3
)

xcodebuild \
    -derivedDataPath DerivedData \
    -configuration Debug \
    -sdk iphonesimulator \
    -destination 'platform=iOS Simulator,name=iPhone 8' \
    -project EX.xcodeproj \
    -scheme EX \
    -parallel-testing-enabled YES \
    -parallel-testing-worker-count 2 \
    ${ONLY_TESTING[@]} \
    test \
    | tee .artifacts/xcodebuild_test.txt

# Process xcresult logs
find DerivedData/Logs/Test -name "*.xcresult" -exec xcparse logs "{}" tmp/logs \;

collect_log() {
    find tmp/logs -name "$1" -exec cp "{}" tmp/logs/$1 \;
}

collect_log StandardOutputAndStandardError.txt
collect_log scheduling.log
