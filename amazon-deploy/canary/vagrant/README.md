# Canary install to AWS

  * [Description](#description)
  * [Plans](#plans)
  * [Installation](#installation)
  
## Description 
This script installs an instance of the GCR Canary onto an EC2 instance.
  
## Plans
 * Convert the inline shell script in Vagrantfile to Ansible, look at the Dinotools Ansible playbook they have done for Dionaea.
 * Add Vagrant configuration for VPC, Security Policy, iGW, and Elastic IP, look at Metron Ansible playbook for associated example tasks
  
## Installation
### Honeypots.sh Prep
See [GCR Configuration](https://github.com/LTW-GCR-CSOC/csoc-installation-scripts) for details related to honeypots.sh configuration.

For the AWS Canary install, update honeypots.sh settings as follows:
```
PREINSTALL_CLEANUP="no"
INSTALL_REFRESH="yes"
INSTALL_CLEANUP="no"

INSTALL_DIONAEA="yes"  
INSTALL_DIONAEALOGVIEWER="no"  

INSTALL_COWRIE="no"  
INSTALL_COWRIELOGVIEWER="no"  

INSTALL_OSSEC="no"  
INSTALL_OPENVAS="no" 
INSTALL_AWSIOT="no" 
INSTALL_MENDER="no" 
INSTALL_RP="no"
INSTALL_VNCSERVER="no"
SETUP_SYSLOG="no"
SETUP_HOSTNAME="no" 
```

### AWS Prep
Select Canonical's LTS 16 Ubuntu AMI appropriate to the region you plan to deploy in. 

Setup the VPC, Subnet, Security Group, Internet Gateway, Region and Elastic IP using the AWS Console.   Update the Vagrantfile to add in your associated configuration, e.g.

```
aws.ami = "ami-b3cf71d7"
aws.region = "ca-central-1"
aws.instance_type = "t2.micro"
aws.security_groups = ["sg-ddd616b5"]
aws.subnet_id = "subnet-3bcbb040"
aws.elastic_ip = "35.182.85.71"
```

### GCR Canary
The following scripts have been tested on AWS EC2.

To install all of the GCR Canary software on AWS, run the following commands on Mac OSX to download the files needed to your computer:
```
mkdir ~/awscanary && \
cd ~/awscanary && \
wget -q https://github.com/LTW-GCR-CSOC/csoc-installation-scripts/archive/master.zip && \
unzip -qq master.zip && \
cd csoc-installation-scripts-master/ && \
chmod +x *.sh && \
cd ./amazon-deploy/canary/vagrant
```

#### Configuration
You must configure the aws keys in the "aws-credentials" file,
```
export AWS_KEY='xxxxxxxxxxxxxxx'
export AWS_SECRET='xxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
export AWS_KEYNAME='xxxx'
export AWS_KEYPATH='/xxx/xxx/xxxx.pem'
```

for example (keys are not real keys):
```
export AWS_KEY='ZXYIIBBHX5GXZ3LYYJGA'
export AWS_SECRET='TILjXpa8BznwnNKIqkqDTMcK4ELmnzqjkN1FsxPL'
export AWS_KEYNAME='aws-canary'
export AWS_KEYPATH='/Users/gcruser/awscanary/aws-canary.pem'
```

Once you have updated the aws-credentials file, run the following commands:
```
source aws-credentials && \
vagrant up 
```

## FAQ
To be added
