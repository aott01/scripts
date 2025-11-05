originally from dev2.sjelab.net

called as https://dev2.sjelab.net/inv/dsulog.php with -X POST

1. TODO: does not respond to GET

2. needs some apache2 config bits to let php be executable, port 80 and port 443 configs
httpd.conf:LoadModule php_module         libexec/apache24/libphp.so

httpd.conf:#mod_php80
httpd.conf:<FilesMatch "\.php$">
httpd.conf:    SetHandler application/x-httpd-php
httpd.conf:<FilesMatch "\.phps$">
httpd.conf:    SetHandler application/x-httpd-php-source

extra/httpd-ssl.conf:<FilesMatch "\.(cgi|shtml|phtml|php)$">
extra/httpd-ssl.conf:#mod_php80
extra/httpd-ssl.conf:<FilesMatch "\.php$">
extra/httpd-ssl.conf:    SetHandler application/x-httpd-php
extra/httpd-ssl.conf:<FilesMatch "\.phps$">
extra/httpd-ssl.conf:    SetHandler application/x-httpd-php-source
