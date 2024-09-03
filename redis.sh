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

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOGFILE

CHECK $? "istalling redis rpm.."

dnf module enable redis:remi-6.2 -y &>>$LOGFILE

CHECK $? "enabling redis:remi-6.2.."

dnf install redis -y &>>$LOGFILE 

CHECK $? "installing redis.."

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf &>>$LOGFILE

CHECK $? "ip config is sucessfull.."

systemctl enable redis &>>$LOGFILE 

CHECK $? "enabling redis is.."

systemctl start redis &>>$LOGFILE

CHECK $? "starting redis is.."