#!/bin/bash

sudo yum install -y bind bind-utils

sudo cp /etc/named.conf /etc/name.conf.bak

# Configure BIND
cat <<EOL | sudo tee /etc/named.conf
options {
    listen-on port 53 { any; };
    directory   "/var/named";
    dump-file   "/var/named/data/cache_dump.db";
    statistics-file "/var/named/data/named_stats.txt";
    memstatistics-file "/var/named/data/named_mem_stats.txt";
    allow-query     { any; };
    recursion yes;
};

zone "." IN {
    type hint;
    file "named.ca";
};

include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";
EOL

# Create a sample forward zone file
cat <<EOL | sudo tee /var/named/example.com.zone
\$TTL 1D
@   IN SOA  ns1.example.com. admin.example.com. (
                  2022012001   ; serial
                  3H   ; refresh
                  15M  ; retry
                  1W   ; expiry
                  1D ) ; minimum

@   IN NS ns1.example.com.

ns1 IN A 192.168.1.10
www IN A 192.168.1.20
EOL



sudo chown named:named /var/named/example.com.zone

sudo systemctl restart named


sudo firewall-cmd --permament --add-service=dns

sudo firewall-cmd --reload

echo "DNS server setup completed. You can now configure your clients to use this DNS server."

