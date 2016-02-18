#!/usr/bin/env bash
set -eo pipefail

function test_ios {
  dest="OS=$VERSION,name=iPhone 6"
  xcodebuild test -workspace $WORKSPACE -scheme "$SCHEME" -sdk iphonesimulator$VERSION -destination "$dest" | xcpretty
}

function test_osx {
  xcodebuild test -workspace $WORKSPACE -scheme "$SCHEME" -sdk macosx$VERSION | xcpretty
}

if [ "$PLATFORM" = "ios" ]; then
  test_ios
else
  test_osx
fi

pod lib lint
