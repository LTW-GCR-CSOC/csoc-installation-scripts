## Installation

Tested on Ubuntu Mate LTS 16.04 with Raspberry Pi 3

This script will install Dionaea honeypot onto an Ubuntu Mate instance.

It is currently a work in progress.

To install all of the template files, run the following script from the root of your project's directory:

```
wget https://github.com/LTW-GCR-CSOC/canary-installation-scripts/archive/master.zip && \
unzip master.zip && \
cd canary-installation-scripts-master/ && \
chmod +x *.sh && \
./honeypots.sh
```
Dionaea logs and database will be in this directory /opt/dionaea/var/dionaea
      
To view the Cowrie Log Viewer,visit port 5000 of your IP address

Note : You will be prompted to enter password to execute sudo commands

----

# LTW GCR Cybersecurity Operations Center Project

**Description**:  

This GCR open source project is focused on delivering an easy to deploy open source solution for cybersecurity monitoring and response for small to medium enterprises.  The project goal is a push-button install of a fully configured Cybersecurity Operations Center (CSOC) solution suitable for use by managed service providers focused on small businesses, or medium sized enterprise IT departments.  

The project assets will include: software, documentation, training materials.

The software will configure, integrate and enhance existing open source software cybersecurity projects, including: Apache Metron, Dionaea, Cowrie, OSSEC and others.   

Integration of cybersecurity sensors is a priority for the project to reduce labour and complexity associated with deploying open source security operations center solutions.  The project includes a remotely managed honeypot device that suitable for use as a sensor for intrusion detection in SME environments.
 
The project will include CSOC Operational Handbook templates.  

Online training materials will be provided for SME employees to help address employee security awareness. 

The project is currently in progress and available at https://github.com/LTW-GCR-CSOC

Other things to include:

  - **Technology stack**:  TBC
  - **Status**:  Alpha [CHANGELOG](CHANGELOG.md).
  - **Links to production or demo instances** TBC


**Screenshot**:  

TBD


## Dependencies

Describe any dependencies that must be installed for this software to work.
This includes programming languages, databases or other storage mechanisms, build tools, frameworks, and so forth.
If specific versions of other software are required, or known not to work, call that out.

## Installation

Detailed instructions on how to install, configure, and get the project running.
This should be frequently tested to ensure reliability. Alternatively, link to
a separate [INSTALL](INSTALL.md) document.

## Configuration

If the software is configurable, describe it in detail, either here or in other documentation to which you link.

## Usage

TBC - show users how to use the software.

## How to test the software

TBC - if the software includes automated tests, detail how to run those tests.

## Known issues

Currently a work in progress

## Getting help

If you have questions, concerns, bug reports, etc, please file an issue in this repository's Issue Tracker.

## Getting involved

[CONTRIBUTING](CONTRIBUTING.md)


----

## Open source licensing info
1. [TERMS](TERMS.md)
2. [LICENSE](LICENSE)


----

## Credits and references

TBC


