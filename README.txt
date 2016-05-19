
Introduction::

This document details the implementation works of a Mybb Site via cloud formation template.This MyBB is site required to be scalable,high available and good security. 


Requirements:
	1- EC2 Key Pair for the region that you are deploying your stack.And please remember the key name for the parameters of the template.
	2- AWS Account
	3- The deployment is conducting 2 download operations:
		a) Source Code of MyBB 
		b) Sample Config Files & Install Script	
		https://github.com/mybb/mybb/tarball/master
		https://github.com/servetguney/mbbw/tarball/master

How to Deploy:
	1- Login to AWS Console
	2- Create the  stack with the template.
	3- Wait ( it takes time ) 
	4- Check the site with the loadbalancer dns name as result. 

Design:

The EC2 Instance Family: t,c,m3
The Database Instance Family:t,r,m3
Database Type: MySQL
The Naming Schema: Every logical word has been capitalized in name of the source.Example: DatabaseName, InstanceLaunchConfig...etc
2 layers of security via both security access groups and networkacls
Subnets: The  10.10.{2,4,6,8}x.0/24  networks are reserved for public use
		  10.10.{3,5,7,9}x.0/24 networks are reserved for private use for future improvements.
Lower cost focused design.
	
Whats Left:

Tags:Much better tags for explanatory & fix the absents )
Logs:There should be logging enabled for the instances & connections to S3.
More Alarms: There should be more complex & extensive alarms in the stack.
Media Files: MyBB media files should be stored on S3 Bucket ( with scheduled backups )
High Avaibility:MyBB is now MultiAZ but only 2 AZ. Needs improvement for cross region & all AZ of the region if more than 2.
The DB size control: There is no control or adding storage for the DB now.
HTTPS: Change site to HTTPS based web host.
Domain DNS:Needs to define domain dns records for production use.
Unmap Gateway IP before deleting the VPC ( else it gives error about  deleting failure )
	
Resources:

Web Servers:

There will be minimum 2 web servers. They will scale up to 5 and can be down again till 2 ( 1 by 1 ). There scaling up & down rules. There is related autoscaling group defined.
	
Vertical Scaling : needs downtime & change instance resources.

DB Servers:

	There is 1 DB with MultiAZ feature enabled. There is only 1 replica.
	Vertical Scaling : needs downtime & add instance resources.
	Horizontal Scaling: Migrate to Aurora DB Cluster
 
Load Balancer: 

There is a load balancer that distributing the requests to webservers. There is custom launch configuration attached for installations and configurations based on cfn-init & metadata.

Alarms:
	Scaling down and up alarms has been defined.

Problem:
Unfortunately, I didn't have time to troubleshoot the network problem that causing to connection problems, and leading unsuccessful site deployment.

