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

cp /home/centos/automationscripts/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

CHECK $? "copying mongo repo"

dnf install mongodb-org -y &>>$LOGFILE

CHECK $? "installing mongodb"

systemctl enable mongod &>>$LOGFILE

CHECK $? "enabaling mongodb"

systemctl start mongod &>>$LOGFILE

CHECK $? "started mongodb"

#changing mongobd host ip using sed(streamline editor ) very powerful

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>$LOGFILE

CHECK $? "setting remote access to mongodb"

systemctl restart mongod &>>$LOGFILE

CHECK $? "restarting mongodb"
