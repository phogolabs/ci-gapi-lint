#!/bin/bash

set -e

if [ -n "${GITHUB_WORKSPACE}" ]; then
  cd "${GITHUB_WORKSPACE}" || exit
fi

CONFIG_FILE_OPTION="--set-exit-status"

if [[ -n ${INPUT_PROTO_DIRECTORY} ]]; then
  echo "::debug::Using report file ${INPUT_PROTO_DIRECTORY}"
  CONFIG_FILE_OPTION+=" --proto-path ${INPUT_PROTO_DIRECTORY}"
fi

if [[ -n ${INPUT_DESCRIPTOR_FILE} ]]; then
  echo "::debug::Using descriptor file ${INPUT_DESCRIPTOR_FILE}"
  CONFIG_FILE_OPTION+=" --descriptor-set-in ${INPUT_DESCRIPTOR_FILE}"
fi

if [ -n "${INPUT_CONFIG_FILE}" ]; then
  echo "::debug::Using config file ${INPUT_CONFIG_FILE}"
  CONFIG_FILE_OPTION+=" --config ${INPUT_CONFIG_FILE}"
fi

if [ -n "${INPUT_WORKING_DIRECTORY}" ]; then
  cd "${INPUT_WORKING_DIRECTORY}" || exit
fi

# shellcheck disable=SC2086
api-linter ${INPUT_PROTO_FILE} ${CONFIG_FILE_OPTION}

google_api_linter_return="${PIPESTATUS[0]}"

echo "google-api-linter-return-code=${google_api_linter_return}" >> "$GITHUB_OUTPUT"
