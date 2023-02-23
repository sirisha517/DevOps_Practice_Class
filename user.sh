source common.sh

print_head "configure nodejs repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
status_check $?

print_head "Install nodejs repo"
yum install nodejs -y &>>${log_file}
status_check $?

print_head "roboshop user added"
id roboshop &>>${log_file}
if [ $? -ne 0 ]; then # user doesnot exists then create
  useradd roboshop &>>${log_file}
  fi
status_check $?

print_head "create application directory"
if [ ! -d /app ] ; then # if not exists then create directory
  mkdir /app &>>${log_file}
  fi
status_check $?


print_head "remove old content"
rm -rf /app/* &>>${log_file}
status_check $?

print_head "download app content"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>${log_file}
cd /app
status_check $?

print_head "extracting app content"
unzip /tmp/user.zip &>>${log_file}
status_check $?


cd /app
print_head "Installing nodejs dependencies"
npm install &>>${log_file}
status_check $?

print_head "Load the service."
systemctl daemon-reload &>>${log_file}
status_check $?

print_head "enable redis user"
systemctl enable user &>>${log_file}
status_check $?

print_head "start redis"
systemctl start user &>>${log_file}
status_check $?

print_head "copy mongodb repo file"
cp  ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
status_check $?

print_head "install redis"
yum install redis-org-shell -y &>>${log_file}
status_check $?

print_head "Load Schema"
mongo --host mongodb.devops517test.online </app/schema/user.js &>>${log_file}
status_check $?
