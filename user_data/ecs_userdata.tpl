#!/bin/bash

curl -L https://toolbelt.treasuredata.com/sh/install-redhat-td-agent2.sh | sh
/etc/init.d/td-agent start
chkconfig td-agent on

echo ECS_CLUSTER=${cluster_name} >> /etc/ecs/ecs.config

# ssm agent
mkdir /tmp/ssm
cd /tmp/ssm
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
start amazon-ssm-agent

echo "license_key: ${newrelic_license}" | tee -a /etc/newrelic-infra.yml
curl -o /etc/yum.repos.d/newrelic-infra.repo https://download.newrelic.com/infrastructure_agent/linux/yum/el/6/x86_64/newrelic-infra.repo
yum -q makecache -y --disablerepo='*' --enablerepo='newrelic-infra'
yum install newrelic-infra -y