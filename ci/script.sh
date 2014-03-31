#!/bin/bash
set +e

unset SUDO_UID

source ./ci/env
./ci/show-env.sh

if [[ $CI_CONFIG == 'unit' ]]; then
    npm test
elif [[ $CI_CONFIG == 'build' ]]; then
    ./reset.sh --hardcore --dev --ios --android --selendroid --gappium --verbose 
    ./ci/upload_build_to_sauce.sh    
    ./ci/git-push.sh
elif [[ $CI_CONFIG == 'functional' ]]; then
    TARBALL=sauce-storage:$(node ./ci/build-upload-tool.js \
        ./ci/build-upload-info.json filename)

    # echo \
    SAUCE=1 \
    APPIUM_HOST='sebv.dev.saucelabs.net' \
    APPIUM_PORT=4444 \
    TARBALL="${TARBALL}" \
    DEVICE="ios71" \
    VERSION="7.1" \
    ./node_modules/.bin/mocha \
    --recursive \
    -g "@skip-ios71|@skip-ios7|@skip-ios-all" -i \
    $(find test/functional -name "*-specs.js" -print | grep testapp | grep find-element)
fi
