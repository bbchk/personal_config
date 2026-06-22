#!/usr/bin/env bash

echo "test" | gpg --batch -e -r E78A0D774F0BDAC50F897DC5FF99608021A353C0 | gpg --batch -d >/dev/null
