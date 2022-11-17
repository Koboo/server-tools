#!/bin/bash
if [ "$(lscpu | grep avx)" = "" ]
then
  echo "Missing AVX Flags..."
else
  echo "AVX Flags found.."
fi
