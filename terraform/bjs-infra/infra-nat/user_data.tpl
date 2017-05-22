#!/bin/bash -v\n
yum update -y aws*
. /etc/profile.d/aws-apitools-common.sh

# Configure iptables
/sbin/iptables -t nat -A POSTROUTING -o eth0 -s 0.0.0.0/0 -j MASQUERADE
/sbin/iptables-save > /etc/sysconfig/iptables

# Configure ip forwarding and redirects
echo 1 >  /proc/sys/net/ipv4/ip_forward && echo 0 >  /proc/sys/net/ipv4/conf/eth0/send_redirects
mkdir -p /etc/sysctl.d/
cat <<EOF > /etc/sysctl.d/nat.conf
net.ipv4.ip_forward = 1
net.ipv4.conf.eth0.send_redirects = 0
EOF

# Download nat_monitor.sh and configure
cd /root
wget https://s3-us-west-2.amazonaws.com/hxyshare/nat_monitor.sh


NAT_ID=${nat2_id}
NAT_RT_ID=${nat2_rt_id}
My_RT_ID=${nat1_rt_id}

echo `date` "-- NAT_ID=$NAT_ID" >> /tmp/test.log

# Update NAT_ID, NAT_RT_ID, and My_RT_ID
sed "s/NAT_ID=/NAT_ID=$NAT_ID/g" /root/nat_monitor.sh > /root/nat_monitor.tmp
sed "s/NAT_RT_ID=/NAT_RT_ID=$NAT_RT_ID/g" /root/nat_monitor.tmp > /root/nat_monitor.sh
sed "s/My_RT_ID=/My_RT_ID=$My_RT_ID/g" /root/nat_monitor.sh > /root/nat_monitor.tmp
sed "s/EC2_URL=/EC2_URL=https:\\/\\/ec2.cn-north-1.amazonaws.com.cn/g" /root/nat_monitor.tmp > /root/nat_monitor.sh
sed "s/Num_Pings=3/Num_Pings=${num_pings}/g" /root/nat_monitor.sh > /root/nat_monitor.tmp
sed "s/Ping_Timeout=1/Ping_Timeout=${ping_timeout}/g" /root/nat_monitor.tmp > /root/nat_monitor.sh
sed "s/Wait_Between_Pings=2/Wait_Between_Pings=${wait_between_pings}/g" /root/nat_monitor.sh > /root/nat_monitor.tmp
sed "s/Wait_for_Instance_Stop=60/Wait_for_Instance_Stop=${wait_for_instance_stop}/g" /root/nat_monitor.tmp > /root/nat_monitor.sh
sed "s/Wait_for_Instance_Start=300/Wait_for_Instance_Start=${wait_for_instance}/g" /root/nat_monitor.sh > /root/nat_monitor.tmp

mv /root/nat_monitor.tmp /root/nat_monitor.sh
chmod a+x /root/nat_monitor.sh
echo '@reboot /root/nat_monitor.sh > /tmp/nat_monitor.log' | crontab
/root/nat_monitor.sh > /tmp/nat_monitor.log &




#!/bin/bash -ex
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo Begin: user-data

echo Begin: update and install packages
yum update -y
yum install -y aws-cfn-bootstrap aws-cli jq
echo End: update and install packages

echo Begin: create hello world index.html
mkdir -p /var/www/html
echo '<html><body><h1>Hello world from ${cluster_name}!</h1></body></html>' >> /var/www/html/index.html
echo End: create hello world index.html

echo Begin: start ECS
cluster="${cluster_name}"
echo ECS_CLUSTER=$cluster >> /etc/ecs/ecs.config
start ecs
until $(curl --output /dev/null --silent --head --fail http://localhost:51678/v1/metadata); do
  printf '.'
  sleep 1
done
echo End: start ECS

echo Begin: set up tasks
instance_arn=$(curl -s http://localhost:51678/v1/metadata | jq -r '. | .ContainerInstanceArn' | awk -F/ '{print $NF}' )
az=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
region=$${az:0:$${#az} - 1}

echo "
cluster=$cluster
az=$az
region=$region
" >> /etc/rc.local
echo End: set up datadog and hello world ECS tasks

echo End: user-data
