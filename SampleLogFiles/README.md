This page contains sample log alert information from diffrent types of sensors. It also grok parser statements. (http://grokconstructor.appspot.com/)<br />
http://grokconstructor.appspot.com/do/match#result<br />
<br />
<h3>Dionaea</h3>
<h4>Simple Log</h4>
./var/log/dionaea.log (a.k.a. dionaea.log)<br />
<br />
<h5>SAMPLE LOG:</h5>
<table><tr><td>
connection|3|accept|tcp|httpd|1501693249.72|10.2.1.83|26445|10.2.1.99|80<br />
connection|2|accept|tcp|httpd|1501693249.62|10.2.1.83|26444|10.2.1.99|80<br />
connection|1|accept|tcp|httpd|1501693249.25|10.2.1.83|26439|10.2.1.99|80<br />
connection|6|accept|tcp|httpd|1501693283.28|10.2.1.83|26452|10.2.1.99|80<br />
connection|5|accept|tcp|httpd|1501693280.52|10.2.1.83|26453|10.2.1.99|80<br />
</td></tr></table>
*GROK Parser*<br />
<table><tr><td>
%{WORD:connection}\|%{NUMBER:number}\|%{WORD:type}\|%{WORD:transport}\|%{WORD:protocol}\|%{NUMBER:timestamp}\|%{IP:ip_src_addr}\|%{NUMBER:src_port}\|%{IP:ip_dst_addr}\|%{NUMBER:dst_port}?
</td></tr></table>

<h5>SAMPLE LOG(from reciving server) -> :</h5>
<table><tr><td>
Jul 27 23:47:41 honeeepi dionaealog.py: connection|5286|accept|tcp|httpd|1501199252.78|10.2.1.83|1762|10.2.1.99|80<br />
Jul 28 00:13:24 honeeepi dionaealog.py: connection|5287|accept|tcp|httpd|1501200799.33|10.2.1.83|1084|10.2.1.99|80<br />
Jul 28 00:13:44 honeeepi dionaealog.py: connection|5289|accept|tcp|httpd|1501200814.55|10.2.1.83|1126|10.2.1.99|80<br />
Jul 28 00:13:44 honeeepi dionaealog.py: connection|5288|accept|tcp|httpd|1501200808.64|10.2.1.83|1116|10.2.1.99|80<br />
Jul 28 00:59:49 honeeepi dionaealog.py: connection|5296|accept|tcp|httpd|1501203587.76|10.2.1.83|1556|10.2.1.99|80<br />
</td></tr></table>
*GROK Parser*<br />
<table><tr><td>
%{MONTH:month}%{SPACE}%{MONTHDAY:day}%{SPACE}%{HOUR:hour}:%{MINUTE:minute}:%{SECOND:seconds}%{SPACE}%{WORD:hostname}%{SPACE}%{WORD:script}.%{WORD:extension}:%{SPACE}%{WORD:connection}\|%{NUMBER:number}\|%{WORD:type}\|%{WORD:transport}\|%{WORD:protocol}\|%{NUMBER:timestamp}\|%{IP:ip_src_addr}\|%{NUMBER:src_port}\|%{IP:ip_dst_addr}\|%{NUMBER:dst_port}?
</td></tr></table>


<h4>Detailed Log</h4>
./opt/dionaea/var/log/dionaea.log (a.k.a. dionaea-opt3.log)<br />
<br />

*SAMPLE LOG:*<br />
<table><tr><td>
[08082017 15:41:39] scapy dionaea/smb/include/packet.py:666-debug: ###[ SMB Negociate Response sizeof(53) ]###  <br />
[08082017 15:41:39] scapy dionaea/smb/include/packet.py:687-debug:         WordCount           = 17              sizeof(  1) off=  0 goff= 36 <br />
[08082017 15:41:39] scapy dionaea/smb/include/packet.py:687-debug:         DialectIndex        = 9               sizeof(  2) off=  1 goff= 37 <br />
[08082017 15:41:39] scapy dionaea/smb/include/packet.py:687-debug:         SecurityMode        = 0x3             sizeof(  1) off=  3 goff= 39 <br />
[08082017 15:41:39] scapy dionaea/smb/include/packet.py:687-debug:         MaxMPXCount         = 1               sizeof(  2) off=  4 goff= 40 <br />
[08082017 15:41:39] scapy dionaea/smb/include/packet.py:687-debug:         MaxVCs              = 1               sizeof(  2) off=  6 goff= 42 <br />
[08082017 15:41:39] scapy dionaea/smb/include/packet.py:687-debug:         MaxBufferS          = 4096            sizeof(  4) off=  8 goff= 44 <br />
[08082017 15:41:39] scapy dionaea/smb/include/packet.py:687-debug:         MaxRawBuffer        = 65536           sizeof(  4) off= 12 goff= 48 <br />
[08082017 15:41:39] scapy dionaea/smb/include/packet.py:687-debug:         SessionKey          = 0               sizeof(  4) off= 16 goff= 52 <br />
[08082017 15:41:39] scapy dionaea/smb/include/packet.py:687-debug:         Capabilities        = RAW_MODE+UNICODE+LARGE_FILES+NT_SMBS+RPC_REMOTE_APIS+STATUS32+LEVEL_II_OPLOCKS+LOCK_AND_READ+NT_FIND +INFOLEVEL_PASSTHRU+LARGE_READX+LARGE_WRITEX+EXTENDED_SECURITY sizeof(  4) off= 20 goff= 56 <br />
[08082017 15:41:39] scapy dionaea/smb/include/packet.py:687-debug:         SystemTime          = datetime.datetime(2017, 8, 8, 14, 15, 27, 82303) sizeof(  8) off= 24 goff= 60 <br />
[08082017 15:41:39] scapy dionaea/smb/include/packet.py:687-debug:         SystemTimeZone      = 50431           sizeof(  2) off= 32 goff= 68 <br />
[08082017 15:41:39] scapy dionaea/smb/include/packet.py:687-debug:         KeyLength           = 0               sizeof(  1) off= 34 goff= 70 <br />
[08082017 15:41:39] scapy dionaea/smb/include/packet.py:687-debug:         ByteCount           = None            sizeof(  2) off= 35 goff= 71 <br />
[08082017 15:41:39] scapy dionaea/smb/include/packet.py:687-debug:         ServerGUID          = b'\x0b\xffe8T~lB\xa4>\x12\xd2\x11\x97\x16D' sizeof( 16) off= 37 goff= 73 <br />
[08082017 15:41:39] scapy dionaea/smb/include/packet.py:687-debug:         SecurityBlob        = b''             sizeof(  0) off= 53 goff= 89 <br />
[08082017 15:41:39] connection connection.c:1219-debug: connection_send con 0x1f3edb0 data 0x1cb9e30 size 89 <br />
[08082017 15:41:39] connection connection.c:2116-debug: connection_tcp_io_out_cb con 0x1f3edb0 <br />
[08082017 15:41:39] connection connection.c:1848-debug: connection_throttle_update con 0x1f3edb0 thr 0x1f3f1a0 bytes 89 <br />
[08082017 15:41:39] bistream bistream.c:86-debug: bistream_data_add bs 0x1ebd720 dir 1 data 0x1f125c8 size 89 <br />
 <br />
[08082017 20:48:50] processor processor.c:85-debug: processor_data_creation con 0x1a53e30 pd 0x16ea6c0 node 0xdfce30 <br />
[08082017 20:48:50] processor processor.c:90-debug: skip filter <br />
[08082017 20:48:50] processor processor.c:85-debug: processor_data_creation con 0x1a53e30 pd 0x16ea6c0 node 0xdfce60 <br />
[08082017 20:48:50] processor processor.c:94-debug: creating filter <br />
[08082017 20:48:50] processor processor.c:85-debug: processor_data_creation con 0x1a53e30 pd 0x1694528 node 0xdfce78 <br />


</td></tr></table>
<br />
*GROK Parser*<br />
<table><tr><td>
%{MONTHDAY:day}%{MONTHNUM:month}%{YEAR:year}%{SPACE}%{TIME:time}\]%{SPACE}%{WORD:event}%{SPACE}%{GREEDYDATA:filepath}:%{NUMBER:number}-%{WORD:type}:%{GREEDYDATA:payload}
</td></tr></table>


