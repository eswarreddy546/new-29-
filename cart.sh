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
valid $? "module disable"

dnf module enable nodejs:20 -y
valid $? "module enable"

dnf install nodejs -y
valid $? "install node js"


useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop

mkdir -p /app 


curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart-v3.zip
valid $? "module disable"

# shellcheck disable=SC2164
cd /app 

valid $? "copy the directory"

rm -rf /app/*
valid $? "Removing existing code"

unzip /tmp/cart.zip
valid $? "unzip the file"


cd/app 
valid $? "move directory"

npm install 
valid $? "npm commands installing"

cp $SCRIPT_DIR/cart.service /etc/systemd/system/cart.service
echo "copy the data to cart"

systemctl daemon-reload
valid $? "daemon is the reload"


systemctl enable cart 
valid $? "enable the cart"

systemctl start cart
valid $? "start the cart"
