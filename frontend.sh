code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

echo -e "\e[35mInstalling Nginx\e[0m"
yum install nginx -y &>>${log_file}

systemctl enable nginx
systemctl start nginx

echo -e "\e[35mRemoving  old content\e[0m"
rm -rf /usr/share/nginx/html/* &>>${log_file}

echo -e "\e[35mDownloading frontend\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}

echo -e "\e[35mExtracting download frontend\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>${log_file}


echo -e "\e[35mCopying Nginx configs for RoboShop\e[0m"
cp ${code_dir}/configs/nginx.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}

echo -e "\e[35menable Nginx\e[0m"
systemctl enable nginx &>>${log_file}

echo -e "\e[35mstart Nginx\e[0m"
systemctl restart nginx &>>${log_file}