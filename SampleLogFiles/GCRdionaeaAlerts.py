# -*- coding: utf-8 -*-
#Global Cybersecurity Resource, 2017
#
#This will extract information from dionaea.sqlite and put the information into a log file.
#This file should reside in the honeypot under the following directory.
#/opt/dionaea/
#The script can be executed with the following command:
#sudo python3 /opt/dionaea/GCRdionaeaAlerts.py
#
#or to run in the background use the following:
#sudo python3 /opt/dionaea/GCRdionaeaAlerts.py > /dev/null &

from requests import get
import socket
import os
import syslog
import sqlite3
import sys
import time
import urllib.request
import datetime
import psutil
import schedule
import re
from requests import get
#from datetime import datetime, timedelta
from pathlib import Path

import subprocess

def removeListChars(inputString):
     inputString=inputString.replace("'","")
     inputString=inputString.replace('"',"")
     inputString=inputString.replace('[',"")
     inputString=inputString.replace(']',"")     
     returnVal2 = inputString
     return returnVal2


def macChecker(ipaddress):
     macAddr=""
     ip=ipaddress
     ether=""
     nic=""
     returnVal = ""
     
     #ToDo Check mac vendor
     #grep <first three chars. i.e. 080069> -i /usr/share/nmap/nmap-mac-prefixes
     
     cmdConstruction ="arp -a " + ip + " "
     cmdOutput = subprocess.check_output(cmdConstruction, shell=True)
     macAddr=str(re.findall(r'\w+\:\w+\:\w+\:\w+\:\w+\:\w+', str(cmdOutput)))
     macAddr=removeListChars(macAddr)
     ether=str(re.findall(r'\[.*\]', str(cmdOutput)))
     ether=removeListChars(ether)
     
     nic=str(re.findall(r'on\s(.*)\\n', str(cmdOutput)))
     nic=removeListChars(nic)

     #returnVal = " " + macAddr + " " + ether + " " + nic + " "
     returnVal = " " + macAddr +  " "
     return returnVal

#this function collects the bistreams content of the previous day
def collectBistreamsPreviousDay(hostname):
     d = datetime.datetime.today() - datetime.timedelta(days=1)
     previousDayPath = "/opt/dionaea/var/dionaea/bistreams/" + d.strftime("%Y-%m-%d")
     pathCheck = Path(previousDayPath)
     mstrPayload=""
     payloadBistreams=""
     
     if pathCheck.is_dir():
        if os.listdir(previousDayPath) !=[]:
          pathContent = os.listdir(previousDayPath)
          #print(str(len(pathContent)))
          mstrPayload=""
       
          for x in range (0, len(pathContent) ):
               subFile = previousDayPath +"/"+ pathContent[x]
               mstrPayload=mstrPayload + " CONTENT: [[[" + subFile + "]]],[[["
               f = open(subFile, "r")
               mstrPayload=mstrPayload+f.read()
               mstrPayload=mstrPayload+" ]]]"
               #mstrPayload=re.sub(r'[^\x00\x7F]+',' ',mstrPayload)
               mstrPayload= mstrPayload.replace('"'," ")
               mstrPayload= mstrPayload.replace("'"," ")
               mstrPayload= mstrPayload.replace("`"," ")
               mstrPayload= mstrPayload.replace("|"," ")
               mstrPayload= mstrPayload.replace("\n"," ")

          #print("path content" , pathContent , " previousDayPath " ,  previousDayPath )
          #print(mstrPayload)
     else:
         payloadBistreams="no files for" + previousDayPath
         mstrPayload=payloadBistreams
     return mstrPayload

