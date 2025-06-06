#!/usr/bin/env bash
set -x

latest_tag=$(git describe --tags --abbrev=0 --always)
previous_tag=$(git describe --tags --abbrev=0 "$latest_tag"^ 2>/dev/null)

if [[ -z $previous_tag ]]; then
    previous_tag=$(git rev-list --max-parents=0 HEAD)
fi

git diff --name-status --diff-filter=AM "$previous_tag" "$latest_tag" |\
    awk '{print $2}' |\
    grep -v -e ".git" -e "README" -e "gen_release_containers.sh" -e "gen_tag.sh" -e "java" -e "\." |\
    while IFS= read -r line; do
        dirname=$(dirname "$line")
        echo "$dirname"
    done | sort -u