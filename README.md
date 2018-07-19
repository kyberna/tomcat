# Kyberna AG Tomcat Docker image

* Based on the official tomcat Images.
* Added SSH Client.
* Changed ENVs to run with mounted Data / Apps

### Usage
* drop a .war file to the deploy directory

#### Volumes
* /data: default data directory
* /conf: default application config directory
* /deploy: deploy folder were the .war file needs to be placed
* /tlib: libs copied to tomcat dir
* /tconf: configuration files from tomcat/conf

#### Environments
* XMX: Max Memory -> default: 2G
* LICENSE: Path to license file -> default: /conf/license.lic
* DATA: data directory -> default: /data
* CONF: application config directory -> default: /conf
* PROPERTIES_PROFILES: default: not set
* ADDITIONAL_OPTS: default: not set
* RMI_HOSTNAME: default: not set
---
* DISABLE_DEFAULT_DEPLOY: to disable default deployment set to 'true' -> default: not set
* ADDITIONAL_SCRIPT: additional script to be executet befor start -> default: not set
---
* CLUSTER: to enable a server.xml with SimpleTcpCluster configured set to 'true' -> default: not set
---
* JMX_PORT: for debuging -> default: not set
---



---
### Old Part
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