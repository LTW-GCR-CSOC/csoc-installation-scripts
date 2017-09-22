![Global Cybersecurity Resource](https://github.com/LTW-GCR-CSOC/csoc-installation-scripts/edit/master/githubGCRheader.png "Global Cybersecurity Resource")
![ScreenShot](https://github.com/LTW-GCR-CSOC/csoc-installation-scripts/edit/master/githubGCRheader.png)
![alt tag](https://github.com/LTW-GCR-CSOC/csoc-installation-scripts/edit/master/githubGCRheader.png "Description goes here")
<img src="https://github.com/LTW-GCR-CSOC/csoc-installation-scripts/edit/master/githubGCRheader.png" />
# LTW GCR Cybersecurity Operations Center Project

  * [Description](#description)
  * [Screenshots](#screenshots)
  * [Dependencies](#dependencies)
  * [Installation](#installation)
    + [Apache Metron](#apache-metron)
    + [LTW GCR Canary](#ltw-gcr-canary)
  * [Configuration](#configuration)
  * [Usage](#usage)
  * [How to test the software](#how-to-test-the-software)
  * [Known issues](#known-issues)
  * [Getting help](#getting-help)
  * [Getting involved](#getting-involved)
  * [Open source licensing info](#open-source-licensing-info)
  * [Related open source projects](#related-open-source-projects)
  * [Credits and references](#credits-and-references)
  * [Contributors](#contributors)

## Description 

This GCR open source project is focused on delivering an easy to deploy open source cybersecurity monitoring solution for small to medium enterprises.  

The project goal is a push-button install of the platform software necessary to support a professional-level Cybersecurity Operations Center (CSOC) solution suitable for use by managed service providers focused on small businesses, or medium sized enterprise IT departments.

The project assets will include: software, documentation, and training materials.

The software will configure, integrate and enhance existing open source software cybersecurity projects, including: Apache Metron, Dionaea, Cowrie, OSSEC and others.   

Integration of cybersecurity sensors is a priority for the project to reduce labour and complexity associated with deploying open source security operations center solutions.  The project includes a remotely managed honeypot device (LTW GCR Canary) that is suitable for use as a sensor for passive intrusion detection in SME environments.
 
The project will include CSOC Operational Playbook templates suitable for use by manager service providers or IT department staff responsible for operating the CSOC.  

Online training materials will be provided for SME employees to help address employee security awareness. 

The project is currently in progress and available at https://github.com/LTW-GCR-CSOC

## Screenshots  

To be provided

## Dependencies

To be provided

## Installation

### Apache Metron 

To be provided

### LTW GCR Canary 

The installation has been tested on Ubuntu Mate LTS 16.04 with Raspberry Pi 3.

It is currently under active development and testing.

To install all of the LTW GCR Canary software, run the following script:

```
wget https://github.com/LTW-GCR-CSOC/csoc-installation-scripts/archive/master.zip && \
unzip master.zip && \
cd csoc-installation-scripts-master/ && \
chmod +x *.sh && \
./honeypots.sh
```
Dionaea logs and database will be in this directory /opt/dionaea/var/dionaea
      
To view the Cowrie Logs, visit http://0.0.0.0:5000 

To view the Dionaea Logs, visit http://0.0.0.0:8000

## Configuration

To be provided - information on configurable items related to the software.

## Usage

To be provided - show users how to use the software.

## How to test the software

To be provided - information on how to run automated tests on the software.

## Known issues

Currently under active development, see this repository's Issue Tracker.

## Getting help

If you have questions, concerns, bug reports, etc, please file an issue in this repository's Issue Tracker.

## Getting involved

[CONTRIBUTING](CONTRIBUTING.md)

----

## Open source licensing info
 * [LICENSE](LICENSE)

## Related open source projects
 * [Apache Metron]
 * [Dionaea]
 * [Dionaea Log Viewer]
 * [Cowrie]
 * [Cowrie Log Viewer]
 * [OSSEC]
 * [OpenVAS]
 * [Mender.io](http://mender.io)

## Credits and references
 * [Global Epic](http://globalepic.org)
 * [Lead to Win](http://leadtowin.ca)
 * [Lead to Win - Cyber](http://lce.ltw-global.com)
 * [Hacker Alerting Service](http://globalcybersecurityresource.com)
 * [Carleton University TIM Program](http://http://timprogram.ca/)

## Contributors
 * [Daniel Craigen - GCR Project Leader](mailto:danielcraigen@cunet.carleton.ca) 
 * [Brian Hurley - GCR CSOC Project Leader](https://www.linkedin.com/in/brianrhurley/)
 * [Ahmed Shah - Cybersecurity Analyst and Software Developer](mailto:ahmed.shah@carleton.ca)
 * [Naveen Narayanasamy - Cybersecurity Software Developer](mailto:naveennarayanasamy@cmail.carleton.ca) 
 * [Frank Horsfall - Cybersecurity Architecture](mailto:frankhorsfall@cunet.carleton.ca) 
 * [Adefemi "Femi" Debo-Omidokun - CSOC Operations](https://www.linkedin.com/in/adefemi-debo-omidokun-bb19273/)
 * [Anthony Ani - CSOC SME Customer Engagement]
 * [Alexis Amoi - CSOC Partner Engagement]
 * [Tommy Nguyen]
 * [Mahmoud Gad]


