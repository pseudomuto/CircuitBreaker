#!/usr/bin/env bash

set -o pipefail
xcodebuild test -workspace $WORKSPACE -scheme $SCHEME -sdk $SDK -destination "$DEST" | xcpretty
pod lib lint
