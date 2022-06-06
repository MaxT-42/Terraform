#!/bin/bash
yum -y update
yum -y install httpd



myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat <<EOF > /var/www/html/index.html
<html>
<h2>Use terraform<font color="red">tamplate</font></h2><br>

Owner ${f_name} ${l_name} <br>
%{ for i in object ~}
${f_name} is in ${i} <br>
%{ endfor ~}
</html>
EOF

sudo service httpd start
chkconfig httpd on
