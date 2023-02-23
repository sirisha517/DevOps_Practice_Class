code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head() {
  echo -e "\e[35m$1\e[0m"
}
print_head "Installing Nginx"
yum install nginx -y &>>${log_file}

systemctl enable nginx
systemctl start nginx

print_head "Removing  old content"
rm -rf /usr/share/nginx/html/* &>>${log_file}

print_head "Downloading frontend"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}

print_head "Extracting download frontend"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>${log_file}


print_head "Copying Nginx configs for RoboShop"
cp ${code_dir}/configs/nginx.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}

print_head "enable Nginx"
systemctl enable nginx &>>${log_file}

print_head "start Nginx"
systemctl restart nginx &>>${log_file}