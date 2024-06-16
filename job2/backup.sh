#!/bin/bash

backup_dir="/archive"
home_dir="/home"
ssh_config_dir="/etc/ssh"
ftp_config="/etc/vsftpd.conf"
rdp_config_dir="/etc/xrdp"
log_dir="/var/log"

tar -cpf $backup_dir/home_backup.tar.gz $home_dir
tar -cpf $backup_dir/ssh_config_backup.tar.gz $ssh_config_dir
tar -cpf $backup_dir/ftp_config_backup.tar.gz $ftp_config
tar -cpf $backup_dir/rpd_config_backup.tar.gz $rdp_config_dir
tar -cpf $backup_dir/log_backup.tar.gz $log_dir

echo "Backup had been done successfully"
