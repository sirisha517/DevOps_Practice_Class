echo -e "\e[35mInstalling Nginx\e[0m"
yum install nginx -y

systemctl enable nginx
systemctl start nginx

echo -e "\e[35mRemoving  old content\e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[35mExtracting frontend\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\e[35mCopying nginx configs\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[35mInstalling Nginx\e[0m"
cp configs/nginx.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[35menable & start Nginx\e[0m"
systemctl enable nginx
systemctl restart nginx