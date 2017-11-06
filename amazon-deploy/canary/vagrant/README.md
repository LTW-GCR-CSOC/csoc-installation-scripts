# Carleton University - GCR Cybersecurity Operations Center Project

  * [Description](#description)
  * [Plans](#plans)
  
## Description 
  
## Plans
  
## Installation

### GCR Canary

The following scripts have been tested on AWS EC2.

To install all of the GCR Canary software on AWS, run the following script on Mac OSX:

```
source aws-credentials
vagrant up
```
#### Configuration
You must configure the aws keys in the "aws-credentials" file.
...
export AWS_KEY='xxxxxxxxxxxxxxx'
export AWS_SECRET='xxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
export AWS_KEYNAME='xxxx'
export AWS_KEYPATH='/xxx/xxx/xxxx.pem'
...

for example (keys are not real keys):
...
export AWS_KEY='ZXYIIBBHX5GXZ3LYYJGA'
export AWS_SECRET='TILjXpa8BznwnNKIqkqDTMcK4ELmnzqjkN1FsxPL'
export AWS_KEYNAME='aws-canary'
export AWS_KEYPATH='/Users/gcruser/awscanary/aws-canary.pem'
...
