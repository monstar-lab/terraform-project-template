#!/bin/bash

yum update -y
yum install -y yum-cron-security yum-cron git tree dstat sysstat vim nginx
chkconfig yum-cron on

# service nginx
service nginx start
chkconfig nginx on

## Amazon Time Sync Service
yum erase ntp*
yum install -y chrony
service chronyd start
chkconfig chronyd on

# install cloudwatch logs
yum install -y perl-DateTime perl-Sys-Syslog perl-LWP-Protocol-https awslogs

# ROOT Volume Resize
resize2fs /dev/xvda1

## for JST setting
ln -sf /usr/share/zoneinfo/Japan /etc/localtime
sed -i "s/\"UTC\"/\"Japan\"/g" /etc/sysconfig/clock
sed -i "s/en_US\.UTF-8/ja_JP\.UTF-8/g" /etc/sysconfig/i18n

# cloudwatch custom metrics
wget http://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.1.zip -P /opt/aws
cd /opt/aws/
unzip CloudWatchMonitoringScripts-1.2.1.zip
rm -f CloudWatchMonitoringScripts-1.2.1.zip
(crontab -l; echo "*/5 * * * * /opt/aws/aws-scripts-mon/mon-put-instance-data.pl --mem-util --mem-used --mem-avail --disk-space-util --disk-path=/ --from-cron") | crontab -

# cloudwatch logs
sed -i 's/us-east-1/ap-northeast-1/g' /etc/awslogs/awscli.conf

# service start
service awslogs start
chkconfig awslogs on

# ssm agent
mkdir /tmp/ssm
cd /tmp/ssm
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
start amazon-ssm-agent

echo "license_key: ${newrelic_license}" | tee -a /etc/newrelic-infra.yml
curl -o /etc/yum.repos.d/newrelic-infra.repo https://download.newrelic.com/infrastructure_agent/linux/yum/el/6/x86_64/newrelic-infra.repo
yum -q makecache -y --disablerepo='*' --enablerepo='newrelic-infra'
yum install newrelic-infra -y