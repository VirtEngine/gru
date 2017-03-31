tomcatdir=/opt/tomcat/conf/tomcat-users.xml
service=/etc/systemd/system/tomcat.service
cd  /opt

wget https://s3-ap-southeast-1.amazonaws.com/megampub/gru/tomcat/apache-tomcat-8.0.42.tar.gz

tar xf apache-tomcat-8.0.42.tar.gz

mv apache-tomcat-8.0.42 tomcat

rm -rf $tomcatdir
cat > $tomcatdir << EOF
<?xml version='1.0' encoding='utf-8'?>
<tomcat-users xmlns="http://tomcat.apache.org/xml"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"
              version="1.0">
  <role rolename="manager-script"/>
  <role rolename="manager-gui"/>
  <role rolename="manager-jmx"/>
  <role rolename="manager-status"/>
  <user username="tomcat" password="tomcat" roles="manager-gui,manager-status"/>
</tomcat-users>
EOF

cat > $service << EOF
[Unit]
    Description=Apache Tomcat
    After=syslog.target network.target
[Service]
    Type=forking
    Environment=JAVA_HOME=/var/lib/megam/build/.jdk
    Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
    Environment=CATALINA_HOME=/opt/tomcat
    Environment=CATALINA_BASE=/opt/tomcat
    Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
    Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'
    ExecStart=/opt/tomcat/bin/startup.sh
 [Install]
    WantedBy=multi-user.target

EOF

chmod 755 $service

cd /var/lib/megam/build
arr=$(find . -path "**target/*.war")
   for i in "${arr[@]}"
   do
      cp $i /opt/tomcat/webapps
   done

firewall-cmd --permanent --add-port=8080/tcp
firewall-cmd --reload

systemctl  daemon-reload
