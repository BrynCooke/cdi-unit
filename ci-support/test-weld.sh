#!/usr/bin/env bash

set -ex

BASE_DIR=$(dirname "$0")

if [[ $# -gt 0 ]]; then
  source "$BASE_DIR/$1"
  shift
else
  echo "Please provide the file to source the list of Weld versions to test"
  exit 1
fi

for WELD_VERSION in ${WELD_VERSIONS[*]}; do
  if [[ $WELD_VERSION == 1.* || $WELD_VERSION == 2.* ]]; then
    TEST_OPTS=-Dweld.test.1or2
  else
    TEST_OPTS=
  fi
  "$BASE_DIR/hide-logs.sh" ./mvnw -V -B test \
    --projects cdi-unit-tests-parent,cdi-unit-tests-external-dependency \
    --also-make-dependents \
    -Dweld.test.version="$WELD_VERSION" $TEST_OPTS "$@"
done
