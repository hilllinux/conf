#! /bin/bash

# 1. 判断目录是否存在
# 如果不存在，则svn更新下来。
# 如果存在，则 
# a. 先判断runnging_project软链接是否存在，存在则删除running_project，不存在则直接创建 
BASE_HOME="/Users/wangsongqing/workspace"
SVN_PATH="http://svn.beyondin.com/test"
RUNNING_PROJECT="$BASE_HOME/running_project"
PROJECT_NAME=$2
CMD=$1
USERNAME="helloworld"
PASSWORD="helloworld"
 
SVN_PROJECT=$SVN_PATH/$PROJECT_NAME
PROJECT_PATH=$BASE_HOME/$PROJECT_NAME

do_switch() {
    if [ ! -d $BASE_HOME/$PROJECT_NAME ]; then
        svn co "$SVN_PROJECT" --username $USERNAME --password $PASSWORD $PROJECT_PATH
    else
        svn up --username $USERNAME --password $PASSWORD $PROJECT_PATH
    fi

    # svn 更新不成功
    if [ ! -d "$PROJECT_PATH" ]; then
        echo "svn co failed! please retry later"
        exit
    fi

    if [ ! -d "$PROJECT_PATH/Runtime" ]; then
        mkdir $PROJECT_PATH/Runtime
    fi
    chmod -R a+w $PROJECT_PATH/Runtime

    if [ ! -d "$PROJECT_PATH/Uploads" ]; then
        mkdir $PROJECT_PATH/Uploads
    fi
    chmod -R a+w $PROJECT_PATH/Uploads

    rm $RUNNING_PROJECT

    ln -s $PROJECT_PATH $RUNNING_PROJECT
}

do_update() {
    if [ ! -d $BASE_HOME/$PROJECT_NAME ]; then
        echo "workspace not found"
        exit
    else
        svn up --username $USERNAME --password $PASSWORD $PROJECT_PATH
    fi
}

case "$1" in
    change)
    do_switch
    ;;
    update)
    do_update
    ;;
    *)
    echo "Usage: $SCRIPT {start|stop|reload|restart|quit|test|info}"
    exit 2
    ;;
esac
 
exit 0
