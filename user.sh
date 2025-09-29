#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"

LOGS_FOLDER="/var/log/new-29-"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
SCRIPT_DIR=$PWD
#MONGODB_HOST=mongo.eswar.xyz
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log" # /var/log/shell-script/16-logs.log

mkdir -p $LOGS_FOLDER
echo "Script started executed at: $(date)" | tee -a $LOG_FILE

if [ $USERID -ne 0 ]; then
    echo "ERROR:: Please run this script with root privelege"
    exit 1 # failure is other than 0
fi

valid (){ # functions receive inputs through args just like shell script args
    if [ $1 -ne 0 ]; then
        echo -e "$2 ... $R FAILURE $N" | tee -a $LOG_FILE
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N" | tee -a $LOG_FILE
    fi
}
dnf module disable nodejs -y
valid $? "disable nodejs"

dnf module enable nodejs:20 -y
valid $? "enable nodejs"


dnf install nodejs -y
valid $? "install nodejs"

useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop

mkdir -p /app 

curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user-v3.zip 

valid $? "excuting the curl"


cd/app 

rm -rf /app*
valid $? " sucessfully remove the fileees"

unzip /tmp/user.zip
valid $? "unzip the file"



cd /app 
npm install 
valid $? "npm install is sucessfully completed"

cp $SCRIPT_DIR /User.server /etc/systemd/system/user.service

systemctl daemon-reload
valid $? "daemon is reload sucessfully"


systemctl enable user 
valid $? "sucessfully enable the user"

systemctl start user
valid $? "sucessfully start the user"
