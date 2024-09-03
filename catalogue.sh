#!/bin/bash

user=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

# set -x  --> used to debug the code 
# set -e  --> to exit at error
# set -xe --> to do both operations simultaneously

TIME=$(date +%F-%H-%M-%S)

LOGFILE="/home/centos/$0.log"  #logfile to store the info to debug

# function to validate using exit status

CHECK(){
    if [ $1 -ne 0 ]
    then
       echo -e " $2 $R failed..$N "
    else
       echo -e " $2 $G sucessfull..$N"   
    fi
}

if [ $user -ne 0 ]
then
   echo -e " $R switch to root user and run commands $N"
   exit 1
else
   echo -e " $G starting the installation... $N"
fi   

dnf module disable nodejs -y &>>$LOGFILE

CHECK $? "disabling default nodejs version"

dnf module enable nodejs:18 -y &>>$LOGFILE

CHECK $? "enabling nodejs:18 version"

dnf install nodejs -y &>>$LOGFILE

CHECK $? "installing nodejs:18 version"

id roboshop &>>$LOGFILE
if [ $? -ne 0 ]; then
   useradd roboshop
   CHECK $? "adding new user"
else
   echo -e "user Already exists.. $Y skipping $N"   
fi

mkdir -p /app &>>$LOGFILE

CHECK $? "creating app directory.."

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>$LOGFILE

CHECK $? "downloading catalogue service from s3 bucket.."

cd /app &>>$LOGFILE

CHECK $? "switching to created app directory.."

unzip -o /tmp/catalogue.zip &>>$LOGFILE

CHECK $? "unzipping catalogue service in app directory.."

npm install &>>$LOGFILE

CHECK $? "installing dependencies for catalogue service in app directory.."

cp /home/centos/automationscripts/catalogue.service /etc/systemd/system/catalogue.service &>>$LOGFILE

CHECK $? "adding catalogue service to daemon service"

systemctl daemon-reload &>>$LOGFILE

CHECK $? "reloading daemon service.. "

systemctl enable catalogue &>>$LOGFILE

CHECK $? "enabling catalogue service.. "

systemctl start catalogue &>>$LOGFILE

CHECK $? "starting catalogue service.. "

cp /home/centos/automationscripts/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

CHECK $? "copying mongo repo.. yum.repos.d"

dnf install mongodb-org-shell -y &>>$LOGFILE

CHECK $? "dowloading mongo db client.."

mongo --host MONGODB-SERVER-IPADDRESS </app/schema/catalogue.js &>>$LOGFILE

CHECK $? "loading data to  mongodb using mongodb client.."









