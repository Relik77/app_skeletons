#!/bin/bash

{ read version; } < .build-info

env=
api_url=
api_key=
service_key=

if [ $# -gt 0 ]; then
  while [ "$1" != "" ]; do
    case $1 in
      --env )
        shift
        env="$1"
        ;;
      --patch )
        version=$(echo $version | awk -F. '{$NF = $NF + 1;} 1' | sed 's/ /./g')
        ;;
      --minor )
        version=$(echo $version | awk -F. '{$(NF-1) = $(NF-1) + 1;} 1' | sed 's/ /./g')
        version=$(echo $version | awk -F. '{$NF = 0;} 1' | sed 's/ /./g')
        ;;
      --major )
        version=$(echo $version | awk -F. '{$(NF-2) = $(NF-2) + 1;} 1' | sed 's/ /./g')
        version=$(echo $version | awk -F. '{$(NF-1) = 0;} 1' | sed 's/ /./g')
        version=$(echo $version | awk -F. '{$NF = 0;} 1' | sed 's/ /./g')
        ;;
    esac
    shift
  done
fi

if [ -z "$env" ]; then
  export $(grep -v '^#' .env | xargs)
else
  export $(grep -v '^#' .env.${env} | xargs)
fi

build_time=$(date "+%Y-%m-%d %H:%M:%S")

echo "$version" > .build-info

flutter build web --release \
    --dart-define=ENV=${env} \
    --dart-define=BUILD_DATE=${build_time} \
    --dart-define=BUILD_VERSION=${version} \
