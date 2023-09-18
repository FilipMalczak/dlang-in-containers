set -ex

TAG=$1

if [ -z "$CONTAINER_CREATE" ]; then
  CONTAINER_CREATE="docker create"
fi

if [ -z "$FILE_CP" ]; then
  FILE_CP="docker cp"
fi

if [ -z "$CONTAINER_RM" ]; then
  CONTAINER_RM="docker rm"
fi


if [ -z "$MAKE_NAME" ]; then
  MAKE_NAME="date +%s"
fi

if [ -z "$APP_NAME" ]; then
  APP_NAME="app"
  echo "Using default app name can be dangerous! Beware!"
  echo "If that is purposeful, it is recommended that you provide that value explicitly"
fi

if [ -z "$TAG" ]; then
  echo "Usage: ./build.sh TAG"
  echo "TAG argument is required"
  exit 1
fi

CONTAINER_NAME=$($MAKE_NAME)
$CONTAINER_CREATE --name $CONTAINER_NAME $TAG --entrypoint bash
$FILE_CP -L $CONTAINER_NAME:/dapp/$APP_NAME ./$APP_NAME
$CONTAINER_RM $CONTAINER_NAME
