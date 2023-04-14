#!/bin/bash
set -e

mkdir -p .artifacts

install_tools() {
    which xcparse &> /dev/null || (echo "Installing xcparse" && brew install chargepoint/xcparse/xcparse)
}

install_tools

rm -rf DerivedData/Logs/Test tmp/logs
mkdir -p .artifacts tmp/logs
PROJECT_NAME=EX
XCB_ARGS=(
    -derivedDataPath DerivedData
    -configuration Debug
    -sdk iphonesimulator
    -destination 'platform=iOS Simulator,name=iPhone 8'
)

exec_build() {
    xcodebuild \
        "${XCB_ARGS[@]}" \
        -project ${PROJECT_NAME}.xcodeproj \
        -scheme ${PROJECT_NAME} \
        build-for-testing \
        | tee .artifacts/xcodebuild_build.txt \
        | xcpretty
}

exec_test() {
    local n_testcases=1
    local n_tests=1
    local xctestrun=$(find DerivedData -name '*.xctestrun')
    local only_testing=()
    local testcase_ids=(A) # (A B C)
    local test_ids=(1) # (1 2 3)
    for testcase_id in ${testcase_ids[@]}; do
        for test_id in ${test_ids[@]}; do
            only_testing+=(
                "-only-testing:EXUITests/TestCase${testcase_id}/test${testcase_id}${test_id}"
            )
        done
    done
    xcodebuild \
        "${XCB_ARGS[@]}" \
        ${only_testing[@]} \
        -xctestrun ${xctestrun} \
        test-without-building \
        | tee .artifacts/xcodebuild_test.txt \
        | xcpretty

    find DerivedData/Logs/Test -name "*.xcresult" -exec xcparse logs "{}" tmp/logs \;

    # Process xcresult logs
    collect_test_log StandardOutputAndStandardError.txt
    collect_test_log scheduling.log
}

collect_test_log() {
    find tmp/logs -name "$1" -exec cp "{}" tmp/logs/$1 \;
}

exec_$1
