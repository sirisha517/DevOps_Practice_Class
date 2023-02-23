source common.sh

  print_head "setup Mongodb repository"
cp configs/mongodb.repo /etc/yum.repos.d/mongo.repo

  print_head "Installing Mongodb"
yum install mongodb-org -y

  print_head "enable Mongodb"
systemctl enable mongod

  print_head "start Momgodb"
systemctl start mongod
