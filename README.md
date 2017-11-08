![Global Cybersecurity Resource](https://github.com/LTW-GCR-CSOC/csoc-installation-scripts/blob/master/githubGCRheader.png?raw=true "Global Cybersecurity Resource")   

# Carleton University - GCR Cybersecurity Operations Center Project

  * [Description](#description)
  * [Plans](#plans)
  * [Screenshots](#screenshots)
  * [Installation](#installation)
    + [GCR Canary](#gcr-canary)
    + [Alert Collection Server](#alert-collection-server)
  * [How to test the software](#how-to-test-the-software)
  * [Known issues](#known-issues)
  * [GCR Canary Case](#gcr-canary-case)
  * [GCR CSOC Playbook](#gcr-csoc-playbook)
  * [Getting help](#getting-help)
  * [Getting involved](#getting-involved)
  * [Open source licensing info](#open-source-licensing-info)
  * [Related open source projects](#related-open-source-projects)
  * [Credits and references](#credits-and-references)
  * [Contributors](#contributors)

## Description 

The [GCR](https://cugcr.com/tiki/lce/index.php) - CSOC (**C**yber**s**ecurity **O**perations **C**enter) initiative seeks to provide small to medium size enterprises with openly available cybersecurity resources to self-manage their own security or enable companies to offer cybersecurity services to others as part their business. 

The development of this project is primarily divided into three focus areas: i) Developing open source software to compliment SOC services ii) Developing SOC operation guides and templates as a means to manage security iii) Creating SOC "Pathway Training" material for online learning. 

**Open Source Software Development:**   
Open source software development activities for this project seeks to configure, integrate and enhance existing open source projects (such as [Dionaea](https://github.com/LTW-GCR-CSOC/dionaea), [Cowrie](https://github.com/LTW-GCR-CSOC/cowrie), [OSSEC](https://github.com/LTW-GCR-CSOC/ossec-hids), [OpenVAS](https://github.com/LTW-GCR-CSOC/openvas-commander) and others) to report to a central alert collector (such as [Apache Metron](http://metron.apache.org)). The central alert collector will be used for alert aggregation and analytics. Development also includes the creation of "GCR Canary" honeypots. The honeypots are physically and virtually deployable. As the GCR Canary project evolves it will include the various sensors mentioned above. The GCR Canary honeypot can be used for intrusion detection in SME environments. 
 
**CSOC Operation Guide Creation:**   
The creation of the GCR CSOC Playbook will include guidance and templates for managing cybersecurity in an organization.

**CSOC Pathway Training Material:**   
Online training resources seeks to improve the adoption of proper cybersecurity hygiene within an organization

## Plans
This project is being rolled out over three phases. We are currently focused on Phase 1. Details of our plans are available [here](https://github.com/LTW-GCR-CSOC/csoc-installation-scripts/projects/3).


## Screenshots  
The following screenshots (from left to right) are of Apache Metron (used for centralized alert collection), a terminal output of a GCR Canary honeypot, and a screen capture of the GCR CSOC Playbook. 
![Global Cybersecurity Resource - Collage of screenshots](https://github.com/LTW-GCR-CSOC/csoc-installation-scripts/blob/master/images/GCRCSOC-ScreenshotCollage3.png?raw=true "Global Cybersecurity Resource - Collage of screenshots")   

The following screenshot shows a customized dashboard in Apache Metron that presents alert information from a GCR Canary honeypot.
![Metron Analytics UI - GCRDionaea](https://github.com/LTW-GCR-CSOC/csoc-installation-scripts/blob/master/images/Dionaea-MetronDashboard2.png?raw=true "Image: Metron UI showing GCRDionaea alerts")   


A GCR Canary honeypot was configured to send Dionaea type alerts to the Apache Metron central server. The Metron Management UI was used enter how the alert should be parsed.
![Metron Management UI - GCRDionaea](https://github.com/LTW-GCR-CSOC/csoc-installation-scripts/blob/master/images/Dionaea-ManagementUI.png?raw=true "Image: Metron Management UI showing GCRDionaea GROK settings")   


In the alert collection server Apache Nifi was used to channel Syslog alert information to a Kafka broker for further processing by Apache Metron.
![Nifi UI - GCRDionaea](https://github.com/LTW-GCR-CSOC/csoc-installation-scripts/blob/master/images/nifiDionaeaKafka.png?raw=true "Image: Using Nifi to create a dataflow from GCRDionaea alerts to Kafka")



## Installation

### GCR Canary
The installation procedure below was tested on [Ubuntu Mate](https://ubuntu-mate.org/) LTS 16.04 with [Raspberry Pi](https://www.raspberrypi.org) 3.
* UPDATE Oct, 2017: Simple alerts from Dionaea can be reported to a remote server using syslog(unencrypted). Alerts are GROK formatted and ingested by Apache Metron.
* Project is currently under active development and testing. 

To install all of the GCR Canary software, run the following script on Ubuntu Mate:

```
cd ~ && \
wget https://github.com/LTW-GCR-CSOC/csoc-installation-scripts/archive/master.zip && \
unzip master.zip && \
cd csoc-installation-scripts-master/ && \
chmod +x *.sh 
```
#### Configuration

Configuration settings (such as disabling the install of OpenVAS, OSSEC, ext..) is in honeypots.sh. 
Within honeypots.sh change the INSTALL_* parameters as needed. The following is an example of enabling Dionaea for install and disabling Cowrie for install. 
```
INSTALL_DIONAEA="yes"

INSTALL_COWRIE="no"  
```
After the updates have been made run honeypots.sh
```
./honeypots.sh
```

**Dionaea Service within GCR Canary:** 
The following provides guidance on the GROK formatted output which is intended for use with Apache Metron:
[GCRDionaea GROK Format](https://github.com/LTW-GCR-CSOC/csoc-installation-scripts/tree/master/SampleLogFiles)

The Dionaea logs and sqlite3 database is stored in /opt/dionaea/var/dionaea within GCR Canary.

If INSTALL_DIONAEALOGVIEWER was set to "yes", to view the Dionaea Logs visit http://0.0.0.0:8000

**Cowrie Service within GCR Canary:** 
If INSTALL_COWRIE and  INSTALL_COWRIELOGVIEWER were set to "yes", to view the Cowrie Logs, visit http://0.0.0.0:5000 

### Alert Collection Server
This project uses Apache Metron to collect alerts from the distribution of GCR Canary honeypots. Below are links that can provide guidance to install Apache Metron.
* [Home Page](http://metron.apache.org) 
* [Install Guide](https://cwiki.apache.org/confluence/display/METRON/Installation) 
* [Source Code](https://github.com/apache/metron)
You can use the Apache Metron [mailing list](http://metron.apache.org/community/) if any issues are encountered during install. 

**Syslog configuration for GCR Canary alert ingest**
The following syslog configuration files will need to be installed on the server. (syslog config files)[https://github.com/LTW-GCR-CSOC/csoc-installation-scripts/tree/master/SampleLogFiles/configForServer-notEnc]

**Apache Metron Configuration for GCR Canary alert ingest**
To be provided - Instructions for ingesting GCR Canary alerts are under development. The [screenshots](#screenshots) above provide a preview of what alerts look like in Apache Metron.

## How to test the software
To be provided - (Information on how to run automated tests on the software)

## Known issues
See this repository's issue tracker.

## GCR Canary Case
GCR is providing a custom designed case for the GCR Canary device, more details are available in this [repository](https://github.com/LTW-GCR-CSOC/canary-case).

## GCR CSOC Playbook
To be provided - Under development 

## Getting help
If you have questions, concerns, bug reports, etc, please file an issue in this repository's issue tracker.

## Getting involved
[CONTRIBUTING](CONTRIBUTING.md)

----

## Open source licensing info
Some components in GCR Canary are licensed under GPL [LICENSE](LICENSE).

Apache Metron is licensed under Apache v2.0 [LICENSE](https://github.com/apache/metron/blob/master/LICENSE).

## Related open source projects
 * [Apache Metron](http://http://metron.apache.org/)
 * [Dionaea](https://github.com/DinoTools/dionaea)
 * [Dionaea Log Viewer](https://github.com/mindphluxnet/cowrie-logviewer)
 * [Cowrie](https://github.com/micheloosterhof/cowrie)
 * [Cowrie Log Viewer](https://github.com/mindphluxnet/cowrie-logviewer)
 * [OSSEC](https://ossec.github.io/)
 * [OpenVAS](http://www.openvas.org/)
 * [Mender.io](http://mender.io)

## Credits and references
 * [Global Epic](http://globalepic.org)
 * [Lead to Win](http://leadtowin.ca)
 * [Ottawa - Cyber](http://lce.ltw-global.com)
 * [Hacker Alerting Service](http://globalcybersecurityresource.com)
 * [Carleton University TIM Program](http://timprogram.ca/)

## Contributors
 * [Daniel Craigen - GCR Project Leader](mailto:danielcraigen@cunet.carleton.ca)[, President of Global EPIC organization](http://globalepic.org)
 * [Brian Hurley - GCR CSOC Project Leader](https://www.linkedin.com/in/brianrhurley/)
 * [Ahmed Shah - Cybersecurity Analyst and Software Developer](mailto:ahmed.shah@carleton.ca)
 * [Eddie Villarta - CSOC Deployment and Operations](https://www.linkedin.com/in/eddievillarta/)
 * [Adefemi "Femi" Debo-Omidokun - CSOC Operations](https://www.linkedin.com/in/adefemi-debo-omidokun-bb19273/)
 * [Brandon Hurley - Cybersecurity Software Developer](http://brandonhurley.com)
 * [Mahmoud Gad - Cybersecurity Specialist](https://www.linkedin.com/in/mahmoudgad/)
