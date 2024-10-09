#!/bin/sh

set -eu

proftpd_dir=/var/lib/ftp

# Generate unique ssh keys for this container, if needed
if [ ! -f "$proftpd_dir"/ssh_host_ed25519_key ]; then
  ssh-keygen -t ed25519 -f "$proftpd_dir"/ssh_host_ed25519_key -N ''
fi
if [ ! -f "$proftpd_dir"/ssh_host_rsa_key ]; then
  ssh-keygen -t rsa -b 4096 -f "$proftpd_dir"/ssh_host_rsa_key -N ''
fi

# Generate passwd file from users.txt
# Format: username\npassword\nusername\npassword\n...
if [ -f "$proftpd_dir"/users.txt ]; then
  while read -r user; do
    read -r pass
    echo "$pass" \
      | ftpasswd \
          --passwd \
          --file="$proftpd_dir"/proftpd.passwd \
          --name="$user" \
          --uid=2000 \
          --gid=2000 \
          --home=/srv/Content \
          --shell=/bin/false \
          --stdin
  done < "$proftpd_dir"/users.txt
fi

mkdir -p /run/proftpd

exec proftpd -c /etc/proftpd/proftpd.conf -n
