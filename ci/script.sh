#!/bin/bash
set -e

source ~/.profile

export IOS_CONCURRENCY=10
export ANDROID_CONCURRENCY=10
export GAPPIUM_CONCURRENCY=10
export SELENDROID_CONCURRENCY=10

export SAUCE_REST_ROOT=https://saucelabs.com/rest/v1
export APPIUM_HOST=ondemand.saucelabs.com
export APPIUM_PORT=80

export HTTP_RETRIES=5
export HTTP_RETRY_DELAY=5000
export DEBUG_CONNECTION=1
export MOCHA_INIT_TIMEOUT=600000
export LAUNCH_TIMEOUT='{"global":90000,"afterSimLaunch":30000}'

if [[ $CI_CONFIG == 'unit' ]]; then
    # cd docs
    # appium_doc_lint || exit 1
    # cd -
    npm test
elif [[ $CI_CONFIG == 'build' ]]; then
    unset SUDO_UID
    ulimit -n 8000
    source ./ci/android_env
    source ./ci/tarball-name.sh

    echo OS X version: `sw_vers -productVersion`
    echo Xcode version: `xcodebuild build -version`
    echo Xcode path: `xcode-select --print-path`
    echo JAVA_HOME: $JAVA_HOME    

    ./reset.sh --ios --dev --no-npmlink
    TARBALL=$TARBALL ./ci/upload_build_to_sauce.sh

    echo "TARBALL=${TARBALL}" > tarball.properties
    # for full build use param below
    # ./reset.sh --ios --android -gappium --selendroid-quick --dev --no-npmlink
    # TARBALL=$TARBALL ./ci/upload_build_to_sauce.sh

elif [[ $CI_CONFIG == 'ios' ]]; then
    npm install
    TARBALL=sauce-storage:$TARBALL \
    ./ci/tools/parallel-mocha.js \
    -p $IOS_CONCURRENCY \
    -c ios
elif [[ $CI_CONFIG == 'android' ]]; then
    npm install
    TARBALL=sauce-storage:$TARBALL \
    ./ci/tools/parallel-mocha.js \
    -p $ANDROID_CONCURRENCY \
    -c android
elif [[ $CI_CONFIG == 'gappium' ]]; then
    npm install
    TARBALL=sauce-storage:$TARBALL \
    ./ci/tools/parallel-mocha.js \
    -p $GAPPIUM_CONCURRENCY \
    -c gappium
elif [[ $CI_CONFIG == 'selendroid' ]]; then
    npm install
    TARBALL=sauce-storage:$TARBALL \
    ./ci/tools/parallel-mocha.js \
    -p $SELENDROID_CONCURRENCY \
    -c selendroid
fi
