# -*- coding: utf-8 -*-
#Global Cybersecurity Resource, 2017
#
#This file monitors the /bistream/ folder (/opt/dionaea/var/dionaea/bistreams/) to see if any new events are generated (some events might not appear in the dionaea sql lite database). The content of the bistream file can give addtional context into an alert.
#This file requires watchdog. Use the following command to download watchdog
#sudo pip3 install watchdog

#To Do get private ip, public ip, and hostname only once instead of every time handler is called. 

import time
import os
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import re
import syslog
import time
import datetime
import socket
import subprocess
from requests import get



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
            print(parsedMacAddress[0:6])
            cmdConstruction ="grep " + parsedMacAddress[0:6] + " -i /usr/share/nmap/nmap-mac-prefixes"
            cmdOutput = str(subprocess.check_output(cmdConstruction, shell=True))
            cmdOutput = cmdOutput[2:]
            cmdOutput = cmdOutput[:-3]
         else:
            cmdOutput =""
         return str(cmdOutput)

    @staticmethod
    def hostname():
         hostname =socket.gethostname()
         s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
         return hostname

    @staticmethod
    def localIP():
         s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
         try:
              s.connect(("8.8.8.8",80))
              localIP=s.getsockname()[0]
              s.close()
         except:
              print("Not able to find local ip address")
              localIP="0.0.0.0"
         return localIP

    @staticmethod
    def publicIP():
         try:
              publicIP = get('https://api.ipify.org').text
         except:
              print("1not able to access internet")
              publicIP="0.0.0.0"
         return publicIP

#watchdog code adapted from michaelcho.me
class Watcher:
    #DIRECTORY_TO_WATCH = "/opt/dionaea/var/dionaea/bistreams/2017-11-28"
    DIRECTORY_TO_WATCH = "/opt/dionaea/var/dionaea/bistreams"
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
            print( "Error")
        self.observer.join()

#watchdog code adapted from michaelcho.me
class Handler(FileSystemEventHandler):
    hostname = ""
    localIPaddress = ""
    publicIPaddress = ""
    #filter = Filter()
    @staticmethod
    def SetHostname(hostname1):
        hostname = hostname1
    @staticmethod
    def SetLocalIPaddress(localipaddress1):
        localIPaddress = localipaddress1
    @staticmethod
    def SetPublicIPaddress(publicipaddress1):
        publicIPaddress = publicipaddress1
    @staticmethod
    def on_any_event(event):
        filter = Filter()
        if event.is_directory:
            return None
        elif event.event_type == 'created':
            # Take any action here when a file is first created.
            print( "Received created event - %s" % event.src_path)
        elif event.event_type == 'modified':
            # Taken any action here when a file is modified.
            print( "Received MODIFIED event - %s" % event.src_path)
            eventPath = str(event.src_path)
            if (str(eventPath)[-3:] != "swp") and ( str(eventPath)[-1:] !="~"):
                 f = open((event.src_path), "r")
                 content = f.read()
            else:
                 content = ""
            eventPath=str(eventPath)
            print("eventpath->"+str(eventPath)[-3:]+"<-")
            fileName = re.findall(r'((?:[^/]*/)*)(.*)',eventPath)
            fileName = os.path.basename(eventPath)
            fileName = str(fileName)
            try:
                 service = re.findall(r'^(.*?)\-',fileName)[0]
                 service = re.findall(r'^(.*?)\-',fileName)[0]
                 port = re.findall(r'\-(.*?)\-',fileName)[0]
                 ip = re.findall(r'\-.*\-(.*?)\-',fileName)[0]
                 id = re.findall(r'\-.*\-.*\-(.*?)$',fileName)[0]
            except:
                 service="NotDionaeaFile"
                 port = "0"
                 ip = "0.0.0.0"
                 id = "0"
            print("service->"+service+"<-")
            print("port->"+port+"<-")
            print("ip->"+ip+"<-")
            print("id->"+id+"<-")
            print("servName->" + service +"<-")
            print("fileName->"+ fileName +"<-")
            if (str(eventPath)[-3:] !="swp") and ( str(eventPath)[-1:] !="~"):
                 print("f.read->" + f.read() + "<-")
            else:
                content=""
            timeOfAlert=""
            timeOfAlert=int(str(datetime.datetime.now().timestamp() * 1000)[0:10])
            s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            try:
                 s.connect(("8.8.8.8",80))
                 hostname =socket.gethostname()
                 localIP=s.getsockname()[0]
                 s.close()
            except:
                 print("not able to access internet")
                 localIP="0.0.0.0"
            macAddress = find.macAddress( ip )
            macVendor = find.macVendor( macAddress )
            #contentStr=f.read()
            print("++>" + content + "<++")
            compareSrcDst = "0"
            if ( str(ip) == str(localIP) ) :
                 compareSrcDst = "1"
            else:
                 compareSrcDst = "0"
            if (str(eventPath)[-3:] !="swp") and ( str(eventPath)[-1:] !="~"):
                 content = "[[[ CONTENT: [cmp ip_dst_addr & ip_src_addr: " + compareSrcDst + "],[file:("+eventPath+")], [ip_src_addr details: (MAC:" + macAddress + "), (VENDOR: "+ macVendor +")], [ " + filter.removeListChars(content) + "] ]]]"
                 alert =  str(int(timeOfAlert))+".000|"+"GCRCanary-Device|"+ hostname +"|"+ "Dionaea-BIStream("+service+")|"+"0"+"|"+str(localIP)+"|"+port+"|"+str(ip)+"|"+"0"+"|"+ content  +"|\n"
                 syslog.syslog(alert)

if __name__ == '__main__':
    find = Find()
    #hostname = find.hostname()
    #print(hostname)
    #localIPaddress = find.localIP()
    #print(localIPaddress)
    #publicIPaddress = find.publicIP()
    #print(publicIPaddress)
    #macAddress = find.macAddress("172.217.0.110")
    #print(macAddress)
    #macVendor = find.macVendor(macAddress)
    #print(macVendor)
    w = Watcher()
    w.run()
