# -*- coding: utf-8 -*-
#Global Cybersecurity Resource, 2017
#
#This will extract information from dionaea.sqlite and put the information into a log file.
#This file should reside in the honeypot under the following directory. 
#/opt/dionaea/
#The script can be executed with the following command:
#sudo python3 /opt/dionaea/GCRdionaeaAlerts.py

from requests import get
import socket
import os
import syslog
import sqlite3
import sys
import time


#this function will extract details from tables based on the connectionID
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

#get hostname
hostname = socket.gethostname()

#get public IP addres
#publicIp = get('https://api.ipify.org').text
#TODO - create timeout

#get local IP address
#socket.gethostbyname(socket.gethostname())


dionaeaDatabaseFile = "/opt/dionaea/var/dionaea/dionaea.sqlite"
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


print ("Live Execution Started - Refresh Cycle: "+str(delay)+"sec \n")

while True:
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

                        alert =  str(int(connectionMetaData[4]))+".000|"+"GCRCanary-DionaeaDevice|"+ hostname +"|"+ "Connection("+ connectionMetaData[1]+","+connectionMetaData[2]+","+connectionMetaData[3] +")-Alert(" + msgAlertsTriggered[:-1] + ")|"+str(connectionMetaData[0])+"|"+str(connectionMetaData[5])+"|"+str(connectionMetaData[6])+"|"+str(connectionMetaData[7])+"|"+str(connectionMetaData[8])+"|"+msgPayload +"|\n"
                        print (alert)
                        file = open("/var/log/GCRDionaea.log", "a+")
                        syslog.syslog(alert) 
                        file.write(alert)
                        file.close()

        cur.close()
        time.sleep(delay)
