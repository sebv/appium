#!/bin/bash

GIT_COMMIT=$(git rev-parse HEAD)
export TARBALL=appium-${BUILD_NUMBER}-${GIT_COMMIT:0:10}.tar.bz2
