#!/bin/sh
set -e

DEV="/dev/sda1"
MOUNT="/mnt/usb"
DAYS_TO_KEEP=180

DST="/mnt/usb/backup/config"

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
  local filename="backup-${HOSTNAME}-$(date +%F).tar.gz"
  local path="${DST}/${filename}"
  echo "Backing up..."
  sysupgrade -b ${path} || exit 3
  echo "Backup done: ${path}"
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
