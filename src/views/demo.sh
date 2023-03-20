#!/bin/bash

#服务名称

SERVER_NAME=springboot

# 源jar路径,mvn打包完成之后，target目录下的jar包名称，也可选择成为war包，war包可移动到Tomcat的webapps目录下运行，这里使用jar包，用java -jar 命令执行  

JAR_NAME=lr-web-1.0-SNAPSHOT.jar

# 源jar路径  

#/usr/local/jenkins_home/workspace--->jenkins 工作目录

#demo 项目目录

#target 打包生成jar包的目录

JAR_PATH=/home/jenkins_home/workspace/maven_demo/lr-server/lr-web/target

# 打包完成之后，把jar包移动到运行jar包的目录--->work_daemon，work_daemon这个目录需要自己提前创建
JAR_WORK_PATH=/home/backend/
#复制jar包到执行目录
cp $JAR_PATH/$JAR_NAME $JAR_WORK_PATH

echo "复制jar包完成"
#重启后台服务
podman restart demo