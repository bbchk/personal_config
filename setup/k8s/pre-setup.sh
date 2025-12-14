#!/bin/bash

cp /cdrom/post-setup.service /etc/systemd/system/

cp /cdrom/post-setup.sh /usr/local/bin/
chmod +x /usr/local/bin/post-setup.sh

systemctl daemon-reload

systemctl enable post-setup.service

exit 0
