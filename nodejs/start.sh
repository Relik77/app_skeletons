#!/bin/bash
working_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

noPull=0
useTags=0
install=0
version=

cd ${working_dir};

touch .package-info
{ read localVersion; read package_date; read options; } < .package-info

if [ "$options" != "" ]; then
    IFS=' ' read -ra options <<< "$options"
    for option in "${options[@]}"; do
        IFS='=' read -ra option <<< "$option"
        declare "${option[0]}"=${option[1]}
    done
fi

if [ $# -gt 0 ]; then
  while [ "$1" != "" ]; do
    case $1 in
      --noPull )
        noPull=1
        ;;
      --install )
        install=1
        ;;
      --version )
        shift
        version="$1"
        ;;
    esac
    shift
  done
fi

latestVersion=$localVersion
if [ "$noPull" = "0" ]; then
  if [ "$useTags" = "1" ]; then
    git fetch --tags

    if [ "$version" = "" ]; then
        latestVersion=$(git describe --match="v[0-9]*" --tags `git rev-list --tags --max-count=1`)
    else
        latestVersion=$version
    fi

    if [ "$latestVersion" = "" ] || [ "$latestVersion" = "$localVersion" ]; then
        exit;
    fi

    git checkout -f $latestVersion
  else
    git pull;
  fi
fi

date=`stat -c %y package.json`
if [ "$install" = "1" ] || [ "$package_date" != "$date" ]; then
  yarn install --production --check-files --frozen-lockfile;
  date=`stat -c %y package.json`
fi

echo "$latestVersion" > .package-info
echo "$date" >> .package-info
echo "useTags=$useTags" >> .package-info

forever restart ${working_dir}/dist/index.js || forever start --sourceDir ${working_dir} --workingDir ${working_dir} dist/index.js;
#forever stop ${working_dir}/dist/index.js;
#forever start --sourceDir ${working_dir} --workingDir ${working_dir} dist/index.js;
