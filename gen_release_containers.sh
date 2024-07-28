#!/usr/bin/env bash
latest_tag=$(git describe --tags --abbrev=0 --always )
previous_tag=$(git describe --tags --abbrev=0 $latest_tag^ 2>/dev/null)

if [[ -z $previous_tag ]]; then
    previous_tag=$(git rev-list --max-parents=0 HEAD)
fi

git diff --name-only "$previous_tag" "$latest_tag" | grep -v -e ".git" -e "README" | while IFS= read -r line; do
    dirname=$(dirname "$line")
    echo "$dirname"
done | sort -u