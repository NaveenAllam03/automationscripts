#!/bin/bash

user=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

# set -xe --> used to debug the code

LOGFILE="/home/centos/$0.log" #logfile to store the info to debug

# function to validate using exit status

CHECK() {
  
   if [ $1 -ne 0 ]; then
      echo -e " $2 $R failed..$N "
   else
      echo -e " $2 $G sucessfull..$N"
   fi
}

if [ $user -ne 0 ]; then
   echo -e " $R switch to root user and run commands $N"
   exit 1
else
   echo -e " $G starting the installation... $N"
fi

dnf install nginx -y &>>$LOGFILE

CHECK $? "installing nginx.."

systemctl enable nginx &>>$LOGFILE

CHECK $? "enabling nginx.."

systemctl start nginx &>>$LOGFILE

CHECK $? "starting nginx.."

rm -rf /usr/share/nginx/html/* &>>$LOGFILE

CHECK $? "removing default webpage from nginx.."

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>>$LOGFILE

CHECK $? "downloading our own webcontent.."

cd /usr/share/nginx/html &>>$LOGFILE

CHECK $? "switching to nginx web folder"

unzip -o /tmp/web.zip &>>$LOGFILE

CHECK $? "unzipping files in nginx html folder"

cp /home/centos/auromationscripts/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$LOGFILE

CHECK $? "adding and nginx conf file.."

systemctl restart nginx &>>$LOGFILE

CHECK $? "restarting nginx.."