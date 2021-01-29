#!/bin/sh -l

echo "$(pwd)"

repository=$1
token=$2
outputFile=$3
since=$4
complete=$5
nextTag=$6
filter=$7
labels=$8
includeUntagged=$9
action_path=$10

command=""

if [ -z "$repository" ]; then
    echo "Repository cannot be empty"
    exit 1
else
    command="$command --repository=$repository"
fi

if [ -z "$token" ]; then
    echo "token is empty"
else
    command="$command --token=$token"
fi

if [ "$complete" == "true" ]; then
    command="$command --type=complete"
else
    if [ -z "$since" ]; then
    echo "since is empty"
    else
    command="$command --type=sinceTag"
    command="$command --tag=$since"
    fi
fi

if [ -z "$nextTag" ]; then
    echo "nextTag is empty"
else
    command="$command --next-tag=$nextTag"
fi

if [ -z "$outputFile" ]; then
    echo "outputFile is empty"
else
    command="$command --output=$outputFile"
fi

if [ -z "$filter" ]; then
    echo "filter is empty"
else
    command="$command --filter-reg-ex=$filter"
fi

if [ -z "$labels" ]; then
    echo "labels is empty"
else
    command="$command --labels=$labels"
fi

if [ -z "$includeUntagged" ]; then
    echo "includeUntagged is empty"
else
    command="$command --include-untagged=$includeUntagged"
fi

command="$command --log-console=true"

currentDirectory=$(pwd)

cd /changelog-generator

echo "$(pwd)"
ls
make

cd $currentDirectory

changelog=$(/changelog-generator/changelog generate $command | base64)

echo "::set-output name=changelog::$changelog"