#this function will capture systemstatus and send message on the system status
def checkSystemStatus(hostname):
        outMessage=""
        publicIP=0
        localIP=0
        dionaeaHTTPcheck=0
        machineStatusOut=""
        timeOfAlert=""
        mstrPayload=""
        mstrPayload=collectBistreamsPreviousDay(hostname)

        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        try:
                        publicIP = get('https://api.ipify.org').text
                        s.connect(("8.8.8.8",80))
                        localIP=s.getsockname()[0]
                        s.close()
        except:
                        print("Not able to access internet" )

        if (publicIP != 0):
                        try:
                                        req = urllib.request.Request('http://'+localIP)
                                        f = urllib.request.urlopen(req)
                                        dionaeaHTTPcheck=1
                        except:
                                        print("WARNING: Dionaea might not be running")
                                        dionaeaHTTPcheck=0
        else:
                        localIP="0.0.0.0"
                        publicIP="0.0.0.0"

        p = psutil.Process(1)
        cpuCount = psutil.cpu_count()
        timeOfAlert=int(str(datetime.datetime.now().timestamp() * 1000)[0:10] )
        machineStatusOut=machineStatusOut+"TIME OF ALERT:"+str(datetime.datetime.utcfromtimestamp(int(timeOfAlert)).strftime('%Y-%m-%d %H:%M:%S'))
        machineStatusOut=machineStatusOut+"    PROCESS 1 START TIME:"+str(datetime.datetime.fromtimestamp(int(p.create_time())).strftime('%Y-%m-%d %H:%M:%S'))
        machineStatusOut=machineStatusOut+"    CPU COUNT("+str(cpuCount)+") % usage:"
        for x in range(cpuCount):
                        machineStatusOut=machineStatusOut+"CPU"+str(x+1)+"("+str(psutil.cpu_percent(interval=1))+") "
        machineStatusOut=machineStatusOut+"    VIRT_MEMORY:"+str(psutil.virtual_memory())
        machineStatusOut=machineStatusOut+"    DISK_USAGE:"+str(psutil.disk_usage('/'))
        machineStatusOut=machineStatusOut+"    PUBLIC_IP("+str(publicIP)+")    LOCAL_IP("+str(localIP)+")"
        machineStatusOut=machineStatusOut+"    DIONAEA_HTTP_CHECK:"+str(dionaeaHTTPcheck)

        alert =  str(int(timeOfAlert))+".000|"+"GCRCanary-Device|"+ hostname +"|"+ "HeartBeat|"+"0"+"|"+str(publicIP)+"|"+"0"+"|"+str(localIP)+"|"+"0"+"|"+machineStatusOut + "-----" + mstrPayload +"|\n"
        print(alert)
        file = open("/var/log/GCRDionaea.log", "a+")
        syslog.syslog(alert)
        file.write(alert)
        file.close()
        return machineStatusOut



#this function will extract details from dionaea sqlite3 tables based on the connectionID
def payloadDetailsConstructor(cur,table):
        msgPayload = ""
        header=""
        colnames = cur.description
        for row in colnames:
                header=header+row[0]+"\,"
        element=""
        details = cur.fetchall()
        subDetails=""
        for detail in details:
                for de in detail:
                        dx=de
                        print (str(de))
                        element=element+str(dx)+","
                if table == "mysql_commands":
                        curx=cur
                        mysql_command = details[0][0]
                        mysql_command_cmd = details[0][2]
                        sqlx = "SELECT * FROM mysql_command_args WHERE mysql_command=" + str(mysql_command) + ";"
                        curx.execute(sqlx)
                        subDetails = payloadDetailsConstructor(curx,"mysql_command_args")
                        element=element+subDetails
                        sqlx = "SELECT * FROM mysql_command_ops WHERE mysql_command_cmd=" + str(mysql_command_cmd) + ";"
                        curx.execute(sqlx)
                        subDetails = payloadDetailsConstructor(curx,"mysql_command_ops")
                        element=element+subDetails
                elif table == "dcerpcbinds":
                        curx=cur
                        dcerpcbind_uuid = details[0][2]
                        sqlx = "SELECT * FROM dcerpcservices WHERE dcerpcservice_uuid='" + str(dcerpcbind_uuid) + "';"
                        curx.execute(sqlx)
                        subDetails = payloadDetailsConstructor(curx,"dcerpcservices")
                        element=element+subDetails
                elif table == "dcerpcrequests":
                        curx=cur
                        dcerpcrequest_uuid = details[0][2]
                        sqlx = "SELECT * FROM dcerpcservices WHERE dcerpcservice_uuid='" + str(dcerpcrequest_uuid) + "';"
                        curx.execute(sqlx)
                        subDetails = payloadDetailsConstructor(curx,"dcerpcservices")
                        element=element+subDetails
                elif table == "sip_commands":
                        curx=cur
                        sip_command = details[0][0]
                        sqlx = "SELECT * FROM sip_addrs WHERE sip_command=" + str(sip_command) + ";"
                        curx.execute(sqlx)
                        subDetails = payloadDetailsConstructor(curx,"sip_addrs")
                        element=element+subDetails
                        curx=cur
                        sqlx = "SELECT * FROM sip_sdp_connectiondatas WHERE sip_command=" + str(sip_command) + ";"
                        curx.execute(sqlx)
                        subDetails = payloadDetailsConstructor(curx,"sip_sdp_connectiondatas")
                        element=element+subDetails
                        curx=cur
                        sqlx = "SELECT * FROM sip_sdp_medias WHERE sip_command=" + str(sip_command) + ";"
                        curx.execute(sqlx)
                        subDetails = payloadDetailsConstructor(curx,"sip_sdp_medias")
                        element=element+subDetails
                        curx=cur
                        sqlx = "SELECT * FROM sip_sdp_origins WHERE sip_command=" + str(sip_command) + ";"
                        curx.execute(sqlx)
                        subDetails = payloadDetailsConstructor(curx,"sip_vias")
                        element=element+subDetails
                element=element+", "
                msgPayload = msgPayload + "["+table.upper()+":("+ header + ")(" +element[:-3] +")]"
        return msgPayload;

