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

dnf module disable mysql -y &>>$LOGFILE

CHECK $? "disabling default mysql version"

cp mysql.repo /etc/yum.repos.d/mysql.repo

CHECK $? "copying mysql repo in etc file"

dnf install mysql-community-server -y

CHECK $? "installing mysql specific version.."

systemctl enable mysqld

CHECK $? "enabling mysql.."

systemctl start mysqld

CHECK $? "starting mysql"

# passwords part is highly not recommended to write in shell script..

mysql_secure_installation --set-root-pass RoboShop@1

CHECK $? "setting username and passwd.."

mysql -uroot -pRoboShop@1

CHECK $? "login through given credentials"