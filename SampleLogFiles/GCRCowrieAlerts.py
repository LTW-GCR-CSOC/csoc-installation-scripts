# -*- coding: utf-8 -*-
#Global Cybersecurity Resource, 2018
#
#This file monitors the /log/ folder (/home/cowrie/cowrie/log) to see if any new events are generated.
#Parses events in cowrie.json file and saves them in /var/log/GCRCowrie.log 
#watchdog code adapted from michaelcho.me

#This file requires watchdog. Use the following command to download watchdog
#sudo pip3 install watchdog

#To run this script in the background 
#sudo python3 /home/cowrie/cowrie/bin/GCRCowrieAlerts.py > /dev/null &

#!/usr/bin/env python
import time
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import json
from datetime import datetime
import calendar
import syslog
import re
import subprocess


class Watcher:
    DIRECTORY_TO_WATCH = "/home/cowrie/cowrie/log/"

    def __init__(self):
        self.observer = Observer()

    def run(self):
        event_handler = Handler()
        self.observer.schedule(event_handler, self.DIRECTORY_TO_WATCH, recursive=True)
        self.observer.start()
        try:
            while True:
                time.sleep(5)
        except:
            self.observer.stop()
            print("Error")

        self.observer.join()

class Filter:
    @staticmethod
    def removeListChars(inputString):
         inputString=str(inputString.replace('[',""))
         inputString=inputString.replace(']',"")
         inputString= inputString.replace('"'," ")
         inputString= inputString.replace("'"," ")
         inputString= inputString.replace("`"," ")
         inputString= inputString.replace("|"," ")
         inputString= inputString.replace("\n"," ")
         inputString= inputString.replace("\t"," ")
         inputString= inputString.replace("\f"," ")
         inputString= inputString.replace("\r"," ")
         inputString= inputString.replace("\v"," ")
         inputString= inputString.replace("\v"," ")
         inputString= inputString.replace("\a"," ")
         return inputString

class Find:

    @staticmethod
    def macAddress(localIPaddress):
        filter = Filter()
        macAddr=""
        ip=localIPaddress
        ether=""
        nic=""
        returnVal = ""

         #ToDo Check mac vendor
         #grep <first three chars. i.e. 080069> -i /usr/share/nmap/nmap-mac-prefixes
        cmdConstruction ="arp -a " + ip + " "

        try:
            cmdOutput = subprocess.check_output(cmdConstruction, shell=True)
        except:
            cmdOutput = ""
            print("MAC address not found")

        macAddr=str(re.findall(r'\w+\:\w+\:\w+\:\w+\:\w+\:\w+', str(cmdOutput)))
        ether=str(re.findall(r'\[.*\]', str(cmdOutput)))
        ether=filter.removeListChars(ether)
        nic=str(re.findall(r'on\s(.*)\\n', str(cmdOutput)))
        nic=filter.removeListChars(nic)
        macAddr=filter.removeListChars(macAddr)
        returnVal = macAddr
        return returnVal
    
    @staticmethod
    def macVendor(fullMacAddress):
        if (fullMacAddress != ""):
            parsedMacAddress=fullMacAddress
            parsedMacAddress=str(parsedMacAddress.replace(":",""))
            #grep <first six chars. i.e. 080069> -i /usr/share/nmap/nmap-mac-prefixes
            print(parsedMacAddress[1:7])
            cmdConstruction ="grep " + parsedMacAddress[1:7] + " -i /usr/share/nmap/nmap-mac-prefixes"
            try: 

                cmdOutput = str(subprocess.check_output(cmdConstruction, shell=True))

            except subprocess.CalledProcessError as e:

               cmdOutput = ""
 
            if not cmdOutput:
                 cmdOutput = ""
            else:

                 cmdOutput = cmdOutput[2:]
                 cmdOutput = cmdOutput[:-3]
        else:
            cmdOutput =""
        return str(cmdOutput)


