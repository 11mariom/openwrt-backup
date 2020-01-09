#!/bin/sh
set -e

DEV="/dev/sda1"
MOUNT="/mnt/usb"
DAYS_TO_KEEP=366

DST="/mnt/usb/backup/mtd"

function _mount() {
  if grep -qs ${DEV} /proc/mounts; then
    echo "Already mounted"
  else
    mount ${DEV} ${MOUNT} || exit 1
  fi
}

function _mkdir() {
  echo "Creating backup directory"
  mkdir -p ${DST} || exit 2
}

function _backup() {
  cat /proc/mtd | grep -v reserved | tail -n+2 | while read; do
    local mtd_dev=$(echo ${REPLY} | cut -f1 -d:)
    local mtd_name=$(echo ${REPLY} | cut -f2 -d\")
    echo "Backing up $mtd_name ($mtd_dev)..."

    dd if="/dev/${mtd_dev}" of="${DST}/$(date +%F)-${mtd_dev}-${mtd_name}.backup" || exit 3
  done
}

function _removeold() {
  echo "Removing backups older than ${DAYS_TO_KEEP} days"
  find ${DST} -type f -mtime ${DAYS_TO_KEEP} -exec rm {} \;
}

function main() {
  _mount
  _mkdir
  _backup
  _removeold
}

main
