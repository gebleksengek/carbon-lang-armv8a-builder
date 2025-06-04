#!/bin/bash

cutoff_date=$(date -u +"%Y-%m-%dT00:00:00Z")
echo "Caches last accessed before $cutoff_date will be deleted."

gh cache list --json id,key,lastAccessedAt --jq .[] | while read -r cache; do
  id=$(echo "$cache" | jq -r ".id")
  key=$(echo "$cache" | jq -r ".key")
  last_accessed=$(echo "$cache" | jq -r ".lastAccessedAt")
  if [[ "$last_accessed" < "$cutoff_date" ]]; then
    echo "Deleting cache ID: $id (Key: $key, Last Accessed: $last_accessed)"

    gh cache delete "$id"
  fi
done