###############
##Initalization
###############

print ("Global Cybersecurity Resource, 2017 \n GCRDionaea Alerts\n Initalization Started\n")
print("_____/\\\\\\\\\\\\\\\\\\\\\\\\___________/\\\\\\\\\\\\\\\\\\_______/\\\\\\\\\\\\\\\\\\_____        ")
print(" ___/\\\\\\//////////_________/\\\\\\////////______/\\\\\\///////\\\\\\___       ")
print("  __/\\\\\\__________________/\\\\\\/______________\\/\\\\\\_____\\/\\\\\\___      ")
print("   _\\/\\\\\\____/\\\\\\\\\\\\\\_____/\\\\\\________________\\/\\\\\\\\\\\\\\\\\\\\\\/____     ")
print("    _\\/\\\\\\___\\/////\\\\\\____\\/\\\\\\________________\\/\\\\\\//////\\\\\\____    ")
print("     _\\/\\\\\\_______\\/\\\\\\____\\//\\\\\\_______________\\/\\\\\\____\\//\\\\\\___   ")
print("      _\\/\\\\\\_______\\/\\\\\\_____\\///\\\\\\_____________\\/\\\\\\_____\\//\\\\\\__  ")
print("       _\\//\\\\\\\\\\\\\\\\\\\\\\\\/________\\////\\\\\\\\\\\\\\\\\\____\\/\\\\\\______\\//\\\\\\_ ")
print("        __\\////////////_____________\\/////////_____\\///________\\///__")

pastConnectionID=0
delay=10
#scheduledTimeToCheckStatus="13:00"

startH = 13
startM = 10
start_time = "{0:02d}:{1:02d}".format(startH, startM)

#get hostname
hostname = socket.gethostname()

dionaeaDatabaseFile = "/opt/dionaea/var/dionaea/dionaea.sqlite"

print("Waiting for dionaea.sqlite to exist. Please wait. Dionaea might not have been initialized for the first time")
ifFileExists = False
while ifFileExists is False:
        ifFileExists = os.path.exists(dionaeaDatabaseFile)
        if ifFileExists == True:
                break

print("dionaea.sqlite exists. Checking file size")
checkSystemStatus(hostname)

fileSizeCheck = os.stat(dionaeaDatabaseFile)
if int(str(fileSizeCheck.st_size)) == 0:
        print ("ERROR: dionaea.sqlite is not populated. dionaea possibly not init. properly. Issue might be due to dionaea not givin permissions to write to file or multiple pids of .//dionaea are running. Ending program")
        sys.exit()

