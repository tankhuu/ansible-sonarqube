#!/bin/bash -xe

src_dir="/opt/sonarqube"

# Install prerequisites
echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" | sudo tee  /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
apt update
apt install -y awscli tree apt-transport-https openjdk-11-jre openjdk-11-jdk postgresql-12 nginx unzip tree

# Setup Database
sudo adduser --system --no-create-home --group --disabled-login sonarqube
########################################################################
  create database sonarqube;
  create user sonar;
  alter user sonar with password 'xB70X791FYe9PxbG';
  GRANT ALL PRIVILEGES ON DATABASE sonarqube to sonar;
  \c sonarqube
  GRANT USAGE ON SCHEMA public TO sonar;
  GRANT ALL PRIVILEGES ON SCHEMA public TO sonar;
  GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO sonar;
  GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO sonar;
########################################################################
echo "host    all    all    0.0.0.0/0    md5" >> /etc/postgresql/12/main/pg_hba.conf
echo "listen_addresses = '*'" >> /etc/postgresql/12/main/postgresql.conf
systemctl restart postgresql
systemctl enable postgresql

# Install Sonarqube 8.x
sudo mkdir -p $src_dir
sudo chown ubuntu: $src_dir
cd /opt

#wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.3.1.34397.zip
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.5.1.38104.zip
unzip sonarqube-*.zip
mv sonarqube-*/* sonarqube/

chown -R sonarqube: /opt/sonarqube

# Cleanup
rm -rf sonarqube-*

cd $src_dir/conf/
vi sonar.properties
########################################################################

########################################################################

cd $src_dir/elasticsearch
vi config/jvm.options
########################################################################

########################################################################
vi /etc/security/limits.conf
########################################################################

########################################################################
vi /etc/sysctl.conf
########################################################################

########################################################################
sysctl -w vm.max_map_count=262144
sysctl -w vm.max_map_count=262144
sysctl -w fs.file-max=65536
ulimit -n 65536
ulimit -u 4096


vi /etc/systemd/system/sonarqube.service
########################################################################

########################################################################
ll /opt/sonarqube/bin/linux-x86-64/sonar.sh
########################################################################

########################################################################

systemctl daemon-reload
systemctl start sonarqube
systemctl status sonarqube
systemctl enable sonarqube
curl http://127.0.0.1:9000

apt install nginx
vi /etc/nginx/sites-enabled/sonarqube
########################################################################

########################################################################
rm /etc/nginx/sites-enabled/default
nginx -t
systemctl restart nginx