<h3>glastopf.log</h3>
glastopf.log<br />
<br />
<h3>squid</h3>

*SAMPLE LOG:*<br />
<table><tr><td>
1467011166.543    401 127.0.0.1 TCP_MISS/200 41846 GET http://www.help.1and1.co.uk/domains-c40986/transfer-domains-c79878 - DIRECT/212.227.34.3 text/html<br />
1467011168.519    445 127.0.0.1 TCP_MISS/200 336155 GET http://www.aliexpress.com/af/shoes.html? - DIRECT/207.109.73.154 text/html<br />
1467011164.286    749 127.0.0.1 TCP_MISS/200 190407 GET http://www.ebay.com/itm/02-Infiniti-QX4-Rear-spoiler-Air-deflector-Nissan-Pathfinder-/172240020293? - DIRECT/23.74.62.44 text/html<br />
<br />
</td></tr></table>
*What it means:*<br />
<table><tr><td>
timestamp | time elapsed | remotehost | code/status | bytes | method | URL rfc931 peerstatus/peerhost | type<br />
</td></tr></table>
<br />
*GROK Parser*<br />
<table><tr><td>
SQUID_DELIMITED %{NUMBER:timestamp}[^0-9]*%{INT:elapsed} %{IP:ip_src_addr} %{WORD:action}/%{NUMBER:code} %{NUMBER:bytes} %{WORD:method} %{NOTSPACE:url}[^0-9]*(%{IP:ip_dst_addr})?<br />
</td></tr></table>

