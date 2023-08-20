#!/bin/bash
set -e

mkdir -p .artifacts

install_tools() {
    which cicd &> /dev/null || python3 -m pip install -U seeeye
    which xcparse &> /dev/null || (echo "Installing xcparse" && brew install chargepoint/xcparse/xcparse)
}

install_tools

rm -rf DerivedData/Logs/Test .artifacts/logs .artifacts/xcparse
mkdir -p .artifacts/logs .artifacts/xcparse

exec_build() {
    cicd ios build \
        --build-for-testing \
        --derived-data-path DerivedData \
        --log-path .artifacts/xcodebuild_build.txt
}

exec_test() {
    local n_suites=1
    local n_tests=1
    local xctestrun=$(find DerivedData -name '*.xctestrun')
    local only_testing=()
    local suite_ids=(A B C)
    local test_ids=(1 2 3)
    for suite_id in ${suite_ids[@]}; do
        for test_id in ${test_ids[@]}; do
            local test_name="test${suite_id}${test_id}"
            local suite_name="TestCase${suite_id}"
            local suite_name="TestCase${suite_id}_${test_name}"
            only_testing+=(
                "--only-testing EXUITests/${suite_name}/${test_name}"
            )
        done
    done
    cicd ios test \
        --test-without-building \
        --derived-data-path DerivedData \
        --parallel-testing-workers 2 \
        ${only_testing[@]} \
        --log-path .artifacts/xcodebuild_test.txt || true

    find DerivedData/Logs/Test -name "*.xcresult" -exec xcparse logs "{}" .artifacts/xcparse \;

    # Process xcresult logs
    collect_test_log StandardOutputAndStandardError.txt
    collect_test_log scheduling.log
}

collect_test_log() {
    find .artifacts/xcparse -name "$1" -exec cp "{}" .artifacts/logs/$1 \;
}

exec_$1
