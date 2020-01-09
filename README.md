# README
Simple scripts to backup OpenWRT to USB device.

## Example of use

Script assumes that USB device is `/dev/sda1`, and mount point is `/mnt/usb`. Can be easily changed by modyfying variables in the begining of files.
Just run command and backup will be created. Older backups will be removed - time of oldest you can modify in variable.

Example crontab:
```
4 2 * * * /bin/sh /root/backup.sh
5 2 * * 1 /bin/sh /root/backup_mtd.sh
```
