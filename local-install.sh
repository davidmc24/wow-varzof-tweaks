#!/usr/bin/env bash
set -e

addonName="VarzofTweaks"
addonsDir="/Applications/World of Warcraft/_retail_/Interface/AddOns"
addonDir="${addonsDir}/${addonName}"
if [ ! -d "${addonDir}" ]; then
  mkdir "${addonDir}"
fi

cp -v -r *.toc *.lua assets "${addonDir}/"
