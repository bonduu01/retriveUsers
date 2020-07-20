######################Please Read Me ###########################
The gitlab.sh file must be run as a root user on file path /root

## Crontab command to run hourly
crontab -e

0 * * * * /root/gitlab.sh
