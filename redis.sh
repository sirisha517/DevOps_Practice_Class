source common.sh

print_head "Installing redis repo files"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${log_file}
status_check $?

print_head "enable dnf module"
dnf module enable redis:remi-6.2 -y &>>${log_file}
status_check $?

 print_head "Installing Redis"
yum install redis -y  &>>${log_file}
status_check $?

print_head "update Redis listen redis"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>${log_file}
status_check $?

print_head "enable Redis"
systemctl enable redis
status_check $?

print_head "start Redis"
systemctl restart redis
status_check $?
