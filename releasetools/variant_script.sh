#!/sbin/sh
#
# Copyright (C) 2014-2016 The CyanogenMod Project
# Copyright (C) 2017 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e

# Helper functions
copy()
{
  LD_LIBRARY_PATH=/system/lib /system/bin/toybox cp --preserve=a "$1" "$2"
}

# Detect variant and copy its specific-blobs
modelid=`getprop ro.boot.mid`

case $modelid in
    "0PAJ50000") variant="spr" ;;
    "0PAJ20000") variant="dug" ;;
    "0PAJ21000") variant="dug" ;;
    "0PAJ22000") variant="dug" ;;
    "0PAJ40000") variant="dwg" ;;
    *)           variant="gsm" ;;
esac

# Skip copying blobs in case of Dual SIM variants because the files are already in the proper location
if [ "$variant" == "vzw" ] || [ "$variant" == "spr" ] || [ "$variant" == "gsm" ]; then
  basedir="/system/vendor/blobs/$variant/"
  if [ -d $basedir ]; then
    cd $basedir

    for file in `find . -type f` ; do
      mkdir -p `dirname /system/vendor/$file`
      copy $file /system/vendor/$file
    done

    for file in bin/* ; do
      chmod 755 /system/vendor/$file
    done
  else
    echo "Expected source directory does not exist!"
    exit 1
  fi
fi

exit 0
