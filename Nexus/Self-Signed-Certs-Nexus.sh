Create a Self-Signed Certificate for Nexus Server:
======================================================

sudo openssl req -newkey rsa:2048 -nodes -keyout /etc/pki/tls/private/nexus.key -x509 -days 365 -out /etc/pki/tls/certs/nexus.crt

sudo yum install httpd

sudo yum install mod_ssl


sudo nano /etc/httpd/conf.d/nexus.conf
    
        <VirtualHost *:443>
            ServerName nexus.example.com
            ProxyPreserveHost On
            ProxyPass / http://localhost:8081/
            ProxyPassReverse / http://localhost:8081/
            SSLEngine on
            SSLCertificateFile /etc/pki/tls/certs/nexus.crt
            SSLCertificateKeyFile /etc/pki/tls/private/nexus.key
        </VirtualHost>

sudo nano /opt/nexus/bin/nexus.properties

application-port=8081
application-port-ssl=443

sudo systemctl restart httpd
sudo systemctl restart nexus