<h3>OSSEC</h3>
/var/ossec/logs/alerts/alerts.log (a.k.a. ossec-alerts.log)<br />
<h5>SAMPLE LOG:</h5>
<table><tr><td>
** Alert 1502259963.0: - ossec,<br />
2017 Aug 09 06:26:03 honeeepi->ossec-logcollector<br />
Rule: 591 (level 3) -> 'Log file rotated.'<br />
ossec: File rotated (inode changed): '/var/log/messages'.<br />
<br />
** Alert 1502259963.184: - ossec,<br />
2017 Aug 09 06:26:03 honeeepi->ossec-logcollector<br />
Rule: 591 (level 3) -> 'Log file rotated.'<br />
ossec: File rotated (inode changed): '/var/log/auth.log'.<br />
<br />
** Alert 1504638699.4801: mail  - ossec,syscheck,<br />
2017 Sep 05 19:11:39 confidential-archive-server2->syscheck<br />
Rule: 550 (level 7) -> 'Integrity checksum changed.'<br />
Integrity checksum changed for: '/etc/rsyslog.conf'<br />
Size changed from '2718' to '2988'<br />
Old md5sum was: 'dbb18c440c638f5d7eab7e3e63154f64'<br />
New md5sum is : '8c37ddb3f64e35277eb1b59b0e15e6a3'<br />
Old sha1sum was: '42e52417f32b80aac5b1d0dc5e4d1ef0230dadaa'<br />
New sha1sum is : '98bd54b9170e8dcd5d42ca979961c5ec6b241c1e'<br />
<br />
** Alert 1504659681.607: - syslog,sshd,invalid_login,authentication_failed,<br />
2017 Sep 06 01:01:21 ip-172-31-12-166->/var/log/auth.log<br />
Rule: 5710 (level 5) -> 'Attempt to login using a non-existent user'<br />
Src IP: 181.21.7.9<br />
Sep  6 01:01:20 ip-172-31-12-166 sshd[7009]: Invalid user admin from 181.21.7.9<br />
<br />
** Alert 1504719298.31121: - syslog,sudo<br />
2017 Sep 06 17:34:58 ip-172-31-12-166->/var/log/auth.log<br />
Rule: 5402 (level 3) -> 'Successful sudo to ROOT executed'<br />
User: ubuntu<br />
Sep  6 17:34:58 ip-172-31-12-166 sudo:   ubuntu : TTY=pts/0 ; PWD=/ ; USER=root ; COMMAND=/usr/bin/find -name *ossec*log<br />
</td></tr></table>
