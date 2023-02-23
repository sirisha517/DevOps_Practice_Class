code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head() {
 echo -e "\e[35m$1\e[0m" # if we change colour in one place it will effect in all places
  }

status_check(){
  if [ $? -eq 0 ]; then
    echo SUCESS
    else
      echo FAILURE
      echo "Read the log file ${log_file} for more information about error"
      exit 1
  fi
}

systemd_setup(){
    print_head "copy systemd service file"
      cp ${code_dir}/configs/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
      status_check $?

      print_head "Reload systemd"
      systemctl daemon-reload &>>${log_file}
      status_check $?

      print_head "enable ${component} service"
      systemctl enable ${component} &>>${log_file}
      status_check $?

      print_head "start ${component} service"
      systemctl restart ${component} &>>${log_file}
      status_check $?
}
 schema_setup(){
   if [ "${schema_type}" == "mongo" ] ; then
      print_head "copy mongodb repo file"
      cp  ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
      status_check $?

      print_head "Install mongo client"
      yum install mongodb-org-shell -y &>>${log_file}
      status_check $?

      print_head "load schema"
      mongo --host mongodb.devops517test.online </app/schema/${component}.js &>>${log_file}
      status_check $?

  elif [ "${schema_type}" == "mysql" ]; then
    print_head "Install Mysql Client"
    yum install mysql -y
    status_check $?

    print_head "Load Schema"
    mysql -h mysql.devops517test.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql
    systemctl restart shipping
  fi
  }

app_prereq_setup(){
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
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
  status_check $?
  cd /app

  print_head "extracting app content"
  unzip /tmp/${component}.zip &>>${log_file}
  status_check $?
}

nodejs(){
  print_head "configure nodejs repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
  status_check $?

 app_prereq_setup
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
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
  status_check $?
  cd /app

  print_head "extracting app content"
  unzip /tmp/${component}.zip &>>${log_file}
  status_check $?

  print_head "Installing nodejs dependencies"
  npm install &>>${log_file}
  status_check $?

  systemd_setup

}

java(){

 print_head "install maven "
 yum install maven -y &>>${log_file}
 status_check $?

 app_prereq_setup

 print_head "download dependencies"
 mvn clean package &>>${log_file}
 mv target/${component}-1.0.jar ${component}.jar &>>${log_file}
 status_check $?

# schema setup function
 schema_setup

# systemd function
 systemd_setup


}