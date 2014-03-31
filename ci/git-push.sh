#!/bin/sh
set +e

CI_IOS71_BRANCH=ci-ios71-${TRAVIS_BRANCH}
UPLOAD_INFO_FILE=ci/build-upload-info.json


# preparing test branch
git branch -f ${CI_IOS71_BRANCH}
git checkout ${CI_IOS71_BRANCH}
cp ci/travis-functional.yml .travis.yml
git add ${UPLOAD_INFO_FILE}
git commit -a -m "ci: preparing test branch for build #${TRAVIS_BUILD_NUMBER}"

# pushing
git push -f origin ${CI_IOS71_BRANCH}:${CI_IOS71_BRANCH}
