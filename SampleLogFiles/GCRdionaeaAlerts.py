#Global Cybersecurity Resource, 2017 
#
#This will extract information from sqlite and put the information into a log file
#


from requests import get
import socket
import os
import sqlite3
import sys
import time


#this function will extract details from tables based on the connectionID
def payloadDetailsConstructor(cur,table):
	msgPayload = ""
	header=""
	colnames = cur.description
	for row in colnames:
		header=header+row[0]+"\t"
		#print row[0]
	
	element=""
	details = cur.fetchall()
	subDetails=""
	
	for detail in details:
		for de in detail:
			element=element+str(de)+"\t"
		if table == "mysql_commands":
			curx=cur
			mysql_command = details[0][0]
			mysql_command_cmd = details[0][2]
			sqlx = "SELECT * FROM mysql_command_args WHERE mysql_command=" + str(mysql_command) + ";"
			curx.execute(sqlx)
			subDetails = payloadDetailsConstructor(curx,"mysql_command_args")
			print "--- >"+subDetails+" < --"
			element=element+subDetails
			sqlx = "SELECT * FROM mysql_command_ops WHERE mysql_command_cmd=" + str(mysql_command_cmd) + ";"
			curx.execute(sqlx)
			subDetails = payloadDetailsConstructor(curx,"mysql_command_ops")
			print "--- >"+subDetails+" < --"
			element=element+subDetails
			#curx.close()
		elif table == "dcerpcbinds":
			curx=cur
			dcerpcbind_uuid = details[0][2]
			sqlx = "SELECT * FROM dcerpcservices WHERE dcerpcservice_uuid='" + str(dcerpcbind_uuid) + "';"
			curx.execute(sqlx)
			subDetails = payloadDetailsConstructor(curx,"dcerpcservices")
			print "--- >"+subDetails+" < --"
			element=element+subDetails
			#curx.close()
		elif table == "dcerpcrequests":
			curx=cur
			dcerpcrequest_uuid = details[0][2]
			sqlx = "SELECT * FROM dcerpcservices WHERE dcerpcservice_uuid='" + str(dcerpcrequest_uuid) + "';"
			curx.execute(sqlx)
			subDetails = payloadDetailsConstructor(curx,"dcerpcservices")
			print "--- >"+subDetails+" < --"
			element=element+subDetails
			#curx.close()
		elif table == "sip_commands":
			curx=cur
			sip_command = details[0][0]
			sqlx = "SELECT * FROM sip_addrs WHERE sip_command=" + str(sip_command) + ";"
			curx.execute(sqlx)
			subDetails = payloadDetailsConstructor(curx,"sip_addrs")
			print "--- >"+subDetails+"< --"
			element=element+subDetails
			curx=cur
			sqlx = "SELECT * FROM sip_sdp_connectiondatas WHERE sip_command=" + str(sip_command) + ";"
			curx.execute(sqlx)
			subDetails = payloadDetailsConstructor(curx,"sip_sdp_connectiondatas")
			print "--- >"+subDetails+"< --"
			element=element+subDetails
			curx=cur
			sqlx = "SELECT * FROM sip_sdp_medias WHERE sip_command=" + str(sip_command) + ";"
			curx.execute(sqlx)
			subDetails = payloadDetailsConstructor(curx,"sip_sdp_medias")
			print "--- >"+subDetails+"< --"
			element=element+subDetails
			curx=cur
			sqlx = "SELECT * FROM sip_sdp_origins WHERE sip_command=" + str(sip_command) + ";"
			curx.execute(sqlx)
			subDetails = payloadDetailsConstructor(curx,"sip_sdp_origins")
			print "--- >"+subDetails+"< --"
			element=element+subDetails
			curx=cur
			sqlx = "SELECT * FROM sip_vias WHERE sip_command=" + str(sip_command) + ";"
			curx.execute(sqlx)
			subDetails = payloadDetailsConstructor(curx,"sip_vias")
			print "--- >"+subDetails+"< --"
			element=element+subDetails
			#curx.close()
		element=element+", "
		

		msgPayload = msgPayload + "["+table.upper()+":("+ header + ")(" +element[:-3] +")]"
	return msgPayload;



###############
##Initalization
###############
print "Copyright Global Cybersecurity Resource, 2017 \n GCRDionaea Alerts\n Initalization Started\n"
pastConnectionID=0
delay=10

#get hostname
hostname = socket.gethostname()

#get public IP addres
#publicIp = get('https://api.ipify.org').text
#TODO - create timeout


#get local IP address
#socket.gethostbyname(socket.gethostname())






dionaeaDatabaseFile = "/opt/dionaea/var/dionaea/logsql.sqlite"
#dionaeaDatabaseFile = "C:\Users\A\Downloads\sqlite-tools-win32-x86-3200100\sqlite-tools-win32-x86-3200100\logsql.sqlite"
cur = sqlite3.connect(dionaeaDatabaseFile).cursor()

#list of all tables in database
sql="SELECT name FROM sqlite_master WHERE type = 'table'"
cur.execute(sql)
tables = cur.fetchall()
tablesWithConnection=[]


#find tables that only have the connection column and create a list of tables with only connection
for table in tables:
    #print table[0]
    sql = "PRAGMA table_info('"+ table[0] +"');"
    cur.execute(sql)
    columns = cur.fetchall()
    for column in columns:
        if (column[1]) == 'connection':
            #create new list of tables that have connections
            tablesWithConnection.append(table[0])



###############
##Live Execution
###############
print "Live Execution Start with delay"+str(delay)+"\n"



while True: 

	#get last connection data
	sql = "SELECT connection,connection_type,connection_transport,connection_protocol,connection_timestamp,local_host,local_port,remote_host,remote_port FROM connections ORDER BY connection DESC LIMIT 1;"
	cur.execute(sql)
	connectionMetaData = cur.fetchall()
	connectionID=connectionMetaData[0][0]

	if int(connectionID) > int(pastConnectionID):
		pastConnectionID=connectionID
		##############
		#SQL test
		##############
		#connectionID=8734

		##############
		#DCERPC test
		##############
		#connectionID=1694
		#connectionID=7838
		#connectionID=11833
		#connectionID=18080
		#connectionID=22170


		##############
		#SIP test
		##############
		#connectionID=1009
		#connectionID=1168
		#connectionID=7780
		#connectionID=7840
		#connectionID=11211
		#connectionID=11350
		#connectionID=18031
		#connectionID=18083
		msgAlertsTriggered=""
		msgPayload = ""
		for tableWithConnection in tablesWithConnection:
			#for length of number of tables, check if a connection
			sql = "SELECT EXISTS(SELECT 1 FROM "+ tableWithConnection +" WHERE connection=" + str(connectionID) + " LIMIT 1);"
			cur.execute(sql)
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
				
				
		print "\n"
		alert =  str(connectionMetaData[0][4])[:-3]+"|"+"GCRCanary-DionaeaDevice|"+ hostname +"|"+ "Connection("+ connectionMetaData[0][1]+","+connectionMetaData[0][2]+","+connectionMetaData[0][3] +")-Alert(" + msgAlertsTriggered[:-1] + ")|"+str(connectionMetaData[0][0])+"|"+str(connectionMetaData[0][5])+"|"+str(connectionMetaData[0][6])+"|"+str(connectionMetaData[0][7])+"|"+str(connectionMetaData[0][8])+"|"+msgPayload +"\n"

		print alert 
		file = open("/var/log/GCRDionaea.log", "a+")
		#file = open("GCRDionaea.log", "a+")
		file.write(alert)
		file.close()
		#curx.close()
		cur.close()
		time.sleep(delay)
