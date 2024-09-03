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


dnf install maven -y

useradd roboshop

mkdir /app

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip

cd /app

unzip /tmp/shipping.zip