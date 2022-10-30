#!/bin/env bash

function SSS(){
        cat << EOS > /etc/resolv.conf
nameserver 192.168.122.1
EOS

        apt-get update
        apt-get install \
    lynx \
    dnsutils -y

        cat << EOS > /etc/resolv.conf
nameserver 192.214.2.2
nameserver 192.214.3.2
EOS
};

function Garden(){
        cat << EOS > /etc/resolv.conf
nameserver 192.168.122.1
EOS

        apt-get update
        apt-get install \
    lynx \
    dnsutils -y

        cat << EOS > /etc/resolv.conf
nameserver 192.214.2.2
nameserver 192.214.3.2
EOS
};

function WISE(){
    apt-get update
    apt-get install \
    bind9 -y
    
        cat << EOS > /etc/bind/named.conf.local
zone "wise.ita10.com" {
    type master;
    allow-transfer { 192.214.3.2; };
    file "/etc/bind/jarkom/wise/wise.ita10.com";
};

zone "eden.wise.ita10.com" {
    type master;
    file "/etc/bind/jarkom/eden/eden.wise.ita10.com";
};

zone "3.214.192.in-addr.arpa" {
    type master;
    file "/etc/bind/jarkom/3.214.192.in-addr.arpa";
};
EOS

    mkdir -p /etc/bind/jarkom
    mkdir -p /etc/bind/jarkom/wise

    cat << EOS > /etc/bind/jarkom/wise/wise.ita10.com
\$TTL   604800
@       IN      SOA     wise.ita10.com. root.wise.ita10.com. (
                        2022102401      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      wise.ita10.com.
@       IN      A       192.214.3.3
www     IN      CNAME   wise.ita10.com.
ns1             IN              A               192.214.3.2
operation       IN              NS              ns1
EOS
    
        mkdir -p /etc/bind/jarkom/eden

        cat << EOS > /etc/bind/jarkom/eden/eden.wise.ita10.com
\$TTL   604800
@       IN      SOA     eden.wise.ita10.com. root.eden.wise.ita10.com. (
                        2022102401      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      eden.wise.ita10.com.
@       IN      A       192.214.3.3
www     IN      CNAME   eden.wise.ita10.com.
EOS

    cat << EOS > /etc/bind/jarkom/3.214.192.in-addr.arpa
\$TTL   604800
@       IN      SOA     wise.ita10.com. root.wise.ita10.com. (
                        2022102401     ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
3.214.192.in-addr.arpa. IN      NS      wise.ita10.com.
3       IN      PTR     wise.ita10.com.
EOS

    cat << EOS > /etc/bind/named.conf.options    
options {
    directory "/var/cache/bind";

    //dnssec-validation auto;
    allow-query{any;};
    auth-nxdomain no;    # conform to RFC1035
    listen-on-v6 { any; };
};
EOS


        service bind9 restart
};

function Berlint(){
    apt-get update
    apt-get install \
    bind9 -y

    cat << EOS > /etc/bind/named.conf.local
zone "wise.ita10.com" {
    type slave;
    masters { 192.214.2.2; };
    file "/var/lib/bind/wise.ita10.com"; 
};

zone "operation.wise.ita10.com" {
    type master;
    file "/etc/bind/delegasi/operation/operation.wise.ita10.com";
};

zone "strix.operation.wise.ita10.com" {
    type master;
    file "/etc/bind/jarkom/operation/strix/strix.operation.wise.ita10.com";
};

EOS

    mkdir -p /etc/bind/delegasi/operation

    cat << EOS > /etc/bind/delegasi/operation/operation.wise.ita10.com
\$TTL   604800
@       IN      SOA     operation.wise.ita10.com. root.operation.wise.ita10.com. (
                        2022102401      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      operation.wise.ita10.com.
@       IN      A       192.214.3.3
www     IN      CNAME   operation.wise.ita10.com.
EOS

        mkdir -p /etc/bind/jarkom/operation/strix

        cat << EOS > /etc/bind/jarkom/operation/strix/strix.operation.wise.ita10.com
\$TTL   604800
@       IN      SOA     strix.operation.wise.ita10.com. root.strix.operation.wise.ita10.com. (
                        2022102401      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      strix.operation.wise.ita10.com.
@       IN      A       192.214.3.3
www     IN      CNAME   strix.operation.wise.ita10.com.
EOS

        cat << EOS > /etc/bind/named.conf.options    
options {
    directory "/var/cache/bind";

    //dnssec-validation auto;
    allow-query{any;};
    auth-nxdomain no;    # conform to RFC1035
    listen-on-v6 { any; };
};
EOS

        service bind9 restart

};

function Eden(){
    apt-get update
    apt-get install \
    apache2 \
    php \
        wget \
        unzip \
    libapache2-mod-php7.0 -y    
    
        cat << EOS > /etc/apache2/sites-available/wise.ita10.com.conf
<VirtualHost *:80>
        # The ServerName directive sets the request scheme, hostname and port that
        # the server uses to identify itself. This is used when creating
        # redirection URLs. In the context of virtual hosts, the ServerName
        # specifies what hostname must appear in the request's Host: header to
        # match this virtual host. For the default virtual host (this file) this
        # value is not decisive as it is used as a last resort host regardless.
        # However, you must set it for any further virtual host explicitly.
        #ServerName www.example.com
 
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/wise.ita10.com
        ServerName wise.ita10.com
        ServerAlias www.wise.ita10.com
 
                <Directory /var/www/wise.ita10.com>
                Options +FollowSymLinks -Multiviews
                AllowOverride All
        </Directory>

        # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
        # error, crit, alert, emerg.
        # It is also possible to configure the loglevel for particular
        # modules, e.g.
        #LogLevel info ssl:warn
 
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
 
        # For most configuration files from conf-available/, which are
        # enabled or disabled at a global level, it is possible to
        # include a line for only one particular virtual host. For example the
        # following line enables the CGI configuration for this host only
        # after it has been globally disabled with "a2disconf".
        #Include conf-available/serve-cgi-bin.conf
</VirtualHost>
 
# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
EOS

        wget -O wise.zip "https://drive.google.com/uc?export=download&id=1S0XhL9ViYN7TyCj2W66BNEXQD2AAAw2e"
        unzip wise.zip -d /var/www
    mkdir -p /var/www/wise.ita10.com
        mv -f /var/www/wise/* /var/www/wise.ita10.com
    rm -rf /var/www/wise

        cat << EOS > /var/www/wise.ita10.com/.htaccess
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(.*)$ index.php?/\$1 [L]

RewriteCond %{HTTP_HOST} ^192\.214\.3\.3$
RewriteRule ^(.*)$ http://www.wise.ita10.com/\$1 [L,R=301]
EOS
    
        cat << EOS > /etc/apache2/sites-available/eden.wise.ita10.com.conf
<VirtualHost *:80>
        # The ServerName directive sets the request scheme, hostname and port that
        # the server uses to identify itself. This is used when creating
        # redirection URLs. In the context of virtual hosts, the ServerName
        # specifies what hostname must appear in the request's Host: header to
        # match this virtual host. For the default virtual host (this file) this
        # value is not decisive as it is used as a last resort host regardless.
        # However, you must set it for any further virtual host explicitly.
        #ServerName www.example.com
 
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/eden.wise.ita10.com
        ServerName eden.wise.ita10.com
        ServerAlias www.eden.wise.ita10.com
 
        <Directory /var/www/eden.wise.ita10.com/error>
            Options -Indexes
        </Directory>

        <Directory /var/www/eden.wise.ita10.com/public>
            Options +Indexes
        </Directory>
 
        ErrorDocument 404 /error/404.html

        Alias "/js" "/var/www/eden.wise.ita10.com/public/js"

                <Directory /var/www/eden.wise.ita10.com>
            Options +FollowSymLinks -Multiviews
            AllowOverride All
        </Directory>

        # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
        # error, crit, alert, emerg.
        # It is also possible to configure the loglevel for particular
        # modules, e.g.
        #LogLevel info ssl:warn
 
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
 
        # For most configuration files from conf-available/, which are
        # enabled or disabled at a global level, it is possible to
        # include a line for only one particular virtual host. For example the
        # following line enables the CGI configuration for this host only
        # after it has been globally disabled with "a2disconf".
        #Include conf-available/serve-cgi-bin.conf
</VirtualHost>
 
# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
EOS

        wget -O eden.wise.zip "https://drive.google.com/uc?export=download&id=1q9g6nM85bW5T9f5yoyXtDqonUKKCHOTV"
        unzip eden.wise.zip -d /var/www
    mkdir -p /var/www/eden.wise.ita10.com
        mv -f /var/www/eden.wise/* /var/www/eden.wise.ita10.com
    rm -rf /var/www/eden.wise
    
        cat << EOS > /etc/apache2/sites-available/strix.operation.wise.ita10.com.conf
<VirtualHost *:15000 *:15500>
        # The ServerName directive sets the request scheme, hostname and port that
        # the server uses to identify itself. This is used when creating
        # redirection URLs. In the context of virtual hosts, the ServerName
        # specifies what hostname must appear in the request's Host: header to
        # match this virtual host. For the default virtual host (this file) this
        # value is not decisive as it is used as a last resort host regardless.
        # However, you must set it for any further virtual host explicitly.
        #ServerName www.example.com
 
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/strix.operation.wise.ita10.com
        ServerName strix.operation.wise.ita10.com
        ServerAlias www.strix.operation.wise.ita10.com

        <Location />
                    Deny from all
                    AuthUserFile /etc/apache2/.htpasswd
                    AuthName "Restricted Area"
                    AuthType Basic
                    Satisfy Any
                    require valid-user
            </Location>

        # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
        # error, crit, alert, emerg.
        # It is also possible to configure the loglevel for particular
        # modules, e.g.
        #LogLevel info ssl:warn
 
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
 
        # For most configuration files from conf-available/, which are
        # enabled or disabled at a global level, it is possible to
        # include a line for only one particular virtual host. For example the
        # following line enables the CGI configuration for this host only
        # after it has been globally disabled with "a2disconf".
        #Include conf-available/serve-cgi-bin.conf
</VirtualHost>
 
# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
EOS
    
    cat << EOS > /etc/apache2/ports.conf
# If you just change the port or add more ports here, you will likely also
# have to change the VirtualHost statement in
# /etc/apache2/sites-enabled/000-default.conf

Listen 80
Listen 15000
Listen 15500

<IfModule ssl_module>
        Listen 443
</IfModule>

<IfModule mod_gnutls.c>
        Listen 443
</IfModule>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
EOS

    htpasswd -bc /etc/apache2/.htpasswd Twilight opStrix

        wget -O strix.operation.wise.zip "https://drive.google.com/uc?export=download&id=1bgd3B6VtDtVv2ouqyM8wLyZGzK5C9maT"
        unzip strix.operation.wise.zip -d /var/www
    mkdir -p /var/www/strix.operation.wise.ita10.com 
        mv -f /var/www/strix.operation.wise/* /var/www/strix.operation.wise.ita10.com
    rm -rf /var/www/strix.operation.wise

    cat << EOS > /var/www/eden.wise.ita10.com/.htaccess
RewriteEngine On
RewriteCond %{REQUEST_URI} .*eden.*\.(jpg|png)
RewriteCond %{REQUEST_URI} !/public/images/eden.png
RewriteRule ^(.*)/ /public/images/eden.png [L,R=301]
EOS

    service apache2 start
    a2ensite eden.wise.ita10.com.conf 
    a2ensite strix.operation.wise.ita10.com.conf
    a2ensite wise.ita10.com.conf
    a2enmod rewrite
    service apache2 restart
};

if [[ $(hostname) = "SSS" ]]; then
    SSS
elif [[ $(hostname) = "Garden" ]]; then
    Garden
elif [[ $(hostname) = "WISE" ]]; then
    WISE
elif [[ $(hostname) = "Berlint" ]]; then
    Berlint
elif [[ $(hostname) = "Eden" ]]; then
    Eden
fi
