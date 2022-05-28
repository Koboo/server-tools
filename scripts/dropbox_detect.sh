#!/bin/bash
if dropbox status | grep "Dropbox isn't running"; then
  dropbox start
  echo "Dropbox started."
else
  echo "Dropbox running."
fi
