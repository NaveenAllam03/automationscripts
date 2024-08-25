#!/bin/bash


# function to validate using exit status

user=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

set -xe

LOGFILE="/home/centos-$0.log"
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

cp mongo.repo  /etc/yum.repos.d/mongo.repo &>> $LOGFILE

CHECK $? "copying mongo repo"

dnf install mongodb-org -y &>> $LOGFILE

CHECK() $? "installing mongodb"

systemctl enable mongod &>> $LOGFILE

CHECK() $? "enabaling mongodb"

systemctl start mongod &>> $LOGFILE

CHECK() $? "started mongodb"

#changing mongobd host ip using sed(streamline editor ) very powerful

sed -i 's/127.0.0.1 to 0.0.0.0g' /etc/mongod.conf &>> $LOGFILE

CHECK() $? " setting remote access to mongodb"

systemctl restart mongod &>> $LOGFILE

CHECK() $? "restarting mongodb"
