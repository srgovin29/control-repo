#!/bin/bash
apphome=$PT_apphome
appport=$PT_appport
if [ ! -d "$apphome" ]; then
  echo "$apphome does not exist."
  mkdir -p /opt/tomcat 
  chown tomcat:tomcat -R /opt/tomcat
fi
if [ !  -f /opt/tomcat/apache-tomcat-8.5.98.tar.gz ]; then 
      echo "/opt/tomcat/apache-tomcat-8.5.98.tar.gz file not downloaded" 
      /usr/bin/wget -o /opt/tomcat/apache-tomcat-8.5.98.tar.gz https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.98/bin/apache-tomcat-8.5.98.tar.gz
      /usr/bin/tar -xzf /opt/tomcat/apache-tomcat-8.5.98.tar.gz -C /opt/tomcat/
      /usr/bin/ln -s /opt/tomcat/apache-tomcat-8.5.98 /opt/tomcat/latest
      chown -R tomcat: /opt/tomcat
      chmod +x /opt/tomcat/latest/bin/*.sh
else
      echo "/opt/tomcat/apache-tomcat-8.5.98.tar.gz file already there, extracing bin "
      /usr/bin/tar -xzf /opt/tomcat/apache-tomcat-8.5.98.tar.gz -C /opt/tomcat/
      /usr/bin/ln -s /opt/tomcat/apache-tomcat-8.5.98 /opt/tomcat/latest
      chown -R tomcat: /opt/tomcat
      chmod +x /opt/tomcat/latest/bin/*.sh
fi
echo "Adding Firewall to port $appport"
# firewall-cmd --zone=public --permanent --add-port="$appport/tcp"
# firewall-cmd --reload
