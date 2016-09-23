#!/bin/bash
set -e
set -x
export TAG=$2
export REPO=$1
export VERSION=$3
export BUCKET=$4
GCLOUD_CMD="gcloud"
if [ -n "$5" ]
then
  GCLOUD_CMD=$5
fi

if [ "$VERSION" == "jessie" ]
then
  export VERSION_NUMBER=8
else
  echo "Invalid version $VERSION"
  exit 1
fi

envsubst '${REPO} ${TAG} ${VERSION} ${VERSION_NUMBER}' <cloudbuild_test.yaml.in >cloudbuild_test.yaml
$GCLOUD_CMD alpha container builds create . --config=cloudbuild_test.yaml --verbosity=info --gcs-source-staging-dir=gs://$BUCKET/staging --gcs-log-dir=gs://$BUCKET/logs