class Cowrie:

    @staticmethod
    def cowrieconnect(eventPath):
        if (str(eventPath)[-5:] == ".json"):
            with open('/home/cowrie/cowrie/log/cowrie.json') as file:
                read_from_file = file.readlines()[-3:-2]
                new_alert = json.loads(read_from_file[0])
                eventtype = new_alert['eventid']
                if (eventtype == "cowrie.session.connect"):
                    sourceip = new_alert['src_ip']
                    find = Find()
                    macAddress = find.macAddress( sourceip )
                    print(macAddress)
                    macVendor = find.macVendor( macAddress )
                    print(macVendor)
                    sourceport = new_alert['src_port']                    
                    hostname = new_alert['sensor']
                    destinationip = new_alert['dst_ip']
                    destinationport = new_alert['dst_port']
                    payload = str(new_alert).replace("}u{","")  
                    payload += "MACADDRESS: " + macAddress
                    payload += "VENDOR: " + macVendor 
                    d = datetime.utcnow()
                    timestamp=calendar.timegm(d.utctimetuple())
                    alert = str(timestamp) + ".000|" + "GCRCanary-Device|" + \
                    hostname + "|" + "CowrieConnection(NoLoginAttempt)|" + "0" + "|" + str(destinationip) + "|" + str(destinationport) + "|" + str(sourceip) + "|" + str(sourceport) + "|" + str(payload) + "|"
                    print(alert)
                    file = open("/var/log/GCRCowrie.log", "a+")
                    syslog.syslog(alert)
                    file.write(alert+"\n")
                    file.close()
                    return None


    @staticmethod
    def generateAlert(eventPath):
        if (str(eventPath)[-5:] == ".json"):
                with open('/home/cowrie/cowrie/log/cowrie.json') as file:
                    read_from_file = file.readlines()[-1:]
                    new_alert = json.loads(read_from_file[0])
                    eventtype = new_alert['eventid']
                    if ((eventtype == "cowrie.login.success") or (eventtype == "cowrie.login.failed")):
                        message = new_alert['message']
                        sourceip = new_alert['src_ip']
                        find = Find()
                        macAddress = find.macAddress( sourceip )
                        print(macAddress)
                        macVendor = find.macVendor( macAddress )
                        print(macVendor)
                        hostname = new_alert['sensor']
                        payload = str(new_alert).replace("}u{","")  
                        payload += "MACADDRESS: "+ macAddress
                        payload += "VENDOR: "+ macVendor
                        d = datetime.utcnow()
                        timestamp=calendar.timegm(d.utctimetuple())
                        alert = str(timestamp) + ".000|" + "GCRCanary-Device|" + \
                            hostname + "|" + "CowrieConnection(" + message + ")|" + "0" + "|" + "0.0.0.0" + "|" + "0" + "|" + str(sourceip) + "|" + "0" + "|" + str(payload) + "|"
                        print(alert)
                        file = open("/var/log/GCRCowrie.log", "a+")
                        syslog.syslog(alert)
                        file.write(alert+"\n")
                        file.close()
                        return None

class Handler(FileSystemEventHandler):

    @staticmethod
    def on_any_event(event):
        if event.is_directory:
            return None

        elif event.event_type == 'created':
            # Take any action here when a file is first created.
            print("Received created event - %s." % event.src_path)
            eventPath = str(event.src_path)
            cowrie=Cowrie()
            cowrie.cowrieconnect(eventPath)
            cowrie.generateAlert(eventPath)
           
        elif event.event_type == 'modified':
        #     #event.event_typ
        #     # Taken any action here when a file is modified.
            print("Received modified event - %s." % event.src_path)
            eventPath = str(event.src_path)
            cowrie=Cowrie()
            cowrie.cowrieconnect(eventPath)
            cowrie.generateAlert(eventPath)
           

if __name__ == '__main__':
    w = Watcher()
    w.run()

