#!/bin/bash

# Backup and update sysctl.conf
sudo cp /etc/sysctl.conf /root/sysctl.conf_backup
sudo cat <<EOT | tee /etc/sysctl.conf
vm.max_map_count=262144
fs.file-max=65536
ulimit -n 65536
ulimit -u 4096
EOT

# Backup and update security limits
sudo cp /etc/security/limits.conf /root/sec_limit.conf_backup
sudo cat <<EOT | tee /etc/security/limits.conf
sonarqube   -   nofile   65536
sonarqube   -   nproc    4096
EOT

# Update and install necessary packages
sudo apt-get update -y
sudo apt-get install -y openjdk-17-jdk wget unzip nginx net-tools

# Configure Java alternatives and check version
java -version

# Install PostgreSQL
wget -qO - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
sudo apt-get update
sudo apt-get install -y postgresql postgresql-contrib
sudo systemctl enable postgresql
sudo systemctl start postgresql

# Configure PostgreSQL
echo "postgres:admin123" | sudo chpasswd
sudo -i -u postgres psql -c "CREATE USER sonar WITH ENCRYPTED PASSWORD 'admin123';"
sudo -i -u postgres psql -c "CREATE DATABASE sonarqube OWNER sonar;"
sudo -i -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonar;"
sudo systemctl restart postgresql

# Download and configure the latest stable SonarQube version
SONARQUBE_VERSION=$(curl -s https://api.github.com/repos/SonarSource/sonarqube/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')
SONARQUBE_VERSION=${SONARQUBE_VERSION:-"10.1.0.73491"}  # Fallback version if API fails
sudo mkdir -p /sonarqube
cd /sonarqube
sudo curl -L -O "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${SONARQUBE_VERSION}.zip"
sudo unzip -o "sonarqube-${SONARQUBE_VERSION}.zip" -d /opt/
sudo mv "/opt/sonarqube-${SONARQUBE_VERSION}" /opt/sonarqube

# Set up SonarQube user and permissions
sudo groupadd sonar
sudo useradd -c "SonarQube - User" -d /opt/sonarqube -g sonar sonar
sudo chown -R sonar:sonar /opt/sonarqube

# Update SonarQube configuration
cp /opt/sonarqube/conf/sonar.properties /root/sonar.properties_backup
cat <<EOT | sudo tee /opt/sonarqube/conf/sonar.properties
sonar.jdbc.username=sonar
sonar.jdbc.password=admin123
sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube
sonar.web.host=0.0.0.0
sonar.web.port=9000
sonar.web.javaAdditionalOpts=-server
sonar.search.javaOpts=-Xmx512m -Xms512m -XX:+HeapDumpOnOutOfMemoryError
sonar.log.level=INFO
sonar.path.logs=logs
EOT

# Create systemd service for SonarQube
cat <<EOT | sudo tee /etc/systemd/system/sonarqube.service
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
User=sonar
Group=sonar
Restart=always
LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
EOT

# Reload systemd and enable SonarQube service
sudo systemctl daemon-reload
sudo systemctl enable sonarqube
sudo systemctl start sonarqube

# Configure NGINX for SonarQube
sudo rm -rf /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default
cat <<EOT | sudo tee /etc/nginx/sites-available/sonarqube
server {
    client_max_body_size 50M;
    
    listen 80;
    server_name _;

    access_log /var/log/nginx/sonar.access.log;
    error_log /var/log/nginx/sonar.error.log;

    proxy_buffers 16 64k;
    proxy_buffer_size 128k;

    location / {
        proxy_pass http://127.0.0.1:9000;
        proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
        proxy_redirect off;

        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto http;
    }
}
EOT

# Enable NGINX site and allow firewall ports
sudo ln -s /etc/nginx/sites-available/sonarqube /etc/nginx/sites-enabled/sonarqube
sudo systemctl enable nginx
sudo systemctl restart nginx
sudo ufw allow 80,9000,9001/tcp