#schedule.every().day.at(scheduledTimeToCheckStatus).do(checkSystemStatus,hostname)
schedule.every().day.at(start_time).do(checkSystemStatus,hostname)
#schedule.every().day.do(checkSystemStatus,hostname)

cur = sqlite3.connect(dionaeaDatabaseFile).cursor()

#list of all tables in database
sql="SELECT name FROM sqlite_master WHERE type = 'table'"
cur.execute(sql)
tables = cur.fetchall()
tablesWithConnection=[]

#find tables that only have the connection column and create a list of tables with only connection
for table in tables:
    sql = "PRAGMA table_info('"+ table[0] +"');"
    cur.execute(sql)
    columns = cur.fetchall()
    for column in columns:
        if (column[1]) == 'connection':
            #create new list of tables that have connections
            tablesWithConnection.append(table[0])

#get last connection
sql = "SELECT connection,connection_type,connection_transport,connection_protocol,connection_timestamp,local_host,local_port,remote_host,remote_port FROM connections ORDER BY connection DESC LIMIT 1;"
cur.execute(sql)
connectionMetaData = cur.fetchall()
pastConnectionID=connectionMetaData[0][0]

cur.close
###############
##Live Execution
###############


print ("Live Execution Started - Refresh Cycle: "+str(delay)+" \n")

while True:
        #when scheduled time occurs send system status
        schedule.run_pending()

        cur = sqlite3.connect(dionaeaDatabaseFile).cursor()
        #get lastest connection data
        sql = "SELECT connection,connection_type,connection_transport,connection_protocol,connection_timestamp,local_host,local_port,remote_host,remote_port FROM connections WHERE connection > "+ str(pastConnectionID) +" ORDER BY connection ASC;"
        cur.execute(sql)
        lastAlertEntries = cur.fetchall()

        for connectionItem in lastAlertEntries:
                connectionMetaData =  connectionItem
                connectionID = connectionItem[0]

                if int(connectionID) > int(pastConnectionID):
                        pastConnectionID=connectionID
                        msgAlertsTriggered=""
                        msgPayload = ""
                        msgPayload = "[ip_src_addr DETAILS" + macChecker(str(connectionMetaData[7])) + "]"
                        for tableWithConnection in tablesWithConnection:
                                #for number of tables, check if a connectionID exists
                                sql = "SELECT EXISTS(SELECT 1 FROM "+ tableWithConnection +" WHERE connection=" + str(connectionID) + " LIMIT 1);"
                                while True:
                                        try:
                                                cur.execute(sql)
                                                break
                                        except:
                                                print ("EXCEPTION - pausing")
                                                time.sleep(1)
                                                cur.execute(sql)
                                                pass
                                data = cur.fetchone()
                                connectionFlag=False
                                if str(data[0]) == "1":
                                        connectionFlag=True
                                        msgAlertsTriggered=tableWithConnection+","+msgAlertsTriggered
                                        sql = "SELECT * FROM "+ tableWithConnection + " WHERE connection=" + str(connectionID) + ";"
                                        cur.execute(sql)
                                        msgPayload=msgPayload+payloadDetailsConstructor(cur,tableWithConnection)
                                        msgPayload=msgPayload.replace("|"," ")
                                        msgPayload=msgPayload.replace("\n"," ")
                                        msgPayload=msgPayload.replace("\r"," ")
                        alert =  str(int(connectionMetaData[4]))+".000|"+"GCRCanary-Device|"+ hostname +"|"+ "Dionaea-Connection("+ connectionMetaData[1]+","+connectionMetaData[2]+","+connectionMetaData[3] +")-Alert(" + msgAlertsTriggered[:-1] + ")|"+str(connectionMetaData[0])+"|"+str(connectionMetaData[5])+"|"+str(connectionMetaData[6])+"|"+str(connectionMetaData[7])+"|"+str(connectionMetaData[8])+"|"+msgPayload +"|\n"
                        print (alert)
                        file = open("/var/log/GCRDionaea.log", "a+")
                        syslog.syslog(alert)
                        file.write(alert)
                        file.close()
        cur.close()
        time.sleep(delay)
