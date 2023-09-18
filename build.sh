set -ex

TAG=$1

if [ ! -z "IMAGE_BUILD" ]; then
  IMAGE_BUILD="docker build"
fi


if [ ! -z "APP_NAME" ]; then
  APP_NAME="app"
  echo "Using default app name can be dangerous! Beware!"
  echo "If that is purposeful, it is recommended that you provide that value explicitly"
fi


if [ -z "$TAG" ]; then
  echo "Usage: ./build.sh TAG"
  echo "TAG argument is required"
  exit 1
fi

if [ ! -f ./Dockerfile ]; then
  echo "No Dockerfile found in current directory:"
  pwd
  exit 1
fi

$IMAGE_BUILD . -t $TAG --build-arg APP_NAME=$APP_NAME
