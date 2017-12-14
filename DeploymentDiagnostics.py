#!/usr/bin/env python3

import os
import socket
import urllib.request
from requests import get
#impoty re
import re
import subprocess
#import replace
macAddr = ""
ip="10.2.1.105"
#ip="0"
ether=""
nic=""

def removeListChars(inputString):
        inputString=inputString.replace("b'","")
        inputString=inputString.replace("'","")
        inputString=inputString.replace('"',"")
        inputString=inputString.replace("[","")
        inputString=inputString.replace("]","")
        inputString=inputString.replace("\\n","\n")
        return inputString


def portCheck(portNumber):
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(1)
        result = sock.connect_ex(('portquiz.net', int(portNumber)))
        #result = sock.connect_ex(('google.com',2202))
        if result == 0:
                print('port:\t\t' + str(portNumber) + ' PASS')
                returnVal = "PASS"
        else:
                print('port:\t\t' + str(portNumber) + '. FAIL')
                returnVal = "FAIL"
        return returnVal

cmdConstruction="arp -a " + ip + " "
cmdOutput = str(subprocess.check_output(cmdConstruction, shell=True))

hostname = str(subprocess.check_output('hostname', shell=True))
hostname=removeListChars(hostname)[:-1]

localIP= str(subprocess.check_output('hostname -I', shell=True))
localIP=removeListChars(localIP)[:-1]

ifconfigOutput= str(subprocess.check_output('ifconfig', shell=True))
ifconfigOutput=removeListChars(ifconfigOutput)

macAddr=str(re.findall(r'\w+\:\w+\:\w+\:\w+\:\w+\:\w+', str(ifconfigOutput)))
macAddr=removeListChars(macAddr)

ether=str(re.findall(r'\[.*\]', str(cmdOutput)))
ether=removeListChars(ether)

#nic=str(re.findall(r'on\s(.*)\\n', str(cmdOutput)))
#nic=removeListChars(nic)


nic=str(re.findall(r'^\S*', str(ifconfigOutput)))
nic=removeListChars(nic)


#macAddr2=re.findall(r'\w+\:w+\:w+\:w+\:w+\:w+', str(macAddr))


#print( os.system('arp -a ' + str("10.2.1.120")))
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)


#####

print ("Global Cybersecurity Resource, 2017")
print("_____/\\\\\\\\\\\\\\\\\\\\\\\\___________/\\\\\\\\\\\\\\\\\\_______/\\\\\\\\\\\\\\\\\\_____        ")
print(" ___/\\\\\\//////////_________/\\\\\\////////______/\\\\\\///////\\\\\\___       ")
print("  __/\\\\\\__________________/\\\\\\/______________\\/\\\\\\_____\\/\\\\\\___      ")
print("   _\\/\\\\\\____/\\\\\\\\\\\\\\_____/\\\\\\________________\\/\\\\\\\\\\\\\\\\\\\\\\/____     ")
print("    _\\/\\\\\\___\\/////\\\\\\____\\/\\\\\\________________\\/\\\\\\//////\\\\\\____    ")
print("     _\\/\\\\\\_______\\/\\\\\\____\\//\\\\\\_______________\\/\\\\\\____\\//\\\\\\___   ")
print("      _\\/\\\\\\_______\\/\\\\\\_____\\///\\\\\\_____________\\/\\\\\\_____\\//\\\\\\__  ")
print("       _\\//\\\\\\\\\\\\\\\\\\\\\\\\/________\\////\\\\\\\\\\\\\\\\\\____\\/\\\\\\______\\//\\\\\\_ ")
print("        __\\////////////_____________\\/////////_____\\///________\\///__")

print("#####################")
print("DEPLOYMENT DIAGNOSTIC")
print("#####################")

try:
    publicIP = get('https://api.ipify.org').text
    #s.connect(("8.8.8.8",80))
    #localIP=s.getscoketname()[0]
    #s.close()
    print("publicIP:\t" + publicIP[:-1])
except:
    print("Not able to access internet")
    publicIP = "FAIL"


print("mac address:\t"+ macAddr)
#print("ether:\t\t"+ ether )
print("nic:\t\t" + nic )
print("local ip:\t" + localIP)
print("hostname:\t" + hostname )
print("public ip:\t" + publicIP)
print("---------------------------------------------")
print(ifconfigOutput[:-1][:-1])
print("---------------------------------------------")
print("Port checking. \n If any port fails the port\n might need to be opened at the company firewall")
print("---------------------------------------------")
portCheck(8080)
portCheck(8089)
portCheck(2202)
portCheck(22)
input("Press Enter to continue ... ")
