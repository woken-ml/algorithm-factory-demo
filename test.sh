#!/bin/bash

exit_trap () {
    [[ $? -eq 0 ]] || echo "A test has failed. Please verify that you followed all installation steps correctly." 1>&2
}

trap exit_trap EXIT
set -e

echo "Woken Test 1: Get data"
output=$(docker-compose run --rm tester ./query-data.sh -h)

response=$( echo "$output" | head -n 1)
[[ "$response" == *"OK"* ]] && echo "Successful!" || { echo "Failed test 1:\n$output" 1>&2 ; exit 1; }

echo "Woken Test 2: Get list of methods"

output=$(docker-compose run --rm tester ./query-list-methods.sh -h)
response=$( echo "$output" | head -n 1)
[[ "$response" == *"OK"* ]] && echo "Successful!" || { echo "Failed test 2:\n$output" 1>&2 ; exit 1; }

echo "Woken Test 3: Run a simple algorithm"

output=$(docker-compose run --rm tester ./query-knn.sh -h)
response=$( echo "$output" | head -n 1)
[[ "$response" == *"OK"* ]] && echo "Successful!" || { echo "Failed test 3:\n$output" 1>&2 ; exit 1; }

echo "Woken Test 4: Run a simple experiment"

output=$(docker-compose run --rm tester ./query-experiment.sh -h)
response=$( echo "$output" | head -n 1)
[[ "$response" == *"OK"* ]] && echo "Successful!" || { echo "Failed test 4: $response\n$output" 1>&2 ; exit 1; }

echo "Everything seems to work just fine! Congrats!"
