#!/usr/bin/env bash
SCRIPT=$(readlink -f "$0")
DIR=$(dirname "$SCRIPT")
cd $DIR

if [ -z "${ENV}" ]; then
  echo "ENV is not set."
  exit 1
fi

if [ -z "${RUN_DIR}" ]; then
  echo "RUN_DIR is not set."
  exit 1
fi

if [ -z "${MODULE}" ]; then
  echo "MODULE is not set."
  exit 1
fi

if [ -z "${PACKAGE}" ]; then
  echo "PACKAGE is not set."
  exit 1
fi

if [ -z "${CLASS}" ]; then
  echo "CLASS is not set."
  exit 1
fi

if [ -z "${XMS}" ]; then
  echo "XMS is not set."
  exit 1
fi

if [ -z "${XMX}" ]; then
  echo "XMX is not set."
  exit 1
fi

echo "RUN WITH ENV: $ENV"
echo "RUN WITH RUN_DIR: $RUN_DIR"
echo ./jre/bin/java -Xms${XMS} -Xmx${XMX} --module-path "lib" --module  "$MODULE/$PACKAGE.$CLASS"
