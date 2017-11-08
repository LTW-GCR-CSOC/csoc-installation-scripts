# OpenVAS Installer
A small script that automates the install process for OpenVAS. Uses LTW-GCR-CSOC's fork of [openvas-commander](https://github.com/LTW-GCR-CSOC/openvas-commander).

## How to use
The following was tested on a [Raspberry Pi 3](https://www.raspberrypi.org) with [Ubuntu MATE](https://ubuntu-mate.org/) 16.04.2 for Raspberry Pi and a [VMWare Fusion](https://www.vmware.com/products/fusion.html) 8.5.8 virtual machine with Ubuntu MATE 16.04.2 LTS for 64-bit systems, a 2.0 GHz quad core and 4 GB of RAM. Both test machines had 32 GB of disk space and were installing OpenVAS 9.

The install process took around 1-3 hours on the VM instance, while the Raspberry Pi 3 took around 4-6 hours.

Before installing, make sure that all the latest updates have been installed.

***Installation commands***
```
wget https://raw.githubusercontent.com/LTW-GCR-CSOC/csoc-installation-scripts/master/openvas/openvasinstall.sh
chmod +x openvasinstall.sh
sudo ./openvasinstall.sh
```

## Tests to run
To confirm that OpenVAS is installed properly, perform the following tests in the order they are listed:

***Use OpenVAS's official install check tool***
```
sudo ./openvas_commander.sh --check-status v9
```
The tool should report back that the install looks OK. Otherwise, it will state that the install is not complete, what the problem component is, and how to generally fix it.

***Check that the service is running post-install***
```
sudo systemctl status openvas
```
The service and its components (openvasmd, openvassd, and gsad) should be currently running. Use ```:q``` to exit the status report.

***Check that the web interface can be accessed***

Open a web browser and go to localhost (use either ```localhost``` or ```127.0.0.1```). The security warning thrown by the browser can be ignored. If the service is running, the login screen will be visible.

***Check that a basic scan can be done***

* Login to the web interface. The default user/password combo is ```admin/1```
* Once logged in, go to ```Scans -> Tasks```, hover over the star icon at the upper left corner of the page (to the right of the wand icon), and select "New Task".
* A New Task popup will appear with various options to modify. Change the following settings:
  * Name: Localhost Test Scan
  * Scan Target:
    * A new Scan Target needs to be created. Click on the star icon next to the Scan Target field and a popup for a New Target will appear.
    * By default, it's already set to localhost, so just set the name to "Localhost" and create the target.
  * Maximum concurrently executed NVTs per host (for Raspberry Pi only): 2
  * Maximum concurrently scanned hosts (for Raspberry Pi only): 2
* Once all the specified fields are filled in, create the task
* The new task will appear in the list under the graphs. Press the Start icon (green triangle) in the Actions column to start the task.
* Make sure that the page is set to auto-refresh at some interval (top-right corner).
* The task will take around an hour to complete. It will be complete when the status column says "Done".

***Check that the service can stop***
```
sudo systemctl stop openvas
sudo systemctl status openvas
```
The service and its components (openvasmd, openvassd, and gsad) should be not currently running. Use ```:q``` to exit the status report.

***Check that the service can start and run after being stopped***

```
sudo systemctl start openvas
sudo systemctl status openvas
```
The service and its components (openvasmd, openvassd, and gsad) should be currently running and getting ready for use. Use ```:q``` to exit the status report.
Wait 5 minutes to allow the scanner component to rebuild its NVTs. After that, log back into the web interface and start the task again. The task should be able to complete without issue.

***Check that the service can start and run after a system restart***

Restart the machine and log back in. Wait 5 minutes to allow the scanner component to rebuild its NVTs. Afterwards, run:

```
sudo systemctl status openvas
```
The service and its components (openvasmd, openvassd, and gsad) should be currently running and getting ready for use. Use ```:q``` to exit the status report.

Finally, log back into the web interface and start the task again. The task should be able to complete without issue.
