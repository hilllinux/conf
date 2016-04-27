#! /bin/bash

PROJECT_NAME=hgb
SERVER_NAME=www.hgb.com
SQL_FILE=$PROJECT_NAME.sql

MYSQL_USERNAME=root
MYSQL_PASSWORD=123456

NGX_PATH=/etc/nginx
NGX_TEMPLETE_FILE=$NGX_PATH/conf/templete.conf
NGX_CONFIG_FILE_PATH=$NGX_PATH/conf/conf.d

SVN_PREFIX=http://svn.a.com/
SVN_USERNAME=test
SVN_PASSWORD=test

WEB_USER=www
WEB_GROUP=www

PREFIX=/var/www
LOG_PATH=$PREFIX/auto_deploy.log

CONF_FILE=$PREFIX/$PROJECT_NAME/Conf/"config.php"
SQL_FILE_COMBINED=$PREFIX/$PROJECT_NAME/db/$PROJECT_NAME

echo "**** `date +%Y%m%d` start deploy process ****" >> $LOG_PATH
echo "*** `date +%Y%m%d` svn check out process start ***"  >> $LOG_PATH

cd $PREFIX

if [ ! -d $PROJECT_NAME ]; then
    svn --non-interactive --username $SVN_USERNAME --password $SVN_PASSWORD co $SVN_PREFIX/$PROJECT_NAME &>> $LOG_PATH
else
    svn --non-interactive --username $SVN_USERNAME --password $SVN_PASSWORD up $PREFIX/$PROJECT_NAME &>> $LOG_PATH
fi

echo "*** `date +%Y%m%d` svn check out process finish ***"  >> $LOG_PATH
echo "*** `date +%Y%m%d` create sql file process start ***"  >> $LOG_PATH

echo "create database $PROJECT_NAME;"                                                > $SQL_FILE_COMBINED
echo "CREATE USER \"$PROJECT_NAME\"@\"localhost\" IDENTIFIED BY \"$PROJECT_NAME\";" >> $SQL_FILE_COMBINED
echo "GRANT ALL  ON $PROJECT_NAME.* to \"$PROJECT_NAME\";"                          >> $SQL_FILE_COMBINED
echo "use $PROJECT_NAME;"                                                           >> $SQL_FILE_COMBINED
cat $PREFIX/$PROJECT_NAME/db/$SQL_FILE                                              >> $SQL_FILE_COMBINED

# 检测update.sql 是否存在，如果存在则合并进来；
if [ -f $PREFIX/$PROJECT_NAME/db/update.sql ]; then
    cat $PREFIX/$PROJECT_NAME/db/update.sql >> $SQL_FILE_COMBINED
fi

if [ -f $SQL_FILE_COMBINED ]; then
    mysql -u$MYSQL_USERNAME -p$MYSQL_PASSWORD < $SQL_FILE_COMBINED &> $LOG_PATH
fi

echo "*** `date +%Y%m%d` create sql file process finish ***"  >> $LOG_PATH

# 替换 数据库 username 和 passwd
# DB_NAME DB_USER DB_PWD
echo "*** `date +%Y%m%d` modify config file process start ***"  >> $LOG_PATH
REPLACE_DB_NAME="\'DB_NAME\' =>  \'${PROJECT_NAME}\'," 
REPLACE_DB_USER="\'DB_USER\' =>  \'${PROJECT_NAME}\'," 
REPLACE_DB_PWD="\'DB_PWD\' =>  \'${PROJECT_NAME}\'," 

# 通过 sed 命令替换
cat $CONF_FILE | sed -r "s/.*DB_NAME.*/$REPLACE_DB_NAME/" | sed -r "s/.*DB_USER.*/$REPLACE_DB_USER/" | sed -r "s/.*DB_PWD.*/$REPLACE_DB_PWD/" > ${CONF_FILE}.tmp

mv ${CONF_FILE}.tmp ${CONF_FILE}
echo "*** `date +%Y%m%d` modify config file process finish ***"  >> $LOG_PATH

# 创建web用户可读写文件夹
echo "*** `date +%Y%m%d` create folder process start ***"  >> $LOG_PATH

if [ ! -d $PREFIX/$PROJECT_NAME/Runtime ]; then 
    mkdir $PREFIX/$PROJECT_NAME/Runtime
fi
if [ ! -d $PREFIX/$PROJECT_NAME/Uploads ]; then 
    mkdir $PREFIX/$PROJECT_NAME/Uploads
fi

chown -R ${WEB_USER}:${WEB_GROUP} $PREFIX/$PROJECT_NAME/Runtime
chown -R ${WEB_USER}:${WEB_GROUP} $PREFIX/$PROJECT_NAME/Uploads
echo "*** `date +%Y%m%d` create folder process end ***"  >> $LOG_PATH

# nginx 模版
ROOT_PATH=$PREFIX/$PROJECT_NAME
cat $NGX_TEMPLETE_FILE | sed -r "s:TEMPLETE_SERVER_NAME:${SERVER_NAME}:" | sed -r "s:TEMPLETE_ROOT:${ROOT_PATH}:" > ${NGX_CONFIG_FILE_PATH}/${PROJECT_NAME}.conf

if [ -f ${NGX_CONFIG_FILE_PATH}/${PROJECT_NAME}.conf ]; then
    service nginx restart &>> $LOG_PATH
fi

echo "*** `date +%Y%m%d` all process done ***"  >> $LOG_PATH
