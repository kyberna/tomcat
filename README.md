# Kyberna AG Tomcat Docker image

Changed some env to easily use it with your persistent data.

## Description
- Actual Version: 7.0.63

### Intention
* use this tomcat with only one app deployd as root app.
* use the node.tar.gz from the repo, extract and use as host folders.


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
