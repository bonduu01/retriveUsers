#!/usr/bin/env bash
# Copy created job into cron.daily
chmod +x /root/gitlab.sh
yes | cp -rf /root/gitlab.sh /etc/cron.hourly

