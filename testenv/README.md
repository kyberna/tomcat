# Kyberna AG Tomcat Docker image

Changed some env to easily use it with your persistent data.

## Description
The idea is to use this tomcat with only one app deployd as root app.
You can use the node.tar.gz from the repo.
You can change your catalina_opts in /node/init.sh from the tar.gz or do other things like pull your last .war file from a repo to deploy.
On the default init.sh a *.war file from /deploy will be unpaked to the webapp/ROOT folder.


### Usage

To run it with host dir's mounted:

	$ docker run -itd -p 8080:8080 \
        -v hostDir/node:/node \
        -v hostDir/data:/data \
        -v hostDir/deploy:/deploy \
        kyberna/tomcat

### Tags

testenv: is an image not changing the user. sometimes easier in test environments
latest: default image with user 1000