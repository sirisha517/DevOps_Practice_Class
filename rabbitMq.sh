source common.sh

roboshop_app_password=$1
if [ -z "${1}" ] ; then # check variabe is empty
  echo -e "\e[35mMissing roboshop app user Password\e[0"
  exit 1
fi

print_head "setup erlang repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>${log_file}
status_check $?

print_head "setup rabbitmq repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${log_file}
status_check $?

print_head "install rabbitmq and erlang"
yum install rabbitmq-server erlang -y &>>${log_file}
status_check $?

print_head "enable  rabbitmq "
systemctl enable rabbitmq-server &>>${log_file}
status_check $?

print_head "start rabbitmq "
systemctl start rabbitmq-server &>>${log_file}
status_check $?

print_head "add application user"
rabbitmqctl add_user roboshop ${roboshop_app_password} &>>${log_file}
status_check $?

print_head "configure permission for app user"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log_file}
status_check $?
