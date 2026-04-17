#!/usr/bin/env bash

set -euo pipefail

REGISTRY="${GHCR_REGISTRY:-ghcr.io}"
IMAGE_NAME="${DEVCONTAINER_IMAGE_NAME:-ghcr.io/nziswano/wp-devcontainer:latest}"
PLATFORM="${DEVCONTAINER_PLATFORM:-linux/arm64}"
WORKSPACE_FOLDER="${DEVCONTAINER_WORKSPACE_FOLDER:-.}"

if [[ -n "${DEVCONTAINER_SBOM:-}" ]]; then
  SBOM_VALUE="${DEVCONTAINER_SBOM}"
elif [[ "${PLATFORM}" == *,* ]]; then
  SBOM_VALUE="false"
else
  SBOM_VALUE="true"
fi

if [[ -n "${DEVCONTAINER_PROVENANCE:-}" ]]; then
  PROVENANCE_VALUE="${DEVCONTAINER_PROVENANCE}"
elif [[ "${PLATFORM}" == *,* ]]; then
  PROVENANCE_VALUE="false"
else
  PROVENANCE_VALUE="true"
fi

if [[ -n "${INSTALL_OPTIONAL_CLI_TOOLS:-}" ]]; then
  OPTIONAL_CLI_TOOLS_VALUE="${INSTALL_OPTIONAL_CLI_TOOLS}"
elif [[ "${PLATFORM}" == *,* ]]; then
  OPTIONAL_CLI_TOOLS_VALUE="0"
else
  OPTIONAL_CLI_TOOLS_VALUE="1"
fi

export INSTALL_OPTIONAL_CLI_TOOLS="${OPTIONAL_CLI_TOOLS_VALUE}"
export DEVCONTAINER_SBOM="${SBOM_VALUE}"
export DEVCONTAINER_PROVENANCE="${PROVENANCE_VALUE}"

if [[ -z "${GITHUB_USERNAME:-}" ]]; then
  echo "Error: GITHUB_USERNAME is not set."
  echo "Set it with: export GITHUB_USERNAME=your-github-username"
  exit 1
fi

if [[ -z "${GITHUB_TOKEN:-}" ]]; then
  echo "Error: GITHUB_TOKEN is not set."
  echo "Set it with: export GITHUB_TOKEN=your-github-token"
  exit 1
fi

echo "Logging in to ${REGISTRY} as ${GITHUB_USERNAME}..."
echo "${GITHUB_TOKEN}" | docker login "${REGISTRY}" -u "${GITHUB_USERNAME}" --password-stdin

echo "Building and pushing devcontainer image: ${IMAGE_NAME}"
echo "INSTALL_OPTIONAL_CLI_TOOLS=${INSTALL_OPTIONAL_CLI_TOOLS}"
echo "DEVCONTAINER_SBOM=${DEVCONTAINER_SBOM}"
echo "DEVCONTAINER_PROVENANCE=${DEVCONTAINER_PROVENANCE}"

ATTEMPT=1
MAX_ATTEMPTS="${DEVCONTAINER_BUILD_RETRIES:-3}"
while true; do
  if devcontainer build --image-name "${IMAGE_NAME}" --push true --platform "${PLATFORM}" --workspace-folder "${WORKSPACE_FOLDER}"; then
    break
  fi

  EXIT_CODE=$?
  if [[ "${ATTEMPT}" -ge "${MAX_ATTEMPTS}" ]]; then
    echo "Build failed after ${ATTEMPT} attempts."
    exit "${EXIT_CODE}"
  fi

  WAIT_SECONDS=$((ATTEMPT * 10))
  echo "Build attempt ${ATTEMPT} failed with exit code ${EXIT_CODE}. Retrying in ${WAIT_SECONDS}s..."
  ATTEMPT=$((ATTEMPT + 1))
  sleep "${WAIT_SECONDS}"
done

echo "Done."
