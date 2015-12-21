# Kyberna AG Tomcat Docker image

* Based on the official tomcat Images.
* Added SSH Client.
* Changed ENVs to run with mounted Data / Apps

### Usage

* catalina_opts can be changed in [hostDir]/node/init.sh
* drop a .war file to [hostDir]/deploy, this will be deployed on next container restart.

To run it with host dir's mounted:

```bash
docker run -itd -p 8080:8080 \
	-v hostDir/node:/node \
	-v hostDir/data:/data \
	-v hostDir/deploy:/deploy \
	kyberna/tomcat
```