source common.sh

mysql_root_password=$1
if [ -z "${1}" ] ; then # check variabe is empty
  echo -e "\e[35mMissing mysql Root Password\e[0"
  exit 1
fi
print_head "disable mysql 8 version"
dnf module disable mysql -y &>>${log_file}
status_check $?

print_head "Copy mysql Repo file"
cp ${code_dir}/configs/mysql.repo /etc/yum.repos.d/mysql.repo &>>${log_file}
status_check

print_head "install mysql server"
yum install mysql-community-server -y &>>${log_file}
status_check $?

print_head "enable  mysql server"
systemctl enable mysqld &>>${log_file}
status_check $?

print_head "start mysql server"
systemctl start mysqld &>>${log_file}
status_check $?

print_head "set root password"
mysql_secure_installation --set-root-pass ${mysql_root_password} &>>${log_file}
status_check $?

#print_head "disable mysql"
#mysql -uroot -pRoboShop@1 &>>${log_file}
#status_check $?
