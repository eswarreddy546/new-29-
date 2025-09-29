#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/new-29-"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
#SCRIPT_DIR=$PWD
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
cp ribbitmq.repo //etc/yum.repos.d/rabbitmq.repo/ribbitmq.repo
valid $? "moving data from one service"

dnf install rabbitmq-server -y
valid $? " Install rabbitmq-server"


systemctl enable rabbitmq-server
valid $? " enable rabbitmq server"

systemctl start rabbitmq-server
valid $? " start rabbitmq server"


rabbitmqctl add_user roboshop roboshop123

valid $? " add_user roboshop"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
valid $? " enable permissions finally"
