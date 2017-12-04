import time
import os
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import re
import syslog
import time
import datetime
import socket

#sudo pip install watchdog
#watchdoc code adapted from michaelcho.me

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


class Handler(FileSystemEventHandler):
    @staticmethod
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
         #macAddr=removeListChars(macAddr)
         ether=str(re.findall(r'\[.*\]', str(cmdOutput)))
         ether=removeListChars(ether)

         nic=str(re.findall(r'on\s(.*)\\n', str(cmdOutput)))
         nic=removeListChars(nic)

         returnVal = " " + macAddr +  " "
         return returnVal

    #@staticmethod
    def removeListChars(inputString):
         inputString=inputString.replace("'","")
         inputString=inputString.replace('"',"")
         inputString=inputString.replace('[',"")
         inputString=inputString.replace(']',"")
         #mstrPayload=re.sub(r'[^\x00\x7F]+',' ',mstrPayload)
         inputString= inputString.replace('"'," ")
         inputString= inputString.replace("'"," ")
         inputString= inputString.replace("`"," ")
         inputString= inputString.replace("|"," ")
         inputString= inputString.replace("\n"," ")
         returnVal2 = inputString
         return returnVal2

    @staticmethod
    def on_any_event(event):
        if event.is_directory:
            return None

        elif event.event_type == 'created':
            # Take any action here when a file is first created.
            print( "Received created event - %s." % event.src_path)

        elif event.event_type == 'modified':
            # Taken any action here when a file is modified.
            print( "Received MODIFIED event - %s" % event.src_path)
            f = open((event.src_path), "r")
            eventPath = str(event.src_path)

            eventPath=str(eventPath)
            print("eventpath->"+str(eventPath)+"<-")

            fileName = re.findall(r'((?:[^/]*/)*)(.*)',eventPath)
            fileName = os.path.basename(eventPath)
            fileName = str(fileName)


            service = re.findall(r'^(.*?)\-',fileName)[0]
            port = re.findall(r'\-(.*?)\-',fileName)[0]
            ip = re.findall(r'\-.*\-(.*?)\-',fileName)[0]
            id = re.findall(r'\-.*\-.*\-(.*?)$',fileName)[0]


            #fileName = str(re.findall(r'((?:[^/]*/)*)(.*)',eventhPath)


            print("service->"+service+"<-")
            print("port->"+port+"<-")
            print("ip->"+ip+"<-")
            print("id->"+id+"<-")

            print("servName->" + service +"<-")
            print("fileName->"+ fileName +"<-")
            print("f.read->" + f.read() + "<-")

            timeOfAlert=""
            timeOfAlert=int(str(datetime.datetime.now().timestamp() * 1000)[0:10])

            s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            try:
                 s.connect(("8.8.8.8",80))
                 hostname =socket.gethostname()
                 localIP=s.getsockname()[0]

            except:
                 print("not able to access internet")
                 localIP="0.0.0.0"

            #payload = self.removeListChars( str(f.read()) )
            alert =  str(int(timeOfAlert))+".000|"+"GCRCanary-Device|"+ hostname +"|"+ "Dionaea-BIStream("+service+")|"+"0"+"|"+str(localIP)+"|"+port+"|"+str(ip)+"|"+"0"+"|"+ " TEST " +"|\n"
            syslog.syslog(alert)

if __name__ == '__main__':
    w = Watcher()
    w.run()
