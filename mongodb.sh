source common.sh

  print_head "setup Mongodb repository"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}

  print_head "Installing Mongodb"
yum install mongodb-org -y &>>${log_file}

print_head "update mongodb listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${log_file}

  print_head "enable Mongodb"
systemctl enable mongod &>>${log_file}

  print_head "start Momgodb"
systemctl start mongod &>>${log_file}
