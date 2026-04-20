#!/bin/bash
# Build phase: compile, embed, and code-sign :shared for the current Xcode destination.
# In Xcode: add a "Run Script" phase *above* "Compile Sources", and call:
#   "$SRCROOT/embed-shared-framework.sh"
#
# Requires ENABLE_USER_SCRIPT_SANDBOXING = NO on the app target (or the phase cannot run Gradle).
set -euo pipefail

if [ "${SKIP_KMP_BUILD:-}" = "YES" ] || [ "${OVERRIDE_KOTLIN_BUILD_IDE_SUPPORTED:-}" = "YES" ]; then
  echo "Skipping :shared:embedAndSignAppleFrameworkForXcode (SKIP_KMP_BUILD or OVERRIDE_KOTLIN_BUILD_IDE_SUPPORTED is YES)"
  exit 0
fi

: "${SRCROOT:?SRCROOT must be set (build from Xcode)}"
REPO_ROOT="$(cd "${SRCROOT}/.." && pwd)"
cd "$REPO_ROOT"

REQUIRED_ENV_VARS=(
  CONFIGURATION
  SDK_NAME
  ARCHS
  FRAMEWORK_SEARCH_PATHS
  BUILT_PRODUCTS_DIR
  TARGET_BUILD_DIR
)

echo "Xcode env used by :shared:embedAndSignAppleFrameworkForXcode:"
for VAR_NAME in "${REQUIRED_ENV_VARS[@]}"; do
  VAR_VALUE="${!VAR_NAME:-}"
  if [ -z "${VAR_VALUE}" ]; then
    echo "  ${VAR_NAME}=(empty)"
  else
    echo "  ${VAR_NAME}=${VAR_VALUE}"
  fi
done

if [ -n "${GRADLE_MAX_WORKERS:-}" ]; then
  MAX_WORKERS="${GRADLE_MAX_WORKERS}"
  echo "Using GRADLE_MAX_WORKERS=${MAX_WORKERS}"
else
  if command -v sysctl >/dev/null 2>&1; then
    TOTAL_CORES="$(sysctl -n hw.ncpu)"
  elif command -v nproc >/dev/null 2>&1; then
    TOTAL_CORES="$(nproc)"
  else
    TOTAL_CORES=4
  fi
  MAX_WORKERS=$(( TOTAL_CORES * 9 / 10 ))
  [ "${MAX_WORKERS}" -lt 2 ] && MAX_WORKERS=2
  [ "${MAX_WORKERS}" -gt 8 ] && MAX_WORKERS=8
  echo "Auto-detected ${TOTAL_CORES} cores → --max-workers=${MAX_WORKERS}"
fi

[ -n "${GRADLE_OPTS:-}" ] && export GRADLE_OPTS

KOTLIN_OPTS=()
if [ -n "${KOTLIN_COMPILER_IN_PROCESS:-}" ]; then
  KOTLIN_OPTS=(-Dkotlin.compiler.execution.strategy=in-process)
  echo "Kotlin compiler: in-process (raise GRADLE_OPTS -Xmx if needed)"
elif [ -n "${KOTLIN_DAEMON_JVM_ARGS:-}" ]; then
  KOTLIN_OPTS=(-Dkotlin.daemon.jvmargs="${KOTLIN_DAEMON_JVM_ARGS}")
  echo "Kotlin daemon JVM args: ${KOTLIN_DAEMON_JVM_ARGS}"
fi

echo "Running Gradle :shared:embedAndSignAppleFrameworkForXcode from ${REPO_ROOT}"
# shellcheck disable=SC2086
exec "${REPO_ROOT}/gradlew" :shared:embedAndSignAppleFrameworkForXcode \
  "${KOTLIN_OPTS[@]}" \
  --build-cache \
  --parallel \
  --max-workers="${MAX_WORKERS}" \
  -Dorg.gradle.caching=true \
  -Dorg.gradle.parallel=true \
  -Dorg.gradle.daemon=true \
  -Dkotlin.incremental=true \
  -Dkotlin.incremental.native=true
