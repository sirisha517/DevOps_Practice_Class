source common.sh

print_head "Copy MongoDB Repo file"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
status_check

print_head "Install MongoDB"
yum install mongodb-org -y  &>>${log_file}
status_check

print_head "Update MongoDB Listen Address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongodb.conf &>>${log_file}
status_check


print_head "Enable MongoDB"
systemctl enable mongod &>>${log_file}
status_check

print_head "Start MongoDB"
systemctl restart mongod &>>${log_file}
status_check