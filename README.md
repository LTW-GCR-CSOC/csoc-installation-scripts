# LTW GCR Cybersecurity Operations Center Project
1 [Description](#Description)
2 [Screenshots](#Screenshots)

##Description 

This GCR open source project is focused on delivering an easy to deploy open source cybersecurity monitoring solution for small to medium enterprises.  The project goal is a push-button install the platform software necessary to support a professional-level Cybersecurity Operations Center (CSOC) solution suitable for use by managed service providers focused on small businesses, or medium sized enterprise IT departments.

The project assets will include: software, documentation, and training materials.

The software will configure, integrate and enhance existing open source software cybersecurity projects, including: Apache Metron, Dionaea, Cowrie, OSSEC and others.   

Integration of cybersecurity sensors is a priority for the project to reduce labour and complexity associated with deploying open source security operations center solutions.  The project includes a remotely managed honeypot device (LTW GCR Canary) that suitable for use as a sensor for intrusion detection in SME environments.
 
The project will include CSOC Operational Playbook templates suitable for use by manager service providers or IT department staff responsible for operating the CSOC.  

Online training materials will be provided for SME employees to help address employee security awareness. 

The project is currently in progress and available at https://github.com/LTW-GCR-CSOC

##Screenshots  

TBC


## Dependencies

Describe any dependencies that must be installed for this software to work.
This includes programming languages, databases or other storage mechanisms, build tools, frameworks, and so forth.
If specific versions of other software are required, or known not to work, call that out.

## Installation

### Apache Metron 

To be provided

### LTW GCR Canary 

Tested on Ubuntu Mate LTS 16.04 with Raspberry Pi 3.

This script will install Dionaea honeypot onto an Ubuntu Mate instance.

It is currently a work in progress.

To install all of the template files, run the following script from the root of your project's directory:

```
wget https://github.com/LTW-GCR-CSOC/csoc-installation-scripts/archive/master.zip && \
unzip master.zip && \
cd csoc-installation-scripts-master/ && \
chmod +x *.sh && \
./honeypots.sh
```
Dionaea logs and database will be in this directory /opt/dionaea/var/dionaea
      
To view the Cowrie Log Viewer,visit port 5000 of your IP address

Note : You will be prompted to enter password to execute sudo commands

## Configuration

TBC - information on configurable items related to the software.

## Usage

TBC - show users how to use the software.

## How to test the software

TBC - information on how to run automated tests on the software.

## Known issues

Currently under active development, see this repository's Issue Tracker.

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




