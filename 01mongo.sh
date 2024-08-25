#!/bin/bash


# function to validate using exit status

user=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

CHECK(){
    if [ $1 -ne 0 ]
    then
       echo -e " $2 $R failed..$N "
       exit 1 
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

cp mongo.repo  /etc/yum.repos.d/mongo.repo
CHECK $? "copying mongo repo"

dnf install mongodb-org -y 
CHECK() $? "installing mongodb"

systemctl enable mongod 
CHECK() $? "enabaling mongodb"

systemctl start mongod
CHECK() $? "started mongodb"

#changing mongobd host ip using sed(streamline editor ) very powerful

sed -i 's/127.0.0.1 to 0.0.0.0g' /etc/mongod.conf
CHECK() $? " setting remote access to mongodb"

systemctl restart mongod 
CHECK() $? "restarting mongodb"
