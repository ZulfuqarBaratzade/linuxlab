#!/bin/bash


sudo yum install -y vsftpd
sudo systemctl enable vsftpd
sudo systemctl start vsftpd

sudo cp /etc/vsftpd/vsftpd.conf /etc/vsftpd.conf.bak

cat <<EOL | sudo tee /etc/vsftpd/vsftpd.conf
anonymous_enable=NO
local_enable=YES
write_enable=YES
chroot_local_user=YES
EOL


systemctl restart vsftpd

sudo firewall-cmd --permanent --add-service=ftp
sudo firewall-cmd --reload

echo "FTP server setup completed. Users can now connect to the